class WangleAT20210215 < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2021.02.15.00/wangle-v2021.02.15.00.tar.gz"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git"

  keg_only :versioned_formula

  bottle do
    root_url "https://github.com/curoky/homebrew-tap/releases/download/bottles"
    sha256 x86_64_linux: "d35dfa043e74da02d8439842337dd560511b5b01350ce75fcb5d3214f76f06c7"
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
  depends_on "fizz@2021.02.15"
  depends_on "folly@2021.02.15"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DCMAKE_C_COMPILER=#{Formula["gcc"].opt_bin}/gcc-10
      -DCMAKE_CXX_COMPILER=#{Formula["gcc"].opt_bin}/g++-10
      -DBUILD_TESTS=OFF
    ]

    # mkdir "wangle/build-d" do
    #   system "cmake", "..",  *args, "-DBUILD_SHARED_LIBS=ON"
    #   system "ninja"
    #   system "ninja", "install"
    # end
    mkdir "wangle/build-s" do
      system "cmake", "..",  *args, "-DBUILD_SHARED_LIBS=OFF"
      system "ninja"
      system "ninja", "install"
    end
    pkgshare.install Dir["wangle/example/echo/*.cpp"]
  end

  test do
    # cxx_flags = %W[
    #   -std=c++14
    #   -lpthread
    #   -I#{include}
    #   -I#{Formula["boost@1.72.0"].opt_include}
    #   -I#{Formula["folly@2021.02.15"].opt_include}
    #   -I#{Formula["openssl@1.1"].opt_include}
    #   -L#{Formula["gflags@2.2.2"].opt_lib} -lgflags
    #   -L#{Formula["glog"].opt_lib} -lglog
    #   -L#{Formula["fizz@2021.02.15"].opt_lib} -lfizz
    #   -L#{Formula["folly@2021.02.15"].opt_lib} -lfolly
    #   -L#{Formula["boost@1.72.0"].opt_lib} -lboost_context-mt
    #   #{lib}/libwangle.a
    # ]

    # system Formula["gcc"].opt_bin/"g++-10", *cxx_flags, "-o", "EchoClient", pkgshare/"EchoClient.cpp"
    # system Formula["gcc"].opt_bin/"g++-10", *cxx_flags, "-o", "EchoServer", pkgshare/"EchoServer.cpp"

    # port = free_port

    # fork { exec testpath/"EchoServer", "-port", port.to_s }
    # sleep 2

    # require "pty"
    # r, w, pid = PTY.spawn(testpath/"EchoClient", "-port", port.to_s)
    # w.write "Hello from Homebrew!\nAnother test line.\n"
    # sleep 1
    # Process.kill("TERM", pid)
    # output = r.read
    # assert_match("Hello from Homebrew!", output)
    # assert_match("Another test line.", output)
  end
end
