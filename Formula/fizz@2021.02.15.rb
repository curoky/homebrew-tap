class FizzAT20210215 < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.02.15.00/fizz-v2021.02.15.00.tar.gz"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  keg_only :versioned_formula

  bottle do
    root_url "https://github.com/curoky/homebrew-tap/releases/download/bottles"
    sha256 x86_64_linux: "a471eb157723798d1bc04f02107f737b040f7cefdc0fe0d129b17ea04c70c1b8"
  end

  depends_on :linux
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "gcc" => :build
  depends_on "boost@1.72.0"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags@2.2.2"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "zstd"
  depends_on "zlib"

  depends_on "folly@2021.02.15"

  def install
    ENV.append "CXXFLAGS", "-I#{Formula["zlib"].opt_include}"
    ENV.append "CXXFLAGS", "-L#{Formula["zlib"].opt_lib}"
    ENV.append "CXXFLAGS", "-lz"

    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DCMAKE_C_COMPILER=#{Formula["gcc"].opt_bin}/gcc-10
      -DCMAKE_CXX_COMPILER=#{Formula["gcc"].opt_bin}/g++-10
      -DBUILD_TESTS=OFF
      -DCMAKE_PREFIX_PATH='#{Formula["boost@1.72.0"].prefix}'
    ]

    # mkdir "fizz/build-d" do
    #   system "cmake", *args, "..", "-DBUILD_SHARED_LIBS=ON"
    #   system "ninja"
    #   system "ninja", "install"
    # end
    mkdir "fizz/build-s" do
      system "cmake", *args, "..",  "-DBUILD_SHARED_LIBS=OFF"
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fizz/client/AsyncFizzClient.h>
      #include <iostream>
      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    EOS
    gcc_args = %W[
      -std=c++14
      -I#{include}
      -I#{Formula["boost@1.72.0"].opt_include}
      -I#{Formula["openssl@1.1"].opt_include}
      -I#{Formula["folly@2021.02.15"].opt_include}
      -I#{Formula["libsodium"].opt_include}
      -L#{Formula["gflags@2.2.2"].opt_lib} -lgflags
      -L#{Formula["double-conversion"].opt_lib} -ldouble-conversion
      -L#{Formula["glog"].opt_lib} -lglog
      -L#{Formula["libevent"].opt_lib} -levent
      -L#{Formula["openssl@1.1"].opt_lib} -lcrypto -lssl
      #{lib}/libfizz.a
      #{Formula["folly@2021.02.15"].opt_lib}/libfolly.a
      #{Formula["libsodium"].opt_lib}/libsodium.a
    ]
    system Formula["gcc"].opt_bin/"g++-10", "test.cpp", "-o", "test", *gcc_args

    assert_match "TLS", shell_output("./test")
  end
end
