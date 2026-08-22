# Homebrew Tap

Welcome to the official Homebrew tap for my custom developer utilities and applications. This repository distributes pre-compiled binaries for macOS and Linux.

## Quick Start

To install any application from this tap, simply run the following commands in your terminal:

```bash
# 1. Add this tap to your local Homebrew installation
brew tap brentonbailey/tap

# 2. Install the desired application
brew install <appname>
```

Alternatively, you can install tools directly in a single command without tapping first:

```bash
brew install brentonbailey/tap/myapp
```

---

## Available Applications

| Application | Description | Installation Command | Service |
| :--- | :--- | :--- | :--- |
| **`aether-server`** | Media Library management backend. | `brew install aether-server` | Yes |
| **`auth-server`** | Google Home Authentcation Endpoint. | `brew install auth-server` | Yes |
| **`smarterhome-server`** | Smarterhome Server. | `brew install smarterhome-server` | Yes |


---

## Updates & Maintenance

### Keeping Tools Up to Date
Homebrew automatically checks for updates when you run your routine update cycles. To manually update applications installed from this tap, run:

```bash
brew update
brew upgrade <appname>
```

### Run as a Service
Homebrew supports running applications as services.
```bash
brew services list | grep <appname>
brew services start brentonbailey/tap/<appname>
brew services stop brentonbailey/tap/<appname>
```

### Troubleshooting
If you run into issues or version mismatches after an upgrade, force a clean download using:

```bash
brew reinstall <appname>
```

---

## Privacy & Security

* **Closed Source Core**: The source code for these tools remains securely hosted in private repositories. 
* **Public Verifiable Binaries**: This repository only hosts the pre-compiled binary packages and cryptographically signs/verifies them via SHA-256 hashes inside each Homebrew formula.

---

## License

These tools are distributed under the [MIT License](LICENSE). Please review individual formula documentation for tool-specific constraints.
