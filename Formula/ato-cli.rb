class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.5.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato/releases/download/v0.5.2/ato-cli-aarch64-apple-darwin.tar.xz"
    sha256 "b303163df9cd9f196de803d8dc2fe58e94fc33968d40b57c01f1a7fa39420b8d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.5.2/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "090991c6eeb6a3363815338c389f66317bf60e9103eae07e659c25a37d016789"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.5.2/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8af9256b3593ace0739ce0a90802967403ea73658aeda6b25c9cc582a3c32d8b"
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
