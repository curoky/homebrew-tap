class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  url "https://github.com/ginuerzh/gost/archive/v2.11.1.tar.gz"
  sha256 "d94b570a7a84094376b8c299d740528f51b540d9162f1db562247a15a89340bf"
  head "https://github.com/ginuerzh/gost.git"

  depends_on "go" => :build

  def install
    cd "cmd/gost" do
      system "go", "env"
      system "go", "build", *std_go_args
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/gost -V")
    assert_match "gost 2.11.1", output.strip
  end
end
