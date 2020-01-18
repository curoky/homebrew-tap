class GitMvWithHistory < Formula
  desc "git utility to move/rename file or folder and retain history with it."
  homepage "https://gist.github.com/emiller/6769886"
  url "https://gist.github.com/emiller/6769886/archive/ae47266e867438b9cbd188fb6851ca6566e241d0.zip"
  sha256 "0be3fc72b064e199b031e01a3e3725b093ccb234f8ad58e001d8e5c854a9299c"
  version "latest"

  def install
    bin.install "git-mv-with-history" => "git-mv-file"
  end

  test do
    ohai "Test complete."
  end
end
