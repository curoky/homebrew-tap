class JemallocProf < Formula
  desc 'Implementation of malloc emphasizing fragmentation avoidance'
  homepage 'http://jemalloc.net/'
  # url "https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2"
  url 'https://github.com/jemalloc/jemalloc/archive/refs/heads/dev.zip'
  license 'BSD-2-Clause'
  version 'head'

  bottle do
    root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
    sha256 x86_64_linux: 'f5b5cc10a603e5a04aca67da7ee0ee44dd374ba437645772b1869be8e039514f'
  end

  depends_on :linux
  depends_on 'gcc@11' => :build
  depends_on 'autoconf' => :build
  depends_on 'docbook-xsl' => :build
  depends_on 'curoky/tap/libunwind' => :build

  def install
    ENV['CC'] = Formula['gcc@11'].opt_bin / 'gcc-11'
    ENV['CXX'] = Formula['gcc@11'].opt_bin / 'g++-11'
    ENV.prepend 'CFLAGS', "-I#{Formula['curoky/tap/libunwind'].opt_include}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --with-jemalloc-prefix=
      --enable-prof
      --enable-prof-libunwind
    ]
    args << "--with-static-libunwind=#{Formula['curoky/tap/libunwind'].opt_lib}/libunwind.a"

    args << "--with-xslroot=#{Formula['docbook-xsl'].opt_prefix}/docbook-xsl"
    system './autogen.sh', *args
    system 'make', 'dist'

    system 'make'
    # system "make", "check"
    system 'make', 'install'
  end

  test do
    (testpath / 'test.c').write <<~EOS
      #include <stdlib.h>
      #include <jemalloc/jemalloc.h>
      int main(void) {
        for (size_t i = 0; i < 1000; i++) {
            // Leak some memory
            malloc(i * 100);
        }
        // Dump allocator statistics to stderr
        malloc_stats_print(NULL, NULL, NULL);
      }
    EOS
    system ENV.cc, 'test.c', "-L#{lib}", '-ljemalloc', '-o', 'test'
    system './test'
  end
end
