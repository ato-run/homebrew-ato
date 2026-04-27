class Nacelle < Formula
  desc "The Source Runtime for Capsules"
  homepage "https://ato.run"
  version "0.4.94"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato/releases/download/v0.4.94/nacelle-aarch64-apple-darwin.tar.xz"
    sha256 "a9eadbdd6d90c615e6e91bbe29bb0b630bcb46a1815fa56e0a212636b62738d3"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.4.94/nacelle-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d9339bb8a4349ee7e9d0e130f21c8a34e377b2d85e53c7af083ac4e75b2020d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.4.94/nacelle-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1c786e072432f49969a126e53b54ba97fe15710287bdf638f871d9d14d81986e"
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
