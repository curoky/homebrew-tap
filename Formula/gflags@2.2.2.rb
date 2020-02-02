class GflagsAT222 < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/v2.2.2.tar.gz"
  license "BSD-3-Clause"

  keg_only :versioned_formula

  bottle do
    root_url "https://github.com/curoky/homebrew-tap/releases/download/bottles"
    sha256 x86_64_linux: "3908801e93694a83e6ac9b8e4e05927edac685bfd3090ace4106f5ce087a39a4"
  end

  depends_on :linux
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "gcc" => [:build, :test]

  def install
    mkdir "buildroot" do
      args = std_cmake_args + %W[
        -GNinja
        --log-level=STATUS
        -DCMAKE_C_COMPILER=#{Formula["gcc"].opt_bin}/gcc-10
        -DCMAKE_CXX_COMPILER=#{Formula["gcc"].opt_bin}/g++-10
        -DBUILD_SHARED_LIBS=ON
      ]

      system "cmake", "..", *args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include "gflags/gflags.h"

      DEFINE_bool(verbose, false, "Display program name before message");
      DEFINE_string(message, "Hello world!", "Message to print");

      static bool IsNonEmptyMessage(const char *flagname, const std::string &value)
      {
        return value[0] != '\0';
      }
      DEFINE_validator(message, &IsNonEmptyMessage);

      int main(int argc, char *argv[])
      {
        gflags::SetUsageMessage("some usage message");
        gflags::SetVersionString("1.0.0");
        gflags::ParseCommandLineFlags(&argc, &argv, true);
        if (FLAGS_verbose) std::cout << gflags::ProgramInvocationShortName() << ": ";
        std::cout << FLAGS_message;
        gflags::ShutDownCommandLineFlags();
        return 0;
      }
    EOS
    if OS.mac?
      system ENV.cxx, "-L#{lib}", "-lgflags", "test.cpp", "-o", "test"
    else
      system Formula["gcc"].bin/"c++-10",
      "-Wl,-rpath=#{lib}", "-L#{lib}", "-lgflags", "test.cpp", "-o", "test"
    end
    assert_match "Hello world!", shell_output("./test")
    assert_match "Foo bar!", shell_output("./test --message='Foo bar!'")
  end
end
