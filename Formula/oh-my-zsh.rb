class OhMyZsh < Formula
  desc "Oh My Zsh is an open source, community-driven framework for managing your zsh configuration."
  homepage "https://github.com/ohmyzsh/ohmyzsh"
  url "https://github.com/ohmyzsh/ohmyzsh/archive/master.zip"
  head "https://github.com/ohmyzsh/ohmyzsh.git"
  version "latest"

  keg_only :versioned_formula
  bottle :unneeded

  def install
    prefix.install Dir["*"]
  end

  test do
    ohai "Test complete."
  end
end
