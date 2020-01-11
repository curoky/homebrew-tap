class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  license "Apache-2.0"
  version "3.7.0"

  if OS.mac?
    url "https://github.com/bazelbuild/bazel/releases/download/3.7.0/bazel-3.7.0-installer-darwin-x86_64.sh"
    sha256 "436d32ffed7dec442060919be50e1b2076b07302aca55f9ac78cc489eaadc7c9"
  elsif OS.linux?
    url "https://github.com/bazelbuild/bazel/releases/download/3.7.0/bazel-3.7.0-installer-linux-x86_64.sh"
    sha256 "621089dc4d396612603a55f18f55acded29d9b21534ebaa99406a0b4b05029fb"
  end

  # need by installer.sh
  depends_on "unzip"

  keg_only :versioned_formula

  def install
    fiename = OS.mac? ? "bazel-3.7.0-installer-darwin-x86_64.sh" : "bazel-3.7.0-installer-linux-x86_64.sh"
    system "bash", "./"+fiename, "--prefix=#{prefix}"
    bash_completion.install "#{prefix}/lib/bazel/bin/bazel-complete.bash"
    zsh_completion.install "#{prefix}/lib/bazel/bin/_bazel"
  end

  test do
    output = shell_output("#{bin}/bazel --version")
    assert_match "bazel 3.7.0", output.strip
  end
end
