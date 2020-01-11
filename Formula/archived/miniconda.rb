class Miniconda < Formula
  desc "Package, dependency and environment management for any language---Python, R, Ruby, Lua, Scala, Java, JavaScript, C/ C++, FORTRAN"
  homepage "https://docs.conda.io/en/latest/miniconda.html"
  url "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
  version "latest"

  depends_on :linux

  keg_only :versioned_formula

  def install
    system "bash", "./Miniconda3-latest-Linux-x86_64.sh", "-bfp", "#{prefix}"
    # system "conda", "clean", "-tipsy"
  end

  test do
    output = shell_output("#{bin}/conda -V")
    assert_match "conda 4.9.2", output.strip
  end
end
