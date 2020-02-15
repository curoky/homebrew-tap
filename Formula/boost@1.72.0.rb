require_relative "../src/lib/boost_helper"

class BoostAT1720 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org"
  helper = @helper = @@helper = BoostHelper.new("1.72.0")
  version helper.version
  url helper.url

  keg_only :versioned_formula

  bottle do
    root_url "https://github.com/curoky/homebrew-tap/releases/download/bottles"
    sha256 x86_64_linux: "31dd62cbf5b717b5c149da9ccfc3f6bc9ea19ba1f6632d23ac793433624e1c0e"
  end

  depends_on :linux
  depends_on "icu4c" if OS.mac?
  depends_on "gcc" => :build
  depends_on "bzip2"
  depends_on "zlib"

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
