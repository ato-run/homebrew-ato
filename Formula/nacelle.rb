class Nacelle < Formula
  desc "The Source Runtime for Capsules"
  homepage "https://ato.run"
  version "0.4.112"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato/releases/download/v0.4.112/nacelle-aarch64-apple-darwin.tar.xz"
    sha256 "f47f49f484420b3c3d0f122c8849db5891ed6d2e212005fad61e9a1d849475a5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.4.112/nacelle-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "463cf49bc6094e757bc73ce14d661f170874658265c0f2bc38a44a73d66d3648"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.4.112/nacelle-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "009e3ce69f88f7789d8524691c77e0cb64a9019cf29d0118986fb8f5ea0100a7"
    end
  end
  license "MPL-2.0"

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
