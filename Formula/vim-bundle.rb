class VimBundle < Formula
  desc "Bundle vim with plugins and themes."

  homepage "https://github.com/junegunn/vim-plug"
  url "https://github.com/junegunn/vim-plug/archive/master.zip"
  head "https://github.com/junegunn/vim-plug.git"
  version "latest"

  resource "delimitMate" do
    url "https://github.com/Raimondi/delimitMate/archive/master.zip"
  end
  resource "vim-airline" do
    url "https://github.com/vim-airline/vim-airline/archive/master.zip"
  end
  resource "vim-airline-themes" do
    url "https://github.com/vim-airline/vim-airline-themes/archive/master.zip"
  end
  resource "vim-colors-solarized" do
    url "https://github.com/altercation/vim-colors-solarized/archive/master.zip"
  end
  resource "indentLine" do
    url "https://github.com/Yggdroot/indentLine/archive/master.zip"
  end
  resource "vim-commentary" do
    url "https://github.com/tpope/vim-commentary/archive/master.zip"
  end
  resource "vim-fugitive" do
    url "https://github.com/tpope/vim-fugitive/archive/master.zip"
  end
  resource "vim-gitgutter" do
    url "https://github.com/airblade/vim-gitgutter/archive/master.zip"
  end
  resource "nerdtree" do
    url "https://github.com/preservim/nerdtree/archive/master.zip"
  end
  resource "nerdtree-git-plugin" do
    url "https://github.com/Xuyuanp/nerdtree-git-plugin/archive/master.zip"
  end

  keg_only :versioned_formula
  bottle :unneeded
  depends_on "vim"

  def install
    prefix.install Dir["*"]
    (prefix/"vim-plugin/plugged/delimitMate").install resource("delimitMate")
    (prefix/"vim-plugin/plugged/vim-airline").install resource("vim-airline")
    (prefix/"vim-plugin/plugged/vim-airline-themes").install resource("vim-airline-themes")
    (prefix/"vim-plugin/plugged/vim-colors-solarized").install resource("vim-colors-solarized")
    (prefix/"vim-plugin/plugged/indentLine").install resource("indentLine")
    (prefix/"vim-plugin/plugged/vim-commentary").install resource("vim-commentary")
    (prefix/"vim-plugin/plugged/vim-fugitive").install resource("vim-fugitive")
    (prefix/"vim-plugin/plugged/vim-gitgutter").install resource("vim-gitgutter")
    (prefix/"vim-plugin/plugged/nerdtree").install resource("nerdtree")
    (prefix/"vim-plugin/plugged/nerdtree-git-plugin").install resource("nerdtree-git-plugin")

    mkdir_p "#{prefix}/vim-plugin/autoload"
    ln_sf "#{prefix}/plug.vim", "#{prefix}/vim-plugin/autoload/plug.vim"
  end

  test do
    ohai "Test complete."
  end
end
