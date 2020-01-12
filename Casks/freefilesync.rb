cask 'freefilesync' do
  version '11.10'

  name 'FreeFileSync'
  url "https://github.com/curoky/homebrew-tap/releases/download/cask/FreeFileSync_#{version}.pkg"
  homepage 'https://www.freefilesync.org/'

  pkg "FreeFileSync_#{version}.pkg"

  uninstall pkgutil: [
    'org.freefilesync.pkg.FreeFileSync',
    'org.freefilesync.pkg.RealTimeSync'
  ]
end
