class BazelBuildtools < Formula
  desc "A bazel BUILD file formatter and editor"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/releases/download/4.0.1/buildifier-linux-amd64"
  license "Apache-2.0"

  resource "buildozer" do
    url "https://github.com/bazelbuild/buildtools/releases/download/4.0.1/buildozer-linux-amd64"
  end
  resource "unused_deps" do
    url "https://github.com/bazelbuild/buildtools/releases/download/4.0.1/unused_deps-linux-amd64"
  end

  depends_on :linux

  def install
    bin.install "buildifier-linux-amd64" => "buildifier"
    resource("buildozer").stage { bin.install "buildozer-linux-amd64" => "buildozer" }
    resource("unused_deps").stage { bin.install "unused_deps-linux-amd64" => "unused_deps" }
  end

  test do
    build_file = testpath/"BUILD"
    touch build_file
    # test buildifier
    system "#{bin}/buildifier", "-mode=check", "BUILD"
    # test buildozer
    system "#{bin}/buildozer", "new java_library brewed", "//:__pkg__"
    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end
