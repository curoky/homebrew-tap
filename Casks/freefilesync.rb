cask 'freefilesync' do
  version '11.2'
  sha256 '3f0025823bb5f414c2ed614668eeaf38beec2fc7b6ecb47df5be239de5195135'

  url "https://github.com/curoky/FreeFileSync-Archive/raw/master/FreeFileSync_#{version}_macOS.pkg"
  name 'FreeFileSync'
  homepage 'https://www.freefilesync.org/'

  pkg "FreeFileSync_#{version}.pkg"

  uninstall pkgutil: [
                       'org.freefilesync.pkg.FreeFileSync',
                       'org.freefilesync.pkg.RealTimeSync',
                     ]
end
