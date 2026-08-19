
class AuthServer < Formula
  desc "Auth Server"
  homepage "https://github.com"
  url "https://github.com/brentonbailey/homebrew-tap/releases/download/aether-v0.0.5/aether-v0.0.5.tar.gz"
  sha256 "b0dde8d60964b5a1280537006804fa8824b5d97a6a7e0dc222d306eb6cc6f584"
  license "MIT"

  depends_on "openjdk@16"

  def install
    libexec.install Dir["libexec/*"]
    (bin/"auth-server").write_env_script libexec/"bin/auth-server", Language::Java.overridable_java_home_env("16")
  end

  def install

    libexec.install "auth-server.jar"

    # This creates e.g., /opt/homebrew/etc/auth-server/
    (etc/"auth-server").mkpath

    # Create the config file for the first time only
    unless (etc/"auth-server/application.properties").exist?
      (etc/"auth-server/application.properties").write <<~EOS
        # Auth Server Configuration Overrides
        
        # Local Authentication
        # auth.username: SET-ME
        # auth.password: SET-ME

        # Google Client Secret
        # google.client-id: SET-ME
        # google.client-secret: SET-ME
      EOS
    end

    # Inject the additional-location property into the environment wrapper script
    # Spring Boot treats trailing slashes as folder searches for application.properties/yml
    env = Language::Java.overridable_java_home_env("16")
    env[:SPRING_CONFIG_ADDITIONAL_LOCATION] = "#{etc}/auth-server/"

    (bin/"auth-server").write_env_script "#{libexec}/auth-server.jar", env
  end

  def caveats
    <<~EOS
      Your external configuration files can be placed or modified in:
        #{etc}/auth-server/application.properties
    EOS
  end

  service do
    run [opt_bin/"auth-server"]
    keep_alive true
    log_path var/"log/auth-server.log"
    error_log_path var/"log/auth-server.err.log"
  end
end