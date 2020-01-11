class LlvmAT11 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  license "Apache-2.0"
  version "11"

  if OS.mac?
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang+llvm-11.0.0-x86_64-apple-darwin.tar.xz"
    sha256 "b93886ab0025cbbdbb08b46e5e403a462b0ce034811c929e96ed66c2b07fe63a"
  elsif OS.linux?
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang+llvm-11.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz"
    sha256 "829f5fb0ebda1d8716464394f97d5475d465ddc7bea2879c0601316b611ff6db"
  end

  keg_only :versioned_formula

  unless OS.mac?
    depends_on "ncurses"
  end

  def install
    system "cp", "-r", "#{buildpath}/.", "#{prefix}/"
  end

  def caveats
    <<~EOS
      To use the bundled libc++ please add the following LDFLAGS:
        LDFLAGS="-L#{opt_lib} -Wl,-rpath,#{opt_lib}"
    EOS
  end

  test do
    output = shell_output("#{bin}/clang --version")
    assert_match "clang version 11.0.0", output.strip
  end
end
