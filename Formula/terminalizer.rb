require "language/node"

class Terminalizer < Formula
  desc "Record your terminal and generate animated gif images or share a web player"
  homepage "https://terminalizer.com/"
  url "https://registry.npmjs.org/terminalizer/-/terminalizer-0.7.2.tgz"
  sha256 "25ad22a9aa79e56192c3e0ede25fed40b5b9933ee07da4ee264357c1f6c85938"
  license "MIT"
  head "https://github.com/faressoft/terminalizer.git"

  livecheck do
    url :stable
  end

  keg_only :versioned_formula

  depends_on "node" if OS.linux?
  depends_on "node@14" if OS.mac?
  depends_on "python@3.9"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/terminalizer --version")
    assert_match "0.7.2", output.strip
  end
end
