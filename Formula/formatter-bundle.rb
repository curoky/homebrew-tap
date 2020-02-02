class FormatterBundle < Formula
  include Language::Python::Virtualenv

  desc 'Collect all formatter.'
  url 'https://github.com/pypa/sampleproject/archive/refs/heads/main.zip'
  version 'head'

  depends_on 'python@3.9' => :build
  depends_on 'ruby'

  def install
    venv = virtualenv_create(libexec, 'python3.9')
    system libexec / 'bin/pip', 'install', '--upgrade', 'pip'
    system libexec / 'bin/pip', 'install',
           'beancount',
           'cmake-format',
           'isort[requirements_deprecated_finder,pipfile_deprecated_finder]',
           'pyupgrade',
           'commitizen',
           'git+https://github.com/curoky/licenseheaders'

    bin.mkpath

    # bin.install_symlink Dir["#{libexec}/bin/*"]
    ln_sf "#{libexec}/bin/bean-format", "#{bin}/bean-format"
    ln_sf "#{libexec}/bin/bean-check", "#{bin}/bean-check"
    ln_sf "#{libexec}/bin/cmake-format", "#{bin}/cmake-format"
    ln_sf "#{libexec}/bin/isort", "#{bin}/isort"
    ln_sf "#{libexec}/bin/pyupgrade", "#{bin}/pyupgrade"
    ln_sf "#{libexec}/bin/cz", "#{bin}/cz"
    ln_sf "#{libexec}/bin/git-cz", "#{bin}/git-cz"
    ln_sf "#{libexec}/bin/cmake-lint", "#{bin}/cmake-lint"
    ln_sf "#{libexec}/bin/licenseheaders", "#{bin}/licenseheaders"

    venv.pip_install_and_link buildpath

    ENV['GEM_HOME'] = libexec
    ENV['GEM_PATH'] = libexec

    system 'gem', 'install', 'rubocop'

    (bin / 'rubocop').write <<~EOS
      #!/bin/bash
      export PATH="#{Formula['ruby'].opt_bin}:#{libexec}/bin:$PATH"
      export FASTLANE_INSTALLED_VIA_HOMEBREW="true"
      GEM_HOME="#{libexec}" GEM_PATH="#{libexec}" \\
        exec "#{libexec}/bin/rubocop" "$@"
    EOS
    chmod '+x', bin / 'rubocop'
  end

  test do
    ohai 'Test complete.'
  end
end
