class AtoCli < Formula
  desc "Ato command line interface for addressable computations"
  homepage "https://ato.run"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.8.2/ato-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a53d1c64329ef8066e437ab26ab6aa055d41dead60943c3da7dc41f29a66d132"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.8.2/ato-cli-x86_64-apple-darwin.tar.xz"
      sha256 "88c4c2e267e9b9049fb5e2e1ab42389fddae1e05099bd08eac7363468f862e46"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ato-run/ato/releases/download/v0.8.2/ato-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a8956db31ca97ce0690a8d9f978da3243405de7c8401d8d4dcce8ff5afa46547"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ato-run/ato/releases/download/v0.8.2/ato-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2d02200470218e2cbc31728d704f7566e8e31616e47b6718a3fb813826a2968"
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
