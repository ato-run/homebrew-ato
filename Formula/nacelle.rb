class Nacelle < Formula
  desc "The Source Runtime for Capsules"
  homepage "https://ato.run"
  version "0.4.101"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato/releases/download/v0.4.101/nacelle-aarch64-apple-darwin.tar.xz"
    sha256 "4eb7145dfba77ec02c7660ba426cd1d420689f2bed75cc07ca3f555a41402957"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.4.101/nacelle-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "301c2b517eac5be201c48a1e9ab91f6a2bc3ac44911ef437efec778fed60497b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.4.101/nacelle-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3ad08cb8b10db25789f9bd69a8b1db6dcfab7a49ca3989666a124022771b6c4d"
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
