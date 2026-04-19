class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.4.69"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.69/ato-cli-aarch64-apple-darwin.tar.xz"
    sha256 "f0788fff6d08fee837a112f697e71ace01f2157b1da8cf01181517090d679774"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.69/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9871c6a968054bdef6646f6d983974cbbf85e5269781ffc2a75d94ee2392a2e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.69/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ecf421d60712f96ce04b6e8029a1a6347e01217da08023f49fee6ad04fefb4d3"
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
