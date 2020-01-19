class QtAT5132 < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "noneed"
  version "5.13.2"
  head "https://code.qt.io/qt/qt5.git", :branch => "dev", :shallow => false

  depends_on :linux
  depends_on "pkg-config" => :build

  unless OS.mac?
    depends_on "fontconfig"
    depends_on "glib"
    depends_on "icu4c"
    depends_on "libproxy"
    depends_on "pulseaudio"
    depends_on "python@2_linux"
    depends_on "sqlite"
    depends_on "systemd"
    depends_on "libxkbcommon"
    depends_on "mesa" # "linuxbrew/xorg/mesa"
    depends_on "xcb-util-image" # "linuxbrew/xorg/xcb-util-image"
    depends_on "xcb-util-keysyms" # "linuxbrew/xorg/xcb-util-keysyms"
    depends_on "xcb-util-renderutil" # "linuxbrew/xorg/xcb-util-renderutil"
    depends_on "xcb-util" # "linuxbrew/xorg/xcb-util"
    depends_on "xcb-util-wm" # "linuxbrew/xorg/xcb-util-wm"
    # depends_on "linuxbrew/xorg/xorg"
  end

  def install
  end

  def caveats; <<~EOS
    We agreed to the Qt open source license for you.
    If this is unacceptable you should uninstall.
  EOS
  end

  test do
    (testpath/"hello.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert_predicate testpath/"hello", :exist?
    assert_predicate testpath/"main.o", :exist?
    system "./hello"
  end
end
