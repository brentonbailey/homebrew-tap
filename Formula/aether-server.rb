
class AetherServer < Formula
  desc "Aether Server"
  homepage "https://github.com"
  url "https://github.com/brentonbailey/homebrew-tap/releases/download/aether-v0.0.5/aether-v0.0.5.tar.gz"
  sha256 "b0dde8d60964b5a1280537006804fa8824b5d97a6a7e0dc222d306eb6cc6f584"
  license "MIT"

  depends_on "openjdk@21"

  def install
    libexec.install Dir["libexec/*"]
    (bin/"aether").write_env_script libexec/"bin/aether", Language::Java.overridable_java_home_env("21")
  end

  def install

    libexec.install "aether-server.jar"

    # This creates e.g., /opt/homebrew/etc/aether/
    (etc/"aether").mkpath

    # Create the config file for the first time only
    unless (etc/"aether/application.properties").exist?
      (etc/"aether/application.properties").write <<~EOS
        # Aether Server Configuration Overrides
        
        # Diskstation settings
        # diskstation.base-uri=SETME
        # diskstation.username=SETME
        # diskstation.password=SETME

        # OpenSubtitles
        # opensubtitles.api-key=SETME

        # TMDB
        tmdb.api-key=SETME
      EOS
    end

    # Inject the additional-location property into the environment wrapper script
    # Spring Boot treats trailing slashes as folder searches for application.properties/yml
    env = Language::Java.overridable_java_home_env("21")
    env[:SPRING_CONFIG_ADDITIONAL_LOCATION] = "#{etc}/aether/"

    (bin/"aether-server").write_env_script "#{libexec}/aether-server.jar", env
  end

  def caveats
    <<~EOS
      Your external configuration files can be placed or modified in:
        #{etc}/aether/application.properties
    EOS
  end

end