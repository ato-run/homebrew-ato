class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.4.73"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato-cli/releases/download/v0.4.73/ato-cli-aarch64-apple-darwin.tar.xz"
    sha256 "2711460281e2e1fe755c5c8754a00b82f3a8746afcd5300af7baad03d5ccf5a2"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato-cli/releases/download/v0.4.73/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b5b8777f165326007f1063ff16ebb5a1d86c025a8f574f2f3d004fce05f68152"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato-cli/releases/download/v0.4.73/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "647e107c5b5bad39ff18637fbff170d14fe2dc357aba0818ff7985515368021c"
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
