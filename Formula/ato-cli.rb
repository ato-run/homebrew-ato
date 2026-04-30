class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.4.107"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato/releases/download/v0.4.107/ato-cli-aarch64-apple-darwin.tar.xz"
    sha256 "e72200dff30ff06ad0dd586dcfebc0209286702ab37b3859ac727936d873fe17"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.4.107/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "17aa485932a1b8c2b15cd6553826e3f9b61ad749e28250689f95f699808652a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.4.107/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d6785cdc84b8f7737273b5475eb5b13c1aa0d197820915047cb1f258999d95e7"
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
