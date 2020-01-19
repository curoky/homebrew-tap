class BoostAT1570 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org"
  url "https://downloads.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.bz2"
  sha256 "910c8c022a33ccec7f088bd65d4f14b466588dda94ba2124e78b8c57db264967"
  license "BSL-1.0"

  keg_only :versioned_formula

  bottle do
    root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
    sha256 x86_64_linux: 'ea8f3c179498cba7bbed78110afebde78caf0ae04b44efc18c3182bd56606cb4'
  end

  depends_on :linux
  depends_on "gcc" => :build

  # Fix build on Xcode 11.4
  patch do
    url 'https://github.com/boostorg/build/commit/b3a59d265929a213f02a451bb63cea75d668a4d9.patch?full_index=1'
    sha256 '04a4df38ed9c5a4346fbb50ae4ccc948a1440328beac03cb3586c8e2e241be08'
    directory 'tools/build'
  end

  def install
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
    bootstrap_args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}"
      --without-icu
    ]

    # Handle libraries that will not be built.
    without_libraries = ["python", "mpi"]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc

    bootstrap_args << "--without-libraries=#{without_libraries.join(",")}"

    # layout should be synchronized with boost-python
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged
      --user-config=user-config.jam
      install
      link=shared
      threading=single
    ]

    system "./bootstrap.sh", *bootstrap_args
    system "./b2", "headers"
    system "./b2", *args
  end

  def caveats
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

  test do
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
    system Formula["gcc"].opt_bin/"g++-10", "test.cpp", "-std=c++1y", "-I#{include}", "-L#{lib}",
                                "-lboost_system", "-o", "test"
    system "./test"
  end
end
