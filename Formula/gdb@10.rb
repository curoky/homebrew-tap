class GdbAT10 < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-10.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-10.1.tar.xz"
  sha256 "f82f1eceeec14a3afa2de8d9b0d3c91d5a3820e23e0a01bbb70ef9f0276b62c0"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git"

  depends_on :linux
  depends_on "python@3.9"
  depends_on "gcc@10" => :build
  depends_on "xz" # required for lzma support
  depends_on "pkg-config" => :build
  depends_on "guile"
  depends_on "texinfo"

  def install
    args = %W[
      --enable-targets=all
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --with-python=#{Formula["python@3.9"].opt_bin}/python3
      --disable-binutils
    ]

    ENV["CC"] = Formula["gcc@10"].opt_bin/"gcc-10"
    ENV["CXX"] = Formula["gcc@10"].opt_bin/"g++-10"
    ENV.append "CPPFLAGS", "-I#{Formula["python@3.9"].opt_libexec}" unless OS.mac?

    mkdir "build" do
      system "../configure", *args
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
