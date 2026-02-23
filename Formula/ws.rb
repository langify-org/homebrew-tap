class Ws < Formula
  desc "A CLI tool for git bare clone + worktree workflow"
  homepage "https://langify-org.github.io/ws-cli/"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.8.0/ws-aarch64-apple-darwin.tar.xz"
      sha256 "5452d03b756966912d307d38f2de0bc45d06ce8ff5379d9123b917f95d81e944"
    end
    if Hardware::CPU.intel?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.8.0/ws-x86_64-apple-darwin.tar.xz"
      sha256 "af7d078f2fae17d5e5f3ff6ebd9d947c403956bb329a6e7a096b64d736024f0f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.8.0/ws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "764f0a9ac66cb020183c9d95e141b4ffd0498741a3b82e4ee1abe7ffbd971e7b"
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
