class AzureFunctionsCoreToolsAT3 < Formula
  desc 'Azure Functions Core Tools 3.0'
  url 'https://github.com/Azure/azure-functions-core-tools/releases/download/3.0.3477/Azure.Functions.Cli.linux-x64.3.0.3477.zip'
  version '3.0.3477'
  head 'https://github.com/Azure/azure-functions-core-tools'

  bottle :unneeded
  depends_on :linux

  def install
    prefix.install Dir['*']
    chmod 0o555, prefix / 'func'
    chmod 0o555, prefix / 'gozip'
    bin.install_symlink prefix / 'func'
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/func")
    # system bin / 'func', 'new', '-l', 'C#', '-t', 'HttpTrigger', '-n', 'confusedDevTest'
    # assert_predicate testpath / 'confusedDevTest/function.json', :exist?
  end
end
