# My Own Nixpkgs

Custom nixpkgs repository for packages.

## Usage

Add to your flake inputs:

```nix
{
  inputs = {
    my-nixpkgs.url = "github:yourusername/my-nixpkgs";
  };
  
  outputs = { nixpkgs, my-nixpkgs, ... }: {
    # Use the overlay
    nixpkgs.overlays = [ my-nixpkgs.overlays.default ];
    
    # Or use packages directly
    packages.x86_64-linux.default = my-nixpkgs.packages.x86_64-linux.vmrss;
  };
}
```

## Packages

- `vmrss` - Memory usage monitoring tool (v1.0.5)
- `notify-me` - CLI tool to send notifications to various services (v1.2.6)
- `best-of` - CLI tool to find the best of something (v1.5.1)

## Adding New Packages

Create a new package in `pkgs/by-name/<package-name>/package.nix`.

## Updating Versions

1. Update version and rev in `pkgs/by-name/vmrss/package.nix`
2. Get the hash:

   ```bash
   nix-prefetch-url --unpack https://github.com/rwxd/vmrss/archive/refs/tags/v1.0.6.tar.gz
   nix hash convert --to sri --type sha256 <hash>
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
