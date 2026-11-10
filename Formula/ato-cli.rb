class AtoCli < Formula
  desc "Ato command line interface for addressable computations"
  homepage "https://ato.run"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.9.0/ato-cli-aarch64-apple-darwin.tar.xz"
      sha256 "090b05cc52a9563ea07f2ddcf39b5a8da630f4b37574a60c999f02ccb29b2494"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.9.0/ato-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d328a61ab17b84a15ca1cb48b28ea246dcd389ce0b724a1f4cd88d528c2c5d86"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.9.0/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4957a666768a101374fb9ef580d6ff3dc824d72d17fc51ce944f8893d3eb275f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.9.0/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7985224c544d8002f2eff9d45c727741e35ad5aef542e7bfebe028d54c58491b"
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
