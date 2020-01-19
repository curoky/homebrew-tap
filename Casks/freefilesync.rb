cask 'freefilesync' do
  version '11.5'

  name 'FreeFileSync'
  url "https://dl.bintray.com/curoky/homebrew-cask/FreeFileSync_#{version}_macOS.pkg"
  sha256 "068a793d128b8e7e4dc42f94753bbe67acd6a727850d0afd7d466db85c9564be"
  homepage 'https://www.freefilesync.org/'

  pkg "FreeFileSync_#{version}_macOS.pkg"

  uninstall pkgutil: [
                       'org.freefilesync.pkg.FreeFileSync',
                       'org.freefilesync.pkg.RealTimeSync',
                     ]
end
