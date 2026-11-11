class AtoCli < Formula
  desc "Ato command line interface for addressable computations"
  homepage "https://ato.run"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.9.1/ato-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9f8016d5108974fdf655fedbb569ae69acb6329a6de51ffbb098df3ab4daaec8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.9.1/ato-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ca998af3e2552fe24fd3dbaec73df1df87236054ebfd9a5fee25c91cb90c1661"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.9.1/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5a4d3a753317851e36afccb562d72d608963040d55a9526b792ce63e686b69fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.9.1/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "db1a9c417a49d476c37bb8799aa373933005154ab0220cf9f8b932bcc2478890"
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
