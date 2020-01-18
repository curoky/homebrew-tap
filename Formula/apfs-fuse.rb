class ApfsFuse < Formula
  desc 'FUSE driver for APFS (Apple File System)'
  homepage 'https://github.com/sgan81/apfs-fuse'
  url 'https://github.com/sgan81/apfs-fuse/archive/master.zip'
  version 'head'

  depends_on :linux
  depends_on 'gcc@11' => :build
  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'pkg-config' => :build
  depends_on 'zlib'
  depends_on 'libfuse'

  bottle do
    root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
    sha256 x86_64_linux: '3abdb2d1d6f88514aba7ff12bcb06e40224e66592675c7c9377c8ecd85f9de61'
  end

  resource 'lzfse' do
    url 'https://github.com/lzfse/lzfse/archive/e634ca58b4821d9f3d560cdc6df5dec02ffc93fd.zip'
  end

  def install
    gcc = Formula['gcc@11']

    resource('lzfse').stage Pathname.pwd / '3rdparty/lzfse'

    inreplace 'CMakeLists.txt',
              'include_directories(. 3rdparty/lzfse/src)',
              "include_directories(. 3rdparty/lzfse/src #{Formula['zlib'].include})\n link_directories(#{Formula['zlib'].lib})" # rubocop:disable Layout/LineLength

    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DCMAKE_C_COMPILER=#{gcc.opt_bin}/gcc-11
      -DCMAKE_CXX_COMPILER=#{gcc.opt_bin}/g++-11
    ]

    mkdir 'build' do
      system 'cmake', *args, '..'
      system 'ninja'
      system 'ninja', 'install'
    end
  end

  test do
  end
end
