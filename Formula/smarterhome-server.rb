
class SmarterhomeServer < Formula
  desc "Smarterhome Server"
  homepage "https://github.com"
  url "https://github.com/brentonbailey/homebrew-tap/releases/download/smarterhome-v0.0.1/smarterhome-v0.0.1.tar.gz"
  sha256 "b0dde8d60964b5a1280537006804fa8824b5d97a6a7e0dc222d306eb6cc6f584"
  license "MIT"

  depends_on "openjdk@21"

  def install
    libexec.install Dir["libexec/*"]
    (bin/"smarterhome-server").write_env_script libexec/"bin/smarterhome-server", Language::Java.overridable_java_home_env("21")
  end

  def install

    libexec.install "smarterhome-server.jar"

    # This creates e.g., /opt/homebrew/etc/smarterhome/
    (etc/"smarterhome").mkpath

    # Create the config file for the first time only
    unless (etc/"smarterhome/application.properties").exist?
      (etc/"smarterhome/application.properties").write <<~EOS
        # Smarterhome Server Configuration Overrides
        
        
      EOS
    end

    # Inject the additional-location property into the environment wrapper script
    # Spring Boot treats trailing slashes as folder searches for application.properties/yml
    env = Language::Java.overridable_java_home_env("21")
    env[:SPRING_CONFIG_ADDITIONAL_LOCATION] = "#{etc}/smarterhome/"

    (bin/"smarterhome-server").write_env_script "#{libexec}/smarterhome-server.jar", env
  end

  def caveats
    <<~EOS
      Your external configuration files can be placed or modified in:
        #{etc}/smarterhome/application.properties
    EOS
  end

  service do
    run [opt_bin/"smarterhome-server"]
    keep_alive true
    log_path var/"log/smarterhome-server.log"
    error_log_path var/"log/smarterhome-server.err.log"
  end
end