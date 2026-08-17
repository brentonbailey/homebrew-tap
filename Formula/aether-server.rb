require_relative "custom_download_strategy"

class AetherServer < Formula
  desc "Aether Server"
  homepage "https://github.com"
  
  # Point this directly to your GitHub Release asset URL
  url "https://github.com/brentonbailey/aether-backend/releases/download/v0.0.2/aether-server-v0.0.2.tar.gz", :using => GitHubPrivateRepositoryReleaseDownloadStrategy
  
  # Paste the SHA-256 hash generated in Step 1 here
  sha256 "sha256:99bcc608e1d0ff484c5dea64578edb7a2c83392728e5a3350f8e0fad90e1eeff"
  
  license "MIT"

  # Ensures the user has a compatible Java Runtime installed on their system
  depends_on "openjdk@21"

  def install
    # 1. Move the raw JAR file into Homebrew's private internal storage directory
    libexec.install "aether-server-v0.0.2.jar" => "aether-server.jar"
    
    # 2. Automatically generate a native binary wrapper script inside the system PATH
    # This allows users to simply type 'aether-server' in their terminal to launch the app
    (bin/"aether-server").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${Language::Java.overridable_java_home_env("21")[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/aether-server.jar" "$@"
    EOS
  end

  test do
    # Simple smoke test to confirm the binary executes successfully
    system "#{bin}/aether-server", "--version"
  end
end
