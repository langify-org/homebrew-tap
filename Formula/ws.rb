class Ws < Formula
  desc "A CLI tool for git bare clone + worktree workflow"
  homepage "https://langify-org.github.io/ws-cli/"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.10.0/ws-aarch64-apple-darwin.tar.xz"
      sha256 "4d2aa005f0689bdb11b8af7367efaacc5cee7be16d504a8a60b9d5e564048086"
    end
    if Hardware::CPU.intel?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.10.0/ws-x86_64-apple-darwin.tar.xz"
      sha256 "8540d52d5aaf83c2571d35f764e9d9e5a4298559810bb4a64fba4e9754b60cf1"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.10.0/ws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "02e4b689ff2eee770696b2642d3c9e5578bd558c161d7409af81d2cf62ee7b31"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ws" if OS.mac? && Hardware::CPU.arm?
    bin.install "ws" if OS.mac? && Hardware::CPU.intel?
    bin.install "ws" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
