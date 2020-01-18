class LibfuseAT3 < Formula
  desc 'Reference implementation of the Linux FUSE interface'
  homepage 'https://github.com/libfuse/libfuse'
  url 'https://github.com/libfuse/libfuse/releases/download/fuse-3.10.1/fuse-3.10.1.tar.xz'
  # sha256 "5e84f81d8dd527ea74f39b6bc001c874c02bad6871d7a9b0c14efb57430eafe3"
  license any_of: ['LGPL-2.1-only', 'GPL-2.0-only']
  head 'https://github.com/libfuse/libfuse.git'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'ninja' => :build
  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'meson' => :build
  depends_on 'gcc@11' => :build
  depends_on 'libtool' => :build
  depends_on 'systemd' => :build
  depends_on :linux

  def install
    args = std_meson_args + %w[
      -Dexamples=true
      -Duseroot=false
      -Dutils=false
    ]

    mkdir 'build' do
      system 'meson', *args, '..'
      system 'ninja'
      system 'ninja', 'install'
    end
  end

  test do
  end
end
