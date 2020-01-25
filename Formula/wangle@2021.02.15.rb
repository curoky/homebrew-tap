class WangleAT20210215 < Formula
  desc 'Modular, composable client/server abstractions framework'
  homepage 'https://github.com/facebook/wangle'
  url 'https://github.com/facebook/wangle/releases/download/v2021.02.15.00/wangle-v2021.02.15.00.tar.gz'
  license 'Apache-2.0'
  head 'https://github.com/facebook/wangle.git'

  keg_only :versioned_formula

  bottle do
    root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
    sha256 x86_64_linux: '1f28e6034ce389fd7ee327938c2e11a3e9779c7d7a4ce356bce3df0da0cc1b9f'
  end

  depends_on :linux
  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'gcc@11' => :build
  depends_on 'boost@1.72.0'
  depends_on 'double-conversion'
  depends_on 'fmt'
  depends_on 'gflags@2.2.2'
  depends_on 'glog@0.5.0'
  depends_on 'libevent'
  depends_on 'libsodium'
  depends_on 'lz4'
  depends_on 'openssl@1.1'
  depends_on 'snappy'
  depends_on 'zstd'
  depends_on 'zlib'
  depends_on 'fizz@2021.02.15'
  depends_on 'folly@2021.02.15'

  uses_from_macos 'bzip2'
  uses_from_macos 'zlib'

  def install
    gcc = Formula['gcc@11']
    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DCMAKE_C_COMPILER=#{gcc.opt_bin}/gcc-11
      -DCMAKE_CXX_COMPILER=#{gcc.opt_bin}/g++-11
      -DBUILD_TESTS=OFF
    ]

    # mkdir "wangle/build-d" do
    #   system "cmake", "..",  *args, "-DBUILD_SHARED_LIBS=ON"
    #   system "ninja"
    #   system "ninja", "install"
    # end
    mkdir 'wangle/build-s' do
      system 'cmake', '..', *args, '-DBUILD_SHARED_LIBS=OFF'
      system 'ninja'
      system 'ninja', 'install'
    end
    pkgshare.install Dir['wangle/example/echo/*.cpp']
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
    #   -L#{Formula["glog@0.5.0"].opt_lib} -lglog
    #   -L#{Formula["fizz@2021.02.15"].opt_lib} -lfizz
    #   -L#{Formula["folly@2021.02.15"].opt_lib} -lfolly
    #   -L#{Formula["boost@1.72.0"].opt_lib} -lboost_context-mt
    #   #{lib}/libwangle.a
    # ]

    # system Formula["gcc"].opt_bin/"g++-11", *cxx_flags, "-o", "EchoClient", pkgshare/"EchoClient.cpp"
    # system Formula["gcc"].opt_bin/"g++-11", *cxx_flags, "-o", "EchoServer", pkgshare/"EchoServer.cpp"

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
