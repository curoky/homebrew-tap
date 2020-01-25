require "os/linux/glibc"

class Libiberty < Formula
  desc "The libiberty library is a collection of subroutines used by various GNU programs."
  homepage "https://gcc.gnu.org/onlinedocs/libiberty"
  url "https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz"
  sha256 "b8dd4368bb9c7f0b98188317ee0254dd8cc99d1e3a18d0ff146c855fe16c1d8c"
  license "GPL-3.0"

  keg_only :versioned_formula

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-install-libiberty
    ]

    mkdir "build" do
      ENV.append_to_cflags "-fPIC"
      system "../libiberty/configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    ohai "Test complete."
  end
end
