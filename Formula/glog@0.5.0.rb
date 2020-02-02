class GlogAT050 < Formula
  desc 'Application-level logging library'
  homepage 'https://github.com/google/glog'
  url 'https://github.com/google/glog/archive/v0.5.0.tar.gz'
  sha256 'eede71f28371bf39aa69b45de23b329d37214016e2055269b3b5e7cfd40b59f5'
  license 'BSD-3-Clause'
  head 'https://github.com/google/glog.git'

  keg_only :versioned_formula

  bottle do
    root_url 'https://github.com/curoky/homebrew-tap/releases/download/bottles'
    sha256 x86_64_linux: '9aca6882cd807f7f34572162e1a281a6c961fc8f823896a04121f4e58d41fbb5'
  end

  depends_on :linux
  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'gcc@11' => %i[build test]
  depends_on 'gflags@2.2.2'

  def install
    gcc = Formula['gcc@11']
    mkdir 'buildroot' do
      args = std_cmake_args + %W[
        -GNinja
        --log-level=STATUS
        -DCMAKE_C_COMPILER=#{gcc.opt_bin}/gcc-11
        -DCMAKE_CXX_COMPILER=#{gcc.opt_bin}/g++-11
        -DBUILD_SHARED_LIBS=ON
      ]

      system 'cmake', '..', *args
      system 'ninja'
      system 'ninja', 'install'
    end
  end

  test do
    (testpath / 'test.cpp').write <<~EOS
      #include <glog/logging.h>
      #include <iostream>
      #include <memory>
      int main(int argc, char* argv[])
      {
        google::InitGoogleLogging(argv[0]);
        LOG(INFO) << "test";
      }
    EOS
    system Formula['gcc@11'].opt_bin / 'g++-11',
           '-std=c++11', 'test.cpp',
           "-I#{include}",
           "-I#{Formula['gflags@2.2.2'].opt_include}",
           "-L#{lib}",
           '-lglog', "-I#{Formula['gflags@2.2.2'].opt_lib}",
           "-L#{Formula['gflags@2.2.2'].opt_lib}", '-lgflags',
           "-Wl,-rpath=#{lib}",
           "-Wl,-rpath=#{Formula['gflags@2.2.2'].opt_lib}",
           '-o', 'test'
    system './test'
  end
end
