class FbthriftAT20210215 < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server."
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2021.02.15.00.tar.gz"

  keg_only :versioned_formula

  bottle do
    root_url "https://github.com/curoky/homebrew-tap/releases/download/bottles"
    sha256 x86_64_linux: "e02cbe8f6275de85ea9b5aed45691628a4dc151f7fdbfcb20e7ae355265dea03"
  end

  depends_on :linux
  depends_on "flex" => :build
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "gcc" => :build

  depends_on "python@3.9"
  depends_on "libsodium"
  depends_on "zlib"
  depends_on "boost@1.72.0"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "folly@2021.02.15"
  depends_on "fizz@2021.02.15"
  depends_on "wangle@2021.02.15"

  def install
    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DCMAKE_C_COMPILER=#{Formula["gcc"].opt_bin}/gcc-10
      -DCMAKE_CXX_COMPILER=#{Formula["gcc"].opt_bin}/g++-10
      -Dcompiler_only=OFF
      -Dthriftpy=OFF
      -Dthriftpy3=OFF
      -Denable_tests=OFF
      -Dpython-six_FOUND=ON
      -DOPENSSL_USE_STATIC_LIBS=ON
      -DBoost_USE_STATIC_LIBS=ON
      -DBoost_INCLUDE_DIRS=#{Formula["boost@1.72.0"].include}
      -DBoost_LIBRARIES="boost_filesystem"
      -DCMAKE_PREFIX_PATH='#{Formula["libevent"].prefix};#{Formula["zlib"].prefix};#{Formula["boost@1.72.0"].prefix}'
    ]

    # mkdir "build-d" do
    #   system "cmake", *args, "..", "-DBUILD_SHARED_LIBS=ON"
    #   system "ninja"
    #   system "ninja", "install"
    # end
    mkdir "build-s" do
      system "cmake", *args, "..", "-DBUILD_SHARED_LIBS=OFF"
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
  end
end
