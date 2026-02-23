class Ws < Formula
  desc "A CLI tool for git bare clone + worktree workflow"
  homepage "https://langify-org.github.io/ws-cli/"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.8.2/ws-aarch64-apple-darwin.tar.xz"
      sha256 "96abc3accc259b747d5ae18942b02a40ec102e295a0f99b0a8c32c4ff144f6c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.8.2/ws-x86_64-apple-darwin.tar.xz"
      sha256 "72c2b4372ea6c2f473c1708984a30895d597f401aef3968408795f969627c60e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/langify-org/ws-cli/releases/download/v0.8.2/ws-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "262090dbd3b71ce61468e916e3d9829913f2382dd1fe76e5cdc89ab9266b402a"
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
