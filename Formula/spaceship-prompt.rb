class SpaceshipPrompt < Formula
  desc "🚀⭐ A Zsh prompt for Astronauts"
  homepage "https://github.com/denysdovhan/spaceship-prompt"
  url "https://github.com/denysdovhan/spaceship-prompt/archive/master.zip"
  head "https://github.com/denysdovhan/spaceship-prompt.git"
  version "latest"

  keg_only :versioned_formula
  bottle :unneeded
  depends_on "oh-my-zsh"

  def install
    prefix.install Dir["*"]
    mkdir_p "#{lib}/zsh-custom/themes/"

    # TODO: make this better (osx not allow link to oh-my-zsh directory)
    # ln_sf "#{prefix}/spaceship.zsh", Formula["oh-my-zsh"].prefix/"custom/themes/spaceship.zsh"
    # ln_sf "#{prefix}/spaceship.zsh-theme", Formula["oh-my-zsh"].prefix/"custom/themes/spaceship.zsh-theme"
    ln_sf "#{prefix}/spaceship.zsh", "#{lib}/zsh-custom/themes/spaceship.zsh"
    ln_sf "#{prefix}/spaceship.zsh-theme", "#{lib}/zsh-custom/themes/spaceship.zsh-theme"
  end

  test do
    ohai "Test complete."
  end
end
