class OracleJdk < Formula
  desc 'Oracle Java Standard Edition Development Kit'
  homepage 'https://www.oracle.com/technetwork/java/javase/overview/index.html'
  url 'https://dl.bintray.com/curoky/homebrew-cask/jdk-15.0.2_linux-x64_bin.tar.gz'

  keg_only :versioned_formula
  depends_on :linux

  def install
    system 'cp', '-r', "#{buildpath}/.", "#{prefix}/"
  end

  test do
    (testpath / 'HelloWorld.java').write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin / 'javac', 'HelloWorld.java'

    assert_match 'Hello, world!', shell_output("#{bin}/java HelloWorld")
  end
end
