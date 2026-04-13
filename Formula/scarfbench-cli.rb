class ScarfbenchCli < Formula
  desc "CLI for running, testing, and evaluating SCARF benchmark applications."
  homepage "https://ibm.github.io/scarfbench"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scarfbench/scarfbench-cli/releases/download/v0.1.2/scarfbench-cli-aarch64-apple-darwin.tar.xz"
      sha256 "30abd5b3f6d910d2dff0ce69c3f03ee0c868beaa11edd20b795a1a6b63baa2d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scarfbench/scarfbench-cli/releases/download/v0.1.2/scarfbench-cli-x86_64-apple-darwin.tar.xz"
      sha256 "df9a8e1ff3b18abfe7e70abc0ec35de841358b254f73e2247efc52a306275f8f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/scarfbench/scarfbench-cli/releases/download/v0.1.2/scarfbench-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c2ba52a2b2ed180f260bfe4810bbca3014817edaafb0c8234b316499af4b4719"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scarfbench/scarfbench-cli/releases/download/v0.1.2/scarfbench-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "608f0867e1b28f5047a801952c6de8305caf80bc4d105d30497d0638d77d1cd7"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
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
