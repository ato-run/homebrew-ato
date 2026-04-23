class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.4.75"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato-cli/releases/download/v0.4.75/ato-cli-aarch64-apple-darwin.tar.xz"
    sha256 "e2f76bb243c61cdeaef9809bb06a1cc423ced7bf24b87579721b736477bb1634"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato-cli/releases/download/v0.4.75/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8fa7c3df6499665dbba320e6c02f62e3465f5b5cdc818c767026aa39c768f58a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato-cli/releases/download/v0.4.75/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "501fc250bb82bef126a65c0d84bd5c6f399b1072befcc3ecc0969fc2b0b08515"
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
