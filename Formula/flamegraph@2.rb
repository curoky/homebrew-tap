class FlamegraphAT2 < Formula
  desc "Stack trace visualizer"
  homepage "https://github.com/brendangregg/FlameGraph"
  url "https://github.com/brendangregg/FlameGraph/archive/master.zip"
  license "CDDL-1.0"
  head "https://github.com/brendangregg/FlameGraph.git"
  version "2.0"

  uses_from_macos "perl"

  def install
    bin.install Dir["*.pl"]
    bin.install Dir["*.awk"]
  end

  test do
  end
end
