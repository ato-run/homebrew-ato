class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.4.64"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.64/ato-cli-aarch64-apple-darwin.tar.xz"
      sha256 "dcb7259b653962d0dfae83ac25ffa18d9e9f99b6fbd337ec072edcea3ae4b8c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.64/ato-cli-x86_64-apple-darwin.tar.xz"
      sha256 "687604ac30c6f5c836792c61a0b331cdb3d43881f04f197819bff66fdc95b221"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.64/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "06b4a5698ffc79a04d08bdf0e6edfc629f4a1823a564ae7b95f1a20d96835f15"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.64/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d1c1c031eb01ba9a63e1599924917b37b52d22f561ebce04b2fb0b99592207e1"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "ato" if OS.mac? && Hardware::CPU.intel?
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
