class Nacelle < Formula
  desc "The Source Runtime for Capsules"
  homepage "https://ato.run"
  version "0.4.103"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato/releases/download/v0.4.103/nacelle-aarch64-apple-darwin.tar.xz"
    sha256 "520bb3c0f7011019d1c81ee7890139614d72a1a9d952e798e7233ee3971af62a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.4.103/nacelle-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e81f2b080d1efdc2cabc2fc5700e1bb02553f9a82cf96dad5ff701b905979932"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.4.103/nacelle-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "44f570b7e39f47eb1815e7130648689716dacce6a225897093085b39c71bb01d"
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
