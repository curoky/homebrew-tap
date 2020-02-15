class BoostHelper
  attr_reader :url
  attr_reader :version

  def initialize(version)
    @version = version
    if Gem::Version.new(version) < Gem::Version.new('1.63.0')
      @url = "https://downloads.sourceforge.net/project/boost/boost/#{version}/boost_#{version.gsub('.', '_')}.tar.bz2"
    else
      @url = "https://boostorg.jfrog.io/artifactory/main/release/#{version}/source/boost_#{version.gsub('.', '_')}.tar.bz2"
    end
  end

  def caveats(lib)
    s = ""
    # ENV.compiler doesn't exist in caveats. Check library availability
    # instead.
    if Dir["#{lib}/libboost_log*"].empty?
      s += <<~EOS
        Building of Boost.Log is disabled because it requires newer GCC or Clang.
      EOS
    end

    s
  end

  def install(prefix, lib)
    # Force boost to compile with the desired compiler
    # https://stackoverflow.com/questions/5346454/building-boost-with-different-gcc-version
    open("user-config.jam", "a") do |file|
      if OS.mac?
        file.write "using darwin : : #{ENV.cxx} ;\n"
      else
        file.write "using gcc : : #{Formula["gcc"].opt_bin}/g++-10 ;\n"
      end
    end

    # libdir should be set by --prefix but isn't
    icu4c_prefix = Formula["icu4c"].opt_prefix
    bootstrap_args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
    ]
    if OS.mac?
      bootstrap_args << "--with-icu=#{icu4c_prefix}"
    else
      bootstrap_args << "--without-icu"
    end

    # Handle libraries that will not be built.
    without_libraries = ["python", "mpi"]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc

    bootstrap_args << "--without-libraries=#{without_libraries.join(",")}"

    # layout should be synchronized with boost-python and boost-mpi
    # TODO: does we need threading=single,multi
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged
      --user-config=user-config.jam
      install
      link=shared
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    if ENV.compiler == :clang
      args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
    end

    # Fix error: bzlib.h: No such file or directory
    # and /usr/bin/ld: cannot find -lbz2
    args += ["include=#{HOMEBREW_PREFIX}/include", "linkflags=-L#{HOMEBREW_PREFIX}/lib"] unless OS.mac?
    puts bootstrap_args
    return bootstrap_args,args
  end

  def test(testpath, include, lib)
    (testpath/"test.cpp").write <<~EOS
      #include <boost/algorithm/string.hpp>
      #include <string>
      #include <vector>
      #include <assert.h>
      using namespace boost::algorithm;
      using namespace std;
      int main()
      {
        string str("a,b");
        vector<string> strVec;
        split(strVec, str, is_any_of(","));
        assert(strVec.size()==2);
        assert(strVec[0]=="a");
        assert(strVec[1]=="b");
        return 0;
      }
    EOS
    if OS.mac?
      system Formula["gcc"].opt_bin/"g++-10", "test.cpp", "-std=c++14", "-stdlib=libc++", "-o", "test"
    else
      system Formula["gcc"].opt_bin/"g++-10", "-I#{include}", "test.cpp", "-std=c++1y",
        "-Wl,-rpath=#{lib}", "-L#{lib}", "-lboost_system-mt", "-o", "test"
    end
    system "./test"
  end

end
