
class AetherServer < Formula
  desc "Aether Server"
  homepage "https://github.com"
  url "https://github.com{VERSION}/aether-v0.0.6.tar.gz"
  sha256 ""
  license "MIT"

  depends_on "openjdk@21"

  def install
    libexec.install "aether-server-v0.0.2.jar" => "aether-server.jar"
    
    (libexec/"aether-server").write <<~EOS
      #!/bin/bash
      exec java -jar "#{libexec}/aether-server.jar" "$@"
    EOS
    
    chmod 0755, libexec/"aether-server"

    (bin/"aether-server").write_env_script libexec/"aether-server", Language::Java.overridable_java_home_env("21")
  end

  test do
    system "#{bin}/aether-server", "--version"
  end
end