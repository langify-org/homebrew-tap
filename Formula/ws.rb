class Ws < Formula
  desc "A CLI tool for git bare clone + worktree workflow"
  homepage "https://langify-org.github.io/ws-cli/"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.6.0/ws-aarch64-apple-darwin.tar.xz"
      sha256 "4387b2ed255d87ec3849fb66e60ef7194ea8ade74b3841812f8a27fff4bd1ed9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.6.0/ws-x86_64-apple-darwin.tar.xz"
      sha256 "808d32122403411077f70959f6b3c5cfcbc3270fbcb3c37d8932cecdfea53f8f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.6.0/ws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f9fb9d39424561d84cd627a750f5e3c2615a23e59387fff1d33f711e09126333"
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
