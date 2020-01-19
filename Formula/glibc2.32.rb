require "os/linux/glibc"

class Glibc232 < Formula
  desc "GNU C Library"
  homepage "https://www.gnu.org/software/libc/"
  url "https://ftp.gnu.org/gnu/glibc/glibc-2.32.tar.gz"
  sha256 "f52e5bdc6607cb692c0f7134b75b3ba34b5121628a1750c03e3c9aa0b9d9e65a"

  bottle do
    root_url "https://github.com/curoky/homebrew-tap/releases/download/bottles"
    sha256 x86_64_linux: "98e24a3eee420a9bde9b85f60863b1297d8db8edf7e7204bb6b90f80dac0d893"
  end

  depends_on :linux
  depends_on "binutils" => :build
  depends_on "gawk" => :build
  depends_on "linux-headers" => :build
  depends_on "make" => :build
  depends_on "gnu-sed" => :build
  depends_on "bison" => :build
  depends_on "gcc" => :build
  depends_on "gettext" => :build
  depends_on "texinfo" => :build

  keg_only :versioned_formula

  def install
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-10"
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-10"

    # Fix Error: `loc1@GLIBC_2.2.5' can't be versioned to common symbol 'loc1'
    # See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=869717
    # inreplace "misc/regexp.c", /^(char \*loc[12s]);$/, "\\1 __attribute__ ((nocommon));"

    # Setting RPATH breaks glibc.
    %w[
      LDFLAGS LD_LIBRARY_PATH LD_RUN_PATH LIBRARY_PATH
      HOMEBREW_DYNAMIC_LINKER HOMEBREW_LIBRARY_PATHS HOMEBREW_RPATH_PATHS
    ].each { |x| ENV.delete x }

    gcc_keg = begin
      Keg.for HOMEBREW_PREFIX/"bin"/ENV.cc
    rescue Errno::ENOENT, NotAKegError
      nil
    end
    if gcc_keg
      # Use the original GCC specs file.
      specs = Pathname.new(Utils.safe_popen_read(ENV.cc, "-print-file-name=specs.orig").chomp)
      raise "The original GCC specs file is missing: #{specs}" unless specs.readable?

      ENV["LDFLAGS"] = "-specs=#{specs}"

      # Fix error ld: cannot find -lc when upgrading glibc and compiling with a brewed gcc.
      ENV["BUILD_LDFLAGS"] = "-L#{opt_lib}" if opt_lib.directory?
    end

    # Use brewed ld.so.preload rather than the hotst's /etc/ld.so.preload
    inreplace "elf/rtld.c", '= "/etc/ld.so.preload";', '= SYSCONFDIR "/ld.so.preload";'

    mkdir "build" do
      args = [
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--enable-obsolete-rpc",
        # Fix error: selinux/selinux.h: No such file or directory
        "--without-selinux",
      ]
      args << "--with-binutils=#{Formula["binutils"].bin}"
      args << "--with-headers=#{Formula["linux-headers"].include}"
      system "../configure", *args

      system "make" # Fix No rule to make target libdl.so.2 needed by sprof
      system "make", "install"
      prefix.install_symlink "lib" => "lib64"
    end
  end


  test do
    system "#{lib}/ld-#{version}.so 2>&1 |grep Usage"
    system "#{lib}/libc-#{version}.so", "--version"
    system "#{bin}/locale", "--version"
  end
end
