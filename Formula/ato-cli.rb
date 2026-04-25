class AtoCli < Formula
  desc "ato CLI (meta-runtime)"
  homepage "https://ato.run"
  version "0.4.84"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato-cli/releases/download/v0.4.84/ato-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6406e02a86b9b6ce64d82a7abcdd579089949568f73853a5f1f4e92ab46b8931"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato-cli/releases/download/v0.4.84/ato-cli-x86_64-apple-darwin.tar.xz"
      sha256 "78158e2b5387123c72fdd0fad4785ac48b063f2e6d7b5a55b3d2ce4511706b2a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato-cli/releases/download/v0.4.84/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "971db29508aa92cad704fb840269e6d09d4142a59ad8a03c15d36d361bf5bc4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato-cli/releases/download/v0.4.84/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "12faba90ee5e28d63344aea167d45b963936f4148aeb8668ed9cefb5bfcbbea1"
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
