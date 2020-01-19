class FbthriftAT20210215 < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server."
  homepage 'https://github.com/facebook/fbthrift'
  url 'https://github.com/facebook/fbthrift/archive/v2021.02.15.00.tar.gz'

  keg_only :versioned_formula

  bottle do
    root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
    sha256 x86_64_linux: 'e1a1c9ab2418fe5d540db4bf93fe63b07df8db0f874ce8fad6786c6445b09ba0'
  end

  depends_on :linux
  depends_on 'flex' => :build
  depends_on 'bison' => :build
  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'gcc@11' => :build

  depends_on 'python@3.9'
  depends_on 'libsodium'
  depends_on 'zlib'
  depends_on 'boost@1.72.0'
  depends_on 'libevent'
  depends_on 'openssl@1.1'
  depends_on 'folly@2021.02.15'
  depends_on 'fizz@2021.02.15'
  depends_on 'wangle@2021.02.15'

  def install
    gcc = Formula['gcc@11']
    boost = Formula['boost@1.72.0']

    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DCMAKE_C_COMPILER=#{gcc.opt_bin}/gcc-11
      -DCMAKE_CXX_COMPILER=#{gcc.opt_bin}/g++-11
      -Dcompiler_only=OFF
      -Dthriftpy=OFF
      -Dthriftpy3=OFF
      -Denable_tests=OFF
      -Dpython-six_FOUND=ON
      -DOPENSSL_USE_STATIC_LIBS=ON
      -DBoost_USE_STATIC_LIBS=ON
      -DBoost_INCLUDE_DIRS=#{boost.include}
      -DBoost_LIBRARIES="boost_filesystem"
      -DCMAKE_PREFIX_PATH='#{Formula['libevent'].prefix};#{Formula['zlib'].prefix};#{boost.prefix}'
    ]

    # mkdir "build-d" do
    #   system "cmake", *args, "..", "-DBUILD_SHARED_LIBS=ON"
    #   system "ninja"
    #   system "ninja", "install"
    # end
    mkdir 'build-s' do
      system 'cmake', *args, '..', '-DBUILD_SHARED_LIBS=OFF'
      system 'ninja'
      system 'ninja', 'install'
    end
  end

  test do
  end
end
