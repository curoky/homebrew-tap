class BazelAT3 < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  license "Apache-2.0"
  version "4.0.0"

  url "https://github.com/bazelbuild/bazel/releases/download/#{version}/bazel-#{version}-installer-linux-x86_64.sh"

  depends_on :linux
  depends_on "unzip" # need by installer.sh

  def install
    system "bash", "./bazel-#{version}-installer-linux-x86_64.sh", "--prefix=#{prefix}"
    bash_completion.install "#{prefix}/lib/bazel/bin/bazel-complete.bash"
    zsh_completion.install "#{prefix}/lib/bazel/bin/_bazel"
  end

  test do
    output = shell_output("#{bin}/bazel --version")
    assert_match "bazel #{version}", output.strip
  end
end
