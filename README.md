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
