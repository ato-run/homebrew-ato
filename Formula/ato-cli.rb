class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.4.63"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.63/ato-cli-aarch64-apple-darwin.tar.xz"
      sha256 "53b36408f79045e9af7ac22e2f7e9da2747e584e17ae0cf76d2b12e9839e354f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.63/ato-cli-x86_64-apple-darwin.tar.xz"
      sha256 "92fea73e079569092b8e4ebb26070f5aab7f8b07a80bc53aaad1bc086848ddef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.63/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "424eb1fefcd268e21c420d0e4de74cdd7acded67a7ff545ffce0bf45c1574aac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.63/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "17b4173151f8725c76eb7def05a25599deea89cd386d98fa91e49727d7b8d01e"
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
