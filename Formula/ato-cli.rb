class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.4.115"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato/releases/download/v0.4.115/ato-cli-aarch64-apple-darwin.tar.xz"
    sha256 "3837793171e9f6bd50c5ef41a9c4bf37ccbece19197778c9ad725902d3b954b1"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.4.115/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "521f7294ea9b4c831f16a41d930ac74135ee33c4be5afcbe01523e17ed7895dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.4.115/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "29dd04be4b98849d8419a3d595d0ffd7c41a526f733343c6c516b747d0760c5e"
    end
  end
  license any_of: ["Apache-2.0", "MPL-2.0"]

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
