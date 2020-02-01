class Chkservice < Formula
  desc "Systemd units manager with ncurses, terminal interface"
  homepage "https://github.com/linuxenko/chkservice"
  url "https://github.com/linuxenko/chkservice/archive/master.zip"
  license "GPL-3.0"
  version "latest"

  depends_on :linux
  depends_on "gcc" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "systemd" => :build
  depends_on "ncurses" => :build

  def install
    inreplace "src/CMakeLists.txt",
      "add_executable(chkservice chkservice.cpp)",
      "add_executable(chkservice chkservice.cpp)\n target_link_directories(chkservice PRIVATE #{Formula["ncurses"].opt_lib} #{Formula["systemd"].opt_lib})"

    args = std_cmake_args + %W[
      -GNinja
      --log-level=STATUS
      -DCMAKE_C_COMPILER=#{Formula["gcc"].opt_bin}/gcc-10
      -DCMAKE_CXX_COMPILER=#{Formula["gcc"].opt_bin}/g++-10
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    ohai "Test complete."
  end
end
