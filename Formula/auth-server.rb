
class AuthServer < Formula
  desc "Auth Server"
  homepage "https://github.com"
  url "https://github.com/brentonbailey/homebrew-tap/releases/download/auth-v1.0.0/auth-v1.0.0.tar.gz"
  sha256 "a7ec774e9383f1dde24298970bb4727ba72c9ff30f250236c6beb4a06aea9a3c"
  license "MIT"

  depends_on "openjdk@17"

  def install
    libexec.install Dir["libexec/*"]
    (bin/"auth-server").write_env_script libexec/"bin/auth-server", Language::Java.overridable_java_home_env("17")
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
    env = Language::Java.overridable_java_home_env("17")
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