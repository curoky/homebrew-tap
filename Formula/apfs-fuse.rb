class ApfsFuse < Formula
  desc "FUSE driver for APFS (Apple File System)"
  homepage "https://github.com/sgan81/apfs-fuse"
  url "https://github.com/sgan81/apfs-fuse/archive/master.zip"

  version "latest"

  depends_on :linux
  depends_on "gcc" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "zlib"
  depends_on "libfuse@3"

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
