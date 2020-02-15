require_relative "../src/lib/boost_helper"

class BoostAT1570 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org"
  helper = @helper = @@helper = BoostHelper.new("1.57.0")
  version helper.version
  url helper.url

  keg_only :versioned_formula

  bottle do
    root_url "https://github.com/curoky/homebrew-tap/releases/download/bottles"
    sha256 x86_64_linux: "85f4b9a6cf2111350917b47e24e0975ea65f300744f49cb9393591632685812a"
  end

  depends_on :linux
  depends_on "icu4c" if OS.mac?
  depends_on "gcc" => :build
  depends_on "bzip2"
  depends_on "zlib"

  # Fix build on Xcode 11.4
  patch do
    url "https://github.com/boostorg/build/commit/b3a59d265929a213f02a451bb63cea75d668a4d9.patch?full_index=1"
    sha256 "04a4df38ed9c5a4346fbb50ae4ccc948a1440328beac03cb3586c8e2e241be08"
    directory "tools/build"
  end

  def install
    args = @@helper.install(prefix, lib)
    system "./bootstrap.sh", *args[0]
    system "./b2", "headers"
    system "./b2", *args[1]
  end

  def caveats
    return @@helper.caveats(lib)
  end

  test do
    helper.test(testpath, include, lib)
  end
end
