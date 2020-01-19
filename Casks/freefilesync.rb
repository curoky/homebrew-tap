cask 'freefilesync' do
  version '11.8'

  name 'FreeFileSync'
  url "https://dl.bintray.com/curoky/homebrew-cask/FreeFileSync_#{version}.pkg"
  homepage 'https://www.freefilesync.org/'

  pkg "FreeFileSync_#{version}.pkg"

  uninstall pkgutil: [
                       'org.freefilesync.pkg.FreeFileSync',
                       'org.freefilesync.pkg.RealTimeSync',
                     ]
end
