class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.4.68"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.68/ato-cli-aarch64-apple-darwin.tar.xz"
    sha256 "8a2bfe59ff6be1579027f7dd6af5f841846ec240bd299ea7da540f3b668eeae4"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.68/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "acb80e01a9936b20f08d2f3fd083235284b66faaca23b7353975a792c15700dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Koh0920/ato-cli/releases/download/v0.4.68/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "96af0aebafcfbfbc0113071dd97a7b8a583b0e6f1228349e097953517ff69be1"
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
