class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.4.78"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato-cli/releases/download/v0.4.78/ato-cli-aarch64-apple-darwin.tar.xz"
    sha256 "8f2e81bfc2091d6627d1f075844afab0b76c3a678441fa2b322075d03d68d8ca"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato-cli/releases/download/v0.4.78/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a74fcd9c48417f07d503aaf6394051316f05eef85ca4da68793b04cda5814763"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato-cli/releases/download/v0.4.78/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5f5f4b922a162a78c7456acdc96a1d53737a0f51720bc84e1f9cd2d59be6819b"
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
    bin.install "ato" if OS.mac? && Hardware::CPU.arm?
    bin.install "ato" if OS.linux? && Hardware::CPU.arm?
    bin.install "ato" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
