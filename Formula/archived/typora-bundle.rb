class TyporaBundle < Formula
  desc 'Bundle vim with plugins and themes.'

  homepage 'https://typora.io/'
  url 'https://github.com/typora/typora-default-themes/archive/master.zip'
  head 'https://github.com/typora/typora-default-themes.git'
  version 'head'

  resource 'typora-theme-softgreen' do
    url 'https://github.com/pomopopo/typora-theme-softgreen/archive/master.zip'
  end
  resource 'typora-theme-ursine' do
    url 'https://github.com/aCluelessDanny/typora-theme-ursine/releases/download/2.0.2/Ursine.zip'
  end
  resource 'typora-theme-next' do
    url 'https://github.com/BillChen2K/typora-theme-next/releases/download/1.1.1/typora-theme-next.zip'
  end
  resource 'typora-theme-pie' do
    url 'https://github.com/kevinzhao2233/typora-theme-pie/archive/master.zip'
  end
  resource 'typora-theme-solarized' do
    url 'https://github.com/belenos/typora-solarized/archive/master.zip'
  end
  resource 'typora-theme-misty-light' do
    url 'https://github.com/etigerstudio/typora-misty-theme/releases/download/v1.0-alpha.2/misty-light-macos.css'
  end
  resource 'typora-theme-misty-dark' do
    url 'https://github.com/etigerstudio/typora-misty-theme/releases/download/v1.0-alpha.2/misty-dark-macos.css'
  end
  resource 'typora-theme-techo' do
    url 'https://github.com/lfkdsk/techo.css/archive/master.zip'
  end
  resource 'typora-theme-cobalt' do
    url 'https://github.com/elitistsnob/typora-cobalt-theme/releases/download/v1.4/typora-cobalt-theme-master-v1.4.zip'
  end
  resource 'typora-theme-vue' do
    url 'https://github.com/blinkfox/typora-vue-theme/archive/master.zip'
  end
  resource 'typora-theme-hsiao' do
    url 'https://github.com/leaf-hsiao/catfish/archive/master.zip'
  end
  resource 'typora-theme-gitlab' do
    url 'https://github.com/elitistsnob/typora-gitlab-theme/releases/download/v1.2/typora-gitlab-theme-master-v1.2.zip'
  end

  keg_only :versioned_formula
  bottle :unneeded

  def install
    prefix.install Dir['*']
    (prefix / 'themes').install resource('typora-theme-softgreen')
    (prefix / 'themes').install resource('typora-theme-ursine')
    (prefix / 'themes').install resource('typora-theme-next')
    (prefix / 'themes').install resource('typora-theme-pie')
    (prefix / 'themes').install resource('typora-theme-solarized')
    (prefix / 'themes').install resource('typora-theme-misty-light')
    (prefix / 'themes').install resource('typora-theme-misty-dark')
    (prefix / 'themes').install resource('typora-theme-techo')
    (prefix / 'themes').install resource('typora-theme-cobalt')
    (prefix / 'themes').install resource('typora-theme-vue')
    (prefix / 'themes').install resource('typora-theme-hsiao')
    (prefix / 'themes').install resource('typora-theme-gitlab')
    # (prefix/"themes").install resource("typora-theme-")

    # (prefix/"vim-plugin/plugged/vim-airline").install resource("vim-airline")
    # (prefix/"vim-plugin/plugged/vim-airline-themes").install resource("vim-airline-themes")
    # (prefix/"vim-plugin/plugged/vim-colors-solarized").install resource("vim-colors-solarized")
    # (prefix/"vim-plugin/plugged/indentLine").install resource("indentLine")
    # (prefix/"vim-plugin/plugged/vim-commentary").install resource("vim-commentary")
    # (prefix/"vim-plugin/plugged/vim-fugitive").install resource("vim-fugitive")
    # (prefix/"vim-plugin/plugged/vim-gitgutter").install resource("vim-gitgutter")
    # (prefix/"vim-plugin/plugged/nerdtree").install resource("nerdtree")
    # (prefix/"vim-plugin/plugged/nerdtree-git-plugin").install resource("nerdtree-git-plugin")

    mkdir_p "#{prefix}/vim-plugin/autoload"
    ln_sf "#{prefix}/plug.vim", "#{prefix}/vim-plugin/autoload/plug.vim"
  end

  test do
    ohai 'Test complete.'
  end
end
