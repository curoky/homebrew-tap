class LibeventOpenssl10 < Formula
  desc "Asynchronous event library"
  homepage "https://libevent.org/"
  url "https://github.com/libevent/libevent/archive/release-2.1.12-stable.tar.gz"
  sha256 "7180a979aaa7000e1264da484f712d403fcf7679b1e9212c4e3d09f5c93efc24"
  license "BSD-3-Clause"

  keg_only :versioned_formula

  livecheck do
    url :homepage
    regex(/libevent[._-]v?(\d+(?:\.\d+)+)-stable/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.0.2u"
  depends_on "gcc@10"

  def install
    ENV["CC"] = Formula["gcc@10"].opt_bin/"gcc-10"
    ENV["CXX"] = Formula["gcc@10"].opt_bin/"g++-10"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <event2/event.h>

      int main()
      {
        struct event_base *base;
        base = event_base_new();
        event_base_free(base);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-levent", "-o", "test"
    ENV.append "LD_LIBRARY_PATH", lib
    system "./test"
  end
end
