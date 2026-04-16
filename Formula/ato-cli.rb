class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.4.67"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.67/ato-cli-aarch64-apple-darwin.tar.xz"
    sha256 "81fc96d3ffe9b31b1fb54bbc027055088813f8115554d76ecd81d82202d98403"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.67/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d01225e8672e0919024fedc1d7cfda23fa73283518afcdb2b7c460d363242465"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.67/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1c133d01ad22a8807ef051ca1fe9bdb32f072b770cffeba6f896971c3ce5572c"
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
