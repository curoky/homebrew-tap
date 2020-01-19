class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  license "Apache-2.0"
  version "3.7.0"

  url "https://github.com/bazelbuild/bazel/releases/download/3.7.0/bazel-3.7.0-installer-linux-x86_64.sh"
  sha256 "621089dc4d396612603a55f18f55acded29d9b21534ebaa99406a0b4b05029fb"

  depends_on :linux
  depends_on "unzip" # need by installer.sh

  def install
    system "bash", "./bazel-3.7.0-installer-linux-x86_64.sh", "--prefix=#{prefix}"
    bash_completion.install "#{prefix}/lib/bazel/bin/bazel-complete.bash"
    zsh_completion.install "#{prefix}/lib/bazel/bin/_bazel"
  end

  test do
    output = shell_output("#{bin}/bazel --version")
    assert_match "bazel 3.7.0", output.strip
  end
end
