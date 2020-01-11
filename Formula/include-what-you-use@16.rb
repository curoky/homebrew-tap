class IncludeWhatYouUseAT16 < Formula
  desc 'Tool to analyze #includes in C and C++ source files'
  homepage 'https://include-what-you-use.org/'
  # url 'https://github.com/include-what-you-use/include-what-you-use/archive/master.tar.gz'
  version 'latest'
  url 'https://include-what-you-use.org/downloads/include-what-you-use-0.16.src.tar.gz'
  license 'NCSA'

  # bottle do
  #   root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
  #   sha256 x86_64_linux: '652174b1fde48c99d51c6fcd320e898445d4f46dc1c9c253ce19c813699fb762'
  # end

  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'llvm'
  depends_on 'zlib'

  def install
    llvm = Formula['llvm']

    args = std_cmake_args + %W[
      -GNinja
      --log-level=WARNING
      -DCMAKE_INSTALL_PREFIX=#{libexec}
      -DCMAKE_PREFIX_PATH=#{llvm.opt_lib}
      -DCMAKE_CXX_FLAGS=-std=gnu++14
    ]
    # -DCMAKE_C_COMPILER=#{llvm.bin}/clang
    # -DCMAKE_CXX_COMPILER=#{llvm.bin}/clang++
    # -DIWYU_LINK_CLANG_DYLIB=OFF
    # -DCMAKE_CXX_FLAGS='-stdlib=libc++'

    mkdir 'build' do
      system 'cmake', *args, '..'
      system 'ninja'
      system 'ninja', 'install'
    end

    bin.write_exec_script Dir["#{libexec}/bin/*"]

    (libexec / 'lib').install_symlink llvm.opt_lib / 'clang'
    (libexec / 'include').install_symlink llvm.opt_include / 'c++'
  end

  test do
    output = shell_output("#{bin}/include-what-you-use --version")
    assert_match 'include-what-you-use 0.16', output.strip
  end
end
