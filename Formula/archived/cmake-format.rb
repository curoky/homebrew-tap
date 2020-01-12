class CmakeFormat < Formula
  include Language::Python::Virtualenv

  desc 'Source code formatter for cmake listfiles.'
  homepage 'https://github.com/cheshirekow/cmake_format'
  url 'https://files.pythonhosted.org/packages/4a/40/0ca7c62dc4b9af58ca32da8e6d87ee222f5bb551c17ef22900b2f81b998e/cmake_format-0.6.13-py3-none-any.whl'
  sha256 'ec7ed949101e5f0b7bc19317d122b83ccbc28fd766c41c93094845719667c56e'
  license 'GPL-3.0'

  livecheck do
    url :stable
  end

  depends_on 'python@3.9'

  def install
    # FIXME: direct to use virtualenv_install_with_resources
    # virtualenv_install_with_resources

    venv = virtualenv_create(libexec, 'python3.9')
    bin_before = Dir[libexec / 'bin/*'].to_set

    system libexec / 'bin/pip', 'install', '-v', '--ignore-installed',
           'cmake_format-0.6.13-py3-none-any.whl'

    bin_after = Dir[libexec / 'bin/*'].to_set
    bin.install_symlink((bin_after - bin_before).to_a)
    venv
  end

  test do
    output = shell_output("#{bin}/cmake-format --version")
    assert_equal '0.6.13', output.strip
  end
end
