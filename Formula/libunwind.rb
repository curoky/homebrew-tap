class Libunwind < Formula
  desc 'C API for determining the call-chain of a program'
  homepage 'https://www.nongnu.org/libunwind/'
  url 'https://download.savannah.nongnu.org/releases/libunwind/libunwind-1.5.0.tar.gz'
  sha256 '90337653d92d4a13de590781371c604f9031cdb50520366aa1e3a91e1efb1017'
  license 'MIT'

  keg_only :versioned_formula

  bottle do
    root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
    sha256 x86_64_linux: '58bc9855fec01c668f0634aa6d9fd3c65a362058083f9d1ef92a0dbb08374922'
  end

  depends_on :linux
  depends_on 'gcc@11' => :build

  uses_from_macos 'xz'
  uses_from_macos 'zlib'

  def install
    ENV['CC'] = Formula['gcc@11'].opt_bin / 'gcc-11'
    ENV['CXX'] = Formula['gcc@11'].opt_bin / 'g++-11'
    ENV.append_to_cflags '-fPIC'

    system './configure', *std_configure_args, \
           '--disable-silent-rules', '--disable-minidebuginfo'
    system 'make'
    system 'make', 'install'
  end

  test do
    (testpath / 'test.c').write <<~EOS
      #include <libunwind.h>
      int main() {
        unw_context_t uc;
        unw_getcontext(&uc);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", 'test.c', "-L#{lib}", '-lunwind', '-o', 'test'
    system './test'
  end
end
