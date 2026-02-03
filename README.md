# My Own Nixpkgs

Custom nixpkgs repository for packages.

## Usage

Add to your flake:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rwxd-nixpkgs.url = "github:rwxd/my-nixpkgs";
    rwxd-nixpkgs.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { nixpkgs, rwxd-nixpkgs, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit rwxd-nixpkgs; };
      modules = [
        ({ pkgs, rwxd-nixpkgs, ... }: {
          environment.systemPackages = [
            rwxd-nixpkgs.packages.${pkgs.system}.vmrss
            rwxd-nixpkgs.packages.${pkgs.system}.notify-me
          ];
        })
      ];
    };
  };
}
```

## Packages

- [`vmrss`](https://github.com/rwxd/vmrss) - Memory usage monitoring tool
- [`notify-me`](https://github.com/rwxd/notify-me) - CLI tool to send notifications to various services
- [`best-of`](https://github.com/rwxd/best-of) - CLI tool to find the best of something
- [`dnsbl-exporter`](https://github.com/Luzilla/dnsbl_exporter) - Prometheus exporter for DNS Block Lists
- [`pdnsgrep`](https://github.com/akquinet/pdnsgrep) - Search through PowerDNS records via API

## Adding New Packages

Create a new package in `pkgs/<package-name>/package.nix`.

## Updating Versions

### Automatic Updates (Recommended)

Packages are automatically updated daily via GitHub Actions. When a new version is released on GitHub, the workflow will:

1. Detect the new release
2. Update the package version, rev, and hash
3. Build the package to ensure it works
4. Create a pull request automatically

The automatic update workflow runs daily at 00:00 UTC and can also be triggered manually from the [Actions tab](../../actions/workflows/update-packages.yml).

### Manual Updates

Use the provided update script:

```bash
./scripts/update-package.sh <package-name>
```

Example:
```bash
./scripts/update-package.sh notify-me
```

The script will:
- Check for the latest release on GitHub
- Update version, rev, and hash automatically
- Build the package to verify it works
- Show you the changes made

### Manual Update (Low-level)

If you prefer to update manually:

1. Update version and rev in `pkgs/<package-name>/package.nix`
2. Get the hash:

   ```bash
   nix-prefetch-url --unpack https://github.com/owner/repo/archive/refs/tags/vX.Y.Z.tar.gz
   nix hash to-sri --type sha256 <hash>
   ```

3. Update the hash in package.nix
4. Commit and push

## Testing

```bash
# Show all packages
nix flake show

# Build package
nix build '.#vmrss'

# Run directly
nix run '.#vmrss' -- --help
```

## CI/CD

This repository uses GitHub Actions for continuous integration:

- **CI Workflow**: Builds all packages and checks the flake on every pull request and push to main
- **Update Workflow**: Automatically checks for new package releases daily and creates pull requests
- **Renovate**: Keeps `flake.lock` up to date automatically

[![CI](https://github.com/rwxd/my-nixpkgs/actions/workflows/ci.yml/badge.svg)](https://github.com/rwxd/my-nixpkgs/actions/workflows/ci.yml)
[![Update Packages](https://github.com/rwxd/my-nixpkgs/actions/workflows/update-packages.yml/badge.svg)](https://github.com/rwxd/my-nixpkgs/actions/workflows/update-packages.yml)
