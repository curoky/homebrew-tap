class GnuSedAT45 < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftp.gnu.org/gnu/sed/sed-4.5.tar.xz"
  sha256 "7aad73c8839c2bdadca9476f884d2953cdace9567ecd0d90f9959f229d146b40"

  keg_only :versioned_formula

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Hello world!"
    system "#{bin}/sed", "-i", "s/world/World/g", "test.txt"
    assert_match /Hello World!/, File.read("test.txt")
  end
end
