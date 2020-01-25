class ZshBundle < Formula
  desc "Bundle zsh with oh-my-zsh, spaceship-prompt, zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting and so on."

  homepage "https://github.com/ohmyzsh/ohmyzsh"
  url "https://github.com/ohmyzsh/ohmyzsh/archive/master.zip"
  head "https://github.com/ohmyzsh/ohmyzsh.git"
  version "latest"

  resource "spaceship-prompt" do
    url "https://github.com/denysdovhan/spaceship-prompt/archive/master.zip"
  end
  resource "zsh-autosuggestions" do
    url "https://github.com/zsh-users/zsh-autosuggestions/archive/master.zip"
  end
  resource "zsh-completions" do
    url "https://github.com/zsh-users/zsh-completions/archive/master.zip"
  end
  resource "zsh-syntax-highlighting" do
    url "https://github.com/zsh-users/zsh-syntax-highlighting/archive/master.zip"
  end
  resource "conda-zsh-completion" do
    url "https://github.com/esc/conda-zsh-completion/archive/master.zip"
  end

  keg_only :versioned_formula
  bottle :unneeded
  depends_on "zsh"

  def install
    prefix.install Dir["*"]
    (prefix/"custom/themes/spaceship-prompt").install resource("spaceship-prompt")
    (prefix/"custom/plugins/zsh-autosuggestions").install resource("zsh-autosuggestions")
    (prefix/"custom/plugins/zsh-completions").install resource("zsh-completions")
    (prefix/"custom/plugins/zsh-syntax-highlighting").install resource("zsh-syntax-highlighting")
    (prefix/"custom/plugins/zsh-blade").install resource("zsh-blade")
    (prefix/"custom/plugins/conda-zsh-completion").install resource("conda-zsh-completion")

    ln_sf "#{prefix}/custom/themes/spaceship-prompt/spaceship.zsh-theme", "#{prefix}/custom/themes/spaceship.zsh-theme"
  end

  test do
    zshrc = testpath/"zshrc"
    zshrc.write <<~EOS
    export ZSH=#{prefix}
    ZSH_THEME="spaceship"
    DISABLE_AUTO_UPDATE=true
    ZSH_DISABLE_COMPFIX=true
    plugins=(z git pip history extract git-auto-fetch golang systemadmin common-aliases
      zsh-blade zsh-completions zsh-autosuggestions zsh-syntax-highlighting conda-zsh-completion)
    source ${ZSH}/oh-my-zsh.sh
    autoload -U compinit && compinit -u
    EOS

    # Copy from homebrew-core/Formula/zsh-autosuggestions.rb
    assert_match "history",
      shell_output("zsh -c '. #{testpath}/zshrc && echo $ZSH_AUTOSUGGEST_STRATEGY'")

    # Copy from homebrew-core/Formula/zsh-completions.rb
    (testpath/"test.zsh").write <<~EOS
      autoload _ack
      which _ack
    EOS
    assert_match /^_ack/, shell_output("zsh -c '. #{testpath}/zshrc && zsh ./test.zsh'")

    # Copy from zsh-syntax-highlighting
    assert_not_equal "",
      shell_output("zsh -c '. #{testpath}/zshrc && echo $ZSH_HIGHLIGHT_VERSION'").strip()
  end
end
