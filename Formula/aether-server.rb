
class AetherServer < Formula
  desc "Aether Server"
  homepage "https://github.com"
  url "https://github.com/brentonbailey/aether-backend/releases/download/v0.0.2/aether-server-v0.0.2.tar.gz"
  sha256 "99bcc608e1d0ff484c5dea64578edb7a2c83392728e5a3350f8e0fad90e1eeff"
  license "MIT"

  depends_on "openjdk@21"

  def install
    libexec.install Dir["libexec/*"]
    (bin/"aether").write_env_script libexec/"bin/aether", Language::Java.overridable_java_home_env("21")
  end

  test do
    system "#{bin}/aether-server", "--version"
  end
end