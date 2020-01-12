class ZshBlade < Formula
  desc "This plugin provides completion and some functions for blade-build."
  homepage "https://github.com/curoky/zsh-blade"
  url "https://github.com/curoky/zsh-blade/archive/master.zip"
  head "https://github.com/curoky/zsh-blade.git"
  version "latest"

  bottle :unneeded

  def install
    pkgshare.install "zsh-blade.plugin.zsh"
  end

  test do
    ohai "Test complete."
  end
end
