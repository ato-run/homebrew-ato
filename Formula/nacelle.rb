class Nacelle < Formula
  desc "The Source Runtime for Capsules"
  homepage "https://ato.run"
  version "0.4.90"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato/releases/download/v0.4.90/nacelle-aarch64-apple-darwin.tar.xz"
    sha256 "68593f394b60f18ce82d58bc3cdcb49726c5c8860121dc2e4207f8f6f2e491d1"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.4.90/nacelle-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5c6590f180affef587d55d450db0fa1685ba6a08f27dd3d6e0b16a4931c26aa3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.4.90/nacelle-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "818b3eede7604523a5e713602cc78dec33f3078cfb65df342cd73564a4d712fa"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "nacelle" if OS.mac? && Hardware::CPU.arm?
    bin.install "nacelle" if OS.linux? && Hardware::CPU.arm?
    bin.install "nacelle" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
