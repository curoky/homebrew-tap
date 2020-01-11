class BazelCompilationDatabase < Formula
  desc "Tool to generate compile_commands.json from the Bazel build system"
  homepage "https://github.com/grailbio/bazel-compilation-database"
  url "https://github.com/grailbio/bazel-compilation-database/archive/0.4.5.tar.gz"
  sha256 "bcecfd622c4ef272fd4ba42726a52e140b961c4eac23025f18b346c968a8cfb4"
  head "https://github.com/grailbio/bazel-compilation-database.git"

  def install
    bin.install "generate.sh" => "bazel-compdb"
  end

  test do
    ohai "Test complete."
  end
end
