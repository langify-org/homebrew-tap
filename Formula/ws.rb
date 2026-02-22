class Ws < Formula
  desc "A CLI tool for git bare clone + worktree workflow"
  homepage "https://langify-org.github.io/ws-cli/"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.2.0/ws-aarch64-apple-darwin.tar.xz"
      sha256 "c488f7cb88c8c26579b03b371c0b8887fd23b07afbc103d0bd818c17f68a8bda"
    end
    if Hardware::CPU.intel?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.2.0/ws-x86_64-apple-darwin.tar.xz"
      sha256 "f0e1aec792e5ae1fc6189483c00b7a8c0275b12cbf100435988d2cefdab3d644"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.2.0/ws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "89dc124fc3a0bd2ce1260353b762d76e2b340638746949f8f02d9fdf65417d67"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ws"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ws"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ws"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
