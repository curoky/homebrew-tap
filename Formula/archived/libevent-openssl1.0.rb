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

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "openssl@1.0.2t"
  depends_on "gcc" => :build

  def install
    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DEVENT__DISABLE_BENCHMARK=OFF
      -DEVENT__DISABLE_TESTS=OFF
      -DEVENT__DISABLE_REGRESS=OFF
      -DEVENT__DISABLE_SAMPLES=OFF
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.0.2t"].prefix}
      -DCMAKE_PREFIX_PATH=#{Formula["openssl@1.0.2t"].prefix}
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "ninja"
      system "ninja", "install"
    end
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
