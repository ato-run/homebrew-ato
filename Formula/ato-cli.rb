class AtoCli < Formula
  desc "Ato command line interface for addressable computations"
  homepage "https://ato.run"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.8.2/ato-cli-aarch64-apple-darwin.tar.xz"
      sha256 "73a91b639b855120a7d1321f5dff6da5daa1dfbb3dde79e5938a9934b8546ede"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.8.2/ato-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bf6521f107fbb945c40580772bc4f2f439eab80217e15870d8c3ed1b4113c444"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.8.2/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0f2655ec95af8dbfce1aa4e40efa018733791fb71ac6358f1758a3dc4eaca876"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.8.2/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6b13769ec5e8585344c1324d7f014e030c2df6908b212cc7386e6c02c2402b07"
    end
  end
  license "MPL-2.0"

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ato", "ato-activity-mcp", "ato-formation-session-mcp", "ato-object-graph-upload"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ato", "ato-activity-mcp", "ato-formation-session-mcp", "ato-object-graph-upload"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ato", "ato-activity-mcp", "ato-formation-session-mcp", "ato-object-graph-upload"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ato", "ato-activity-mcp", "ato-formation-session-mcp", "ato-object-graph-upload"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
