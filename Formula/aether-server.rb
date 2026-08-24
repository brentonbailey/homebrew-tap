
class AetherServer < Formula
  desc "Aether Server"
  homepage "https://github.com"
  url "https://github.com/brentonbailey/homebrew-tap/releases/download/aether-v0.0.5/aether-v0.0.5.tar.gz"
  sha256 "b0dde8d60964b5a1280537006804fa8824b5d97a6a7e0dc222d306eb6cc6f584"
  license "MIT"

  depends_on "openjdk@21"

  if Hardware::CPU.arm?
    resource "sqlite-vec" do
      url "https://github.com/asg017/sqlite-vec/releases/download/v0.1.10-alpha.4/sqlite-vec-0.1.10-alpha.4-loadable-macos-aarch64.tar.gz"
      sha256 "9c4c3c9fee1cd68d07028f90c9e31b67f13ca1a1737435ae569e8fe7a17b5a91"
    end
  else
    resource "sqlite-vec" do
      url "https://github.com/asg017/sqlite-vec/releases/download/v0.1.10-alpha.4/sqlite-vec-0.1.10-alpha.4-loadable-macos-x86_64.tar.gz"
      sha256 "eaa956fa7f145260c7f607ae5e094e48ce6366bb8d0b284266504405b62c7d17"
    end
  end

  def install

    # Install the native sqlite extension into the Homebrew lib dir
    resource("sqlite-vec").stage do
      lib.install "vec0.dylib"
    end

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
        # tmdb.api-key=SETME
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

  service do
    run [opt_bin/"aether-server"]
    keep_alive true
    log_path var/"log/aether-server.log"
    error_log_path var/"log/aether-server.err.log"
  end
end