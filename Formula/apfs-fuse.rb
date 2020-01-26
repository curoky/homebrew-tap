class ApfsFuse < Formula
  desc "FUSE driver for APFS (Apple File System)"
  homepage "https://github.com/sgan81/apfs-fuse"
  url "https://github.com/sgan81/apfs-fuse/archive/master.zip"

  version "latest"

  bottle do
    root_url "https://github.com/curoky/homebrew-tap/releases/download/bottles"
    sha256 x86_64_linux: "e068378e6e68e0a84e7f3b5b6772f0bfd228dc98c1d23df310fe47d1f52a800e"
  end

  depends_on :linux
  depends_on "gcc" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "zlib"
  depends_on "libfuse"

  resource "lzfse" do
    url "https://github.com/lzfse/lzfse/archive/e634ca58b4821d9f3d560cdc6df5dec02ffc93fd.zip"
  end

  def install
    resource("lzfse").stage Pathname.pwd/"3rdparty/lzfse"

    inreplace "CMakeLists.txt",
      "include_directories(. 3rdparty/lzfse/src)",
      "include_directories(. 3rdparty/lzfse/src #{Formula["zlib"].include})\n link_directories(#{Formula["zlib"].lib})"

    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DCMAKE_C_COMPILER=#{Formula["gcc"].opt_bin}/gcc-10
      -DCMAKE_CXX_COMPILER=#{Formula["gcc"].opt_bin}/g++-10
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end


  test do
  end
end
