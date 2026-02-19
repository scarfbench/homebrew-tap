class ScarfbenchCli < Formula
  desc "CLI for running, testing, and evaluating SCARF benchmark applications."
  homepage "https://github.com/scarfbench/scarf"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scarfbench/scarf/releases/download/v0.1.1/scarfbench-cli-aarch64-apple-darwin.tar.xz"
      sha256 "29bfb8f686910c49e6088c55b3b3ec9cbf1c819fe706230573a52910fd221580"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scarfbench/scarf/releases/download/v0.1.1/scarfbench-cli-x86_64-apple-darwin.tar.xz"
      sha256 "488e99f3b5b6192e20f51741a09048e584a1ae3946934b06a0e21e8166665747"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/scarfbench/scarf/releases/download/v0.1.1/scarfbench-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "84f86cc0ce418244080a3786cd87e8c33b7c35b7a3dd921363917a863c4a18ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scarfbench/scarf/releases/download/v0.1.1/scarfbench-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "865a05db7ba6d8b52ca896d5fecdfd3eafebfd622d506f58a29d17107b5f584b"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "scarf" if OS.mac? && Hardware::CPU.arm?
    bin.install "scarf" if OS.mac? && Hardware::CPU.intel?
    bin.install "scarf" if OS.linux? && Hardware::CPU.arm?
    bin.install "scarf" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
