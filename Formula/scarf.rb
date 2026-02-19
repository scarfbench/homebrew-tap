class Scarf < Formula
  desc "CLI for running, testing, and evaluating SCARF benchmark applications."
  homepage "https://github.com/scarfbench/scarf"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/scarfbench/scarf/releases/download/v0.1.0/scarfbench-cli-aarch64-apple-darwin.tar.xz"
      sha256 "935905ea2e79a9713b06222201b2eb5505a632afeabf8760e90295c862ae8ce5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scarfbench/scarf/releases/download/v0.1.0/scarfbench-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3f086080447a3654322fee0eda445ca9898c53b7b2ec8f7c7164a29044acdf9f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/scarfbench/scarf/releases/download/v0.1.0/scarfbench-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ad969e4521526b39511e72390aabdcfeac60bb8e07b4c0ac94fd92f0e16bbd40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/scarfbench/scarf/releases/download/v0.1.0/scarfbench-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e0610ad91fc74f257410b3e4b50302cc780354b8a3d1396c1e0dfddb4601bac7"
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
