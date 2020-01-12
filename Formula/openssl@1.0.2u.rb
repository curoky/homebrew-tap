# This formula tracks 1.0.2 branch of OpenSSL, not the 1.1.0 branch. Due to
# significant breaking API changes in 1.1.0 other formulae will be migrated
# across slowly, so core will ship `openssl` & `openssl@1.1` for foreseeable.
class OpensslAT102u < Formula
  desc "SSL/TLS cryptography library"
  homepage "https://openssl.org/"
  url "https://github.com/openssl/openssl/archive/OpenSSL_1_0_2u.tar.gz"
  sha256 "82fa58e3f273c53128c6fe7e3635ec8cda1319a10ce1ad50a987c3df0deeef05"

  keg_only :versioned_formula

  bottle do
    root_url "https://github.com/curoky/homebrew-tap/releases/download/bottles"
    sha256 x86_64_linux: "8bfa92d7265a723a961008d664cc781b187520ef55ede0e47628da88e7e55ae7"
  end

  depends_on :linux
  depends_on "gcc@10"

  def install
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-10"
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-10"
    # OpenSSL will prefer the PERL environment variable if set over $PATH
    # which can cause some odd edge cases & isn't intended. Unset for safety,
    # along with perl modules in PERL5LIB.
    ENV.delete("PERL")
    ENV.delete("PERL5LIB")
    ENV["CC"] = Formula["gcc@10"].opt_bin/"gcc-10"
    ENV["CXX"] = Formula["gcc@10"].opt_bin/"g++-10"

    ENV.deparallelize
    args = %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      shared zlib
    ]

    system "./config", *args
    system "make", "-j#{ENV.make_jobs}"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
  end

  def openssldir
    etc/"openssl"
  end

  def caveats; <<~EOS
    A CA file has been bootstrapped using certificates from the SystemRoots
    keychain. To add additional certificates (e.g. the certificates added in
    the System keychain), place .pem files in
      #{openssldir}/certs
    and run
      #{opt_bin}/c_rehash
  EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate HOMEBREW_PREFIX/"etc/openssl/openssl.cnf", :exist?,
            "OpenSSL requires the .cnf file for some functionality"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system "#{bin}/openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
