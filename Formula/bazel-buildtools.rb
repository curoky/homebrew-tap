class BazelBuildtools < Formula
  desc "A bazel BUILD file formatter and editor"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/releases/download/3.5.0/buildifier"
  sha256 "f9a9c082b8190b9260fce2986aeba02a25d41c00178855a1425e1ce6f1169843"
  license "Apache-2.0"

  resource "buildozer" do
    url "https://github.com/bazelbuild/buildtools/releases/download/3.5.0/buildozer"
    sha256 "0a5a33891dd467560d00e5d162972ab9e4eca6974f061b1b34225e5bc5e978f4"
  end
  resource "unused_deps" do
    url "https://github.com/bazelbuild/buildtools/releases/download/3.5.0/unused_deps"
    sha256 "1b86f073e373a24aec437d6de5b2c1851b74a37899353b5dbafcd23548dc28c9"
  end

  depends_on :linux

  def install
    bin.install "buildifier"
    resource("buildozer").stage { bin.install "buildozer" }
    resource("unused_deps").stage { bin.install "unused_deps" }
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
