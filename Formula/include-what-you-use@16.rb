class IncludeWhatYouUseAT16 < Formula

  desc "Tool to analyze #includes in C and C++ source files"
  homepage "https://include-what-you-use.org/"
  url "https://github.com/include-what-you-use/include-what-you-use/archive/42825de9fa3feb19743c239203eae21b150e7ef3.zip"
  sha256 "59b87703cc20c5d399092b42d3fbf461a026bc854219b55735af03d31fe4092a"
  version "master"
  license "NCSA"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "llvm"

  def install
    args = std_cmake_args + %W[
      -GNinja
      --log-level=WARNING
      -DCMAKE_C_COMPILER=#{Formula["llvm"].bin}/clang
      -DCMAKE_CXX_COMPILER=#{Formula["llvm"].bin}/clang++
      -DCMAKE_INSTALL_PREFIX=#{libexec}
      -DCMAKE_PREFIX_PATH=#{Formula["llvm"].opt_lib}
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "ninja"
      system "ninja", "install"
    end

    bin.write_exec_script Dir["#{libexec}/bin/*"]

    # ln_s Formula["llvm"].lib, lib
    # include-what-you-use needs a copy of the clang and libc++ headers to be
    # located in specific folders under its resource path. These may need to be
    # updated when new major versions of llvm are released, i.e., by
    # incrementing the version of include-what-you-use or the revision of this
    # formula. This would be indicated by include-what-you-use failing to
    # locate stddef.h and/or stdlib.h when running the test block below.
    # https://clang.llvm.org/docs/LibTooling.html#libtooling-builtin-includes
    mkdir_p libexec/"lib/clang/#{Formula["llvm"].version}"
    cp_r Formula["llvm"].opt_lib/"clang/#{Formula["llvm"].version}/include",
      libexec/"lib/clang/#{Formula["llvm"].version}"
    mkdir_p libexec/"include"
    cp_r Formula["llvm"].opt_include/"clang", libexec/"include"
  end

  test do
    output = shell_output("#{bin}/include-what-you-use --version")
    assert_match "include-what-you-use 0.16", output.strip
  end
end
