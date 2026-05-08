class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.5.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato/releases/download/v0.5.1/ato-cli-aarch64-apple-darwin.tar.xz"
    sha256 "aecdf3b5dd7c2754f305727437668372c900318ab10ba0169d53d6f1ef652902"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.5.1/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "948d26088c2700dc30648c4a8e791751be2f261c7043ebeb37716c44137f9a0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.5.1/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c7e797e236567e9f236f74c87b91d182f55f45227929c3ed6937b2193a8a88d1"
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
