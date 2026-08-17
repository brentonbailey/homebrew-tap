
class AetherServer < Formula
  desc "Aether Server"
  homepage "https://github.com"
  url "https://github.com/brentonbailey/homebrew-tap/releases/download/aether-v0.0.7/aether-v0.0.7.tar.gz"
  sha256 "a8a285be0bbb2c384a28d8f8cd32b1e11a10a3ed34c09d721378776b5bc70577"
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