class ThriftAT093 < Formula
  desc 'Framework for scalable cross-language services development'
  homepage 'https://thrift.apache.org'
  url 'https://archive.apache.org/dist/thrift/0.9.3/thrift-0.9.3.tar.gz'
  sha256 'b0740a070ac09adde04d43e852ce4c320564a292f26521c46b78e0641564969e'

  keg_only :versioned_formula

  depends_on :linux # configure: error: "Error: libcrypto required."
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'bison' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'zlib'
  depends_on 'openssl@1.0.2t' unless OS.mac?
  depends_on 'libevent-openssl1.0' unless OS.mac?
  depends_on 'gcc@11' => %i[build test]

  def install
    unless OS.mac?
      ENV.append 'CFLAGS', "-I#{Formula['libevent-openssl1.0'].opt_include}"
      ENV.append 'CFLAGS', "-I#{Formula['openssl@1.0.2t'].opt_include}"
      ENV.append 'CXXFLAGS', "-I#{Formula['libevent-openssl1.0'].opt_include}"
      ENV.append 'CXXFLAGS', "-I#{Formula['openssl@1.0.2t'].opt_include}"
      ENV.append 'LDFLAGS', "-L#{Formula['libevent-openssl1.0'].opt_lib}"
      ENV.append 'LDFLAGS', "-L#{Formula['openssl@1.0.2t'].opt_lib}"
    end

    ENV.cxx11 if ENV.compiler == :clang

    # Don't install extensions to /usr
    ENV['JAVA_PREFIX'] = pkgshare / 'java'

    args = %W[
      --disable-tests
      --disable-tutorial
      --disable-coverage
      --with-cpp
      --without-qt4
      --without-qt5
      --without-c_glib
      --without-csharp
      --without-java
      --without-erlang
      --without-nodejs
      --without-lua
      --without-python
      --without-perl
      --without-php
      --without-php_extension
      --without-ruby
      --without-haskell
      --without-go
      --without-haxe
      --without-d
      --with-libevent=#{Formula['libevent-openssl1.0'].opt_prefix}
      --with-boost=#{Formula['boost'].opt_prefix}
      --with-zlib=#{Formula['zlib'].opt_prefix}
    ]

    args << "--with-openssl=#{Formula['libevent-openssl1.0'].opt_prefix}" unless OS.mac?

    system './configure', '--disable-debug',
           "--prefix=#{prefix}",
           "--libdir=#{lib}",
           *args
    # ENV.deparallelize
    system 'make', "-j#{ENV.make_jobs}"
    system 'make', 'install'
  end

  test do
    assert_match 'Thrift', shell_output("#{bin}/thrift --version")
  end
end
