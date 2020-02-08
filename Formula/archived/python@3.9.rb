# https://wiki.python.org/moin/BuildStatically
# https://stackoverflow.com/questions/1150373/compile-the-python-interpreter-statically
class PythonAT39 < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tar.xz"
  sha256 "9c73e63c99855709b9be0b3cc9e5b072cb60f37311e8c4e50f15576a0bf82854"
  license "Python-2.0"

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gdbm" => :build
  depends_on "openssl@1.1" => :build
  depends_on "gcc" => :build
  depends_on "readline" => :build
  depends_on "sqlite" => :build
  depends_on "xz" => :build

  def xy
    version.to_s[/^\d\.\d/]
  end

  def install
    # Unset these so that installing pip and setuptools puts them where we want
    # and not into some other Python the user has installed.
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil

    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-10"
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-10"
    ENV.append "CFLAGS", "-Os -DNDEBUG -s"
    ENV.append "CXXFLAGS", "-Os -DNDEBUG -s"
    ENV.append "CPPFLAGS", "-I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include"
    # https://github.com/esnet/iperf/issues/632#issuecomment-334104098
    ENV.append "LDFLAGS", "--static" if OS.linux?
    ENV.append "LDFLAGS", "-static-libgcc -static-libstdc++" if OS.mac?


    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --disable-shared
      --datarootdir=#{share}
      --datadir=#{share}
      --enable-loadable-sqlite-extensions
      --without-ensurepip
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-system-ffi
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
  end
end
