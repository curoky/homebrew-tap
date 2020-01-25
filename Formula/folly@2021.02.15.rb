class FollyAT20210215 < Formula
  desc 'Collection of reusable C++ library artifacts developed at Facebook'
  homepage 'https://github.com/facebook/folly'
  url 'https://github.com/facebook/folly/archive/v2021.02.15.00.tar.gz'
  license 'Apache-2.0'
  head 'https://github.com/facebook/folly.git'

  keg_only :versioned_formula

  bottle do
    root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
    sha256 x86_64_linux: '85cf3b169505fff13cbaf81dd4dceec9d487694bf60477f0d97d75236c7c0a46'
  end

  depends_on :linux
  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gcc@11' => :build
  depends_on 'boost@1.72.0'
  depends_on 'double-conversion'
  depends_on 'fmt'
  depends_on 'gflags@2.2.2'
  depends_on 'glog@0.5.0'
  depends_on 'zlib'
  depends_on 'libevent'
  depends_on 'libsodium'
  depends_on 'libiberty'
  depends_on 'lz4'
  depends_on 'openssl@1.1'
  depends_on 'snappy'
  depends_on 'xz'
  depends_on 'zstd'
  depends_on 'libunwind'
  depends_on 'libaio'
  depends_on 'dwarf'
  depends_on 'jemalloc'
  depends_on 'python@3.9'

  def install
    gcc = Formula['gcc@11']
    # rubocop:disable Layout/LineLength
    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DCMAKE_C_COMPILER=#{gcc.opt_bin}/gcc-11
      -DCMAKE_CXX_COMPILER=#{gcc.opt_bin}/g++-11
      -DCMAKE_PREFIX_PATH='#{Formula['boost@1.72.0'].prefix};#{Formula['zlib'].prefix};#{Formula['libsodium'].prefix};#{Formula['fmt'].prefix};#{Formula['lz4'].prefix};#{Formula['libiberty'].prefix};#{Formula['xz'].prefix};#{Formula['dwarf'].prefix}}'
    ]
    # rubocop:enable Layout/LineLength
    args << "-DFOLLY_USE_JEMALLOC=#{OS.mac? ? 'OFF' : 'ON'}"
    args << '-DCMAKE_POSITION_INDEPENDENT_CODE=ON' unless OS.mac?

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
    (testpath / 'test.cc').write <<~EOS
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    gcc_args = %W[
      -std=c++14
      -I#{include}
      #{lib}/libfolly.a
    ]
    system Formula['gcc@11'].opt_bin / 'g++-11', 'test.cc', '-o', 'test', *gcc_args
    system './test'
  end
end
