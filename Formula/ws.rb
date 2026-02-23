class Ws < Formula
  desc "A CLI tool for git bare clone + worktree workflow"
  homepage "https://langify-org.github.io/ws-cli/"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.5.0/ws-aarch64-apple-darwin.tar.xz"
      sha256 "821ae7a31ac22adaddf019f06664f0b09daa05bac7b741282a192ab3d0095967"
    end
    if Hardware::CPU.intel?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.5.0/ws-x86_64-apple-darwin.tar.xz"
      sha256 "9d034b6ca4e12c943ff0ac0985f55438bf3e4f1f9871131b20798090d01ef1c6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.5.0/ws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "480296aa9f52b3229170b222b41d554fcd59b70230b54e236a6618fc623c33d8"
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
