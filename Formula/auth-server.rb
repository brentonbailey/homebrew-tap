
class AuthServer < Formula
  desc "Auth Server"
  homepage "https://github.com"
  url "https://github.com/brentonbailey/homebrew-tap/releases/download/auth-v1.0.1/auth-v1.0.1.tar.gz"
  sha256 "a743d9c91d313e3c1385919c9b635a769108a87af037676e098c48d06e801b7a"
  license "MIT"

  depends_on "openjdk@17"

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

    # Include configuration examples for other applications
    (etc/"auth-server/nginx").install "config/nginx"
    (etc/"auth-server/statlite").install "config/statlite/auth_server.conf"

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

      To activate this routing fragment in your local Nginx instance, link it and restart Nginx:
        mkdir #{etc}/nginx/app_routes
        ln -sf #{etc}/auth-server/nginx/servers/auth_server.conf #{etc}/nginx/servers/auth_server.conf
        ln -sf #{etc}/auth-server/nginx/app_routes/auth_server.conf #{etc}/nginx/app_routes/auth_server.conf
        brew services restart nginx
    EOS
  end

  service do
    run [opt_bin/"auth-server"]
    keep_alive true
    log_path var/"log/auth-server.log"
    error_log_path var/"log/auth-server.err.log"
  end
end