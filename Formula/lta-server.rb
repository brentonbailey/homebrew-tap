
class LtaServer < Formula
  desc "Lta Server"
  homepage "https://github.com"
  url "https://github.com/brentonbailey/homebrew-tap/releases/download/lta-v1.0.1/lta-v1.0.1.tar.gz"
  sha256 "a743d9c91d313e3c1385919c9b635a769108a87af037676e098c48d06e801b7a"
  license "MIT"

  depends_on "openjdk@17"

  def install

    libexec.install "lta-server.jar"

    # This creates e.g., /opt/homebrew/etc/lta-server/
    (etc/"lta-server").mkpath

    # Create the config file for the first time only
    unless (etc/"lta-server/application.properties").exist?
      (etc/"lta-server/application.properties").write <<~EOS
        # LTA Server Configuration Overrides
        
        # LTA API
        # lta.base-url=https://datamall2.mytransport.sg/ltaodataservice 
        # lta.account-key=SET-ME
      EOS
    end

    # Include configuration examples for other applications
    (etc/"lta-server").install "config/nginx"
    (etc/"lta-server/statlite").install "config/statlite/lta.conf"

    # Inject the additional-location property into the environment wrapper script
    # Spring Boot treats trailing slashes as folder searches for application.properties/yml
    env = Language::Java.overridable_java_home_env("21")
    env[:SPRING_CONFIG_ADDITIONAL_LOCATION] = "#{etc}/lta-server/"

    (bin/"lta-server").write_env_script "java -jar #{libexec}/lta-server.jar", env
  end

  def caveats
    <<~EOS
      Your external configuration files can be placed or modified in:
        #{etc}/lta-server/application.properties

      To activate this routing fragment in your local Nginx instance, link it and restart Nginx:
        mkdir #{etc}/nginx/app_routes
        ln -sf #{etc}/lta-server/nginx/server/lta_upstream.conf #{etc}/nginx/servers/lta_upstream.conf
        ln -sf #{etc}/lta-server/nginx/app_routes/lta.conf #{etc}/nginx/app_routes/lta.conf
        brew services restart nginx
    EOS
  end

  service do
    run [opt_bin/"lta-server"]
    keep_alive true
    log_path var/"log/lta-server.log"
    error_log_path var/"log/lta-server.err.log"
  end
end