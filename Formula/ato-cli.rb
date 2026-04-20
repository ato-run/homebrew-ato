class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.4.70"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ato-run/ato-cli/releases/download/v0.4.70/ato-cli-aarch64-apple-darwin.tar.xz"
    sha256 "a7d19f98ebaac9a5f20bc7da7804abf99b99aeddd642edf46e8f7231d2160e1b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato-cli/releases/download/v0.4.70/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f6f2c8e55283348093f5c16e66adc819cc4a98f55b2466e263702792ae6dff48"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato-cli/releases/download/v0.4.70/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "572bd7277305c5d668bec2e41508ea30907a9b9ecae6c34ade20058a24cd25e2"
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
