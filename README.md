# My Own Nixpkgs

Custom nixpkgs repository for personal packages.

## Usage

Add to your flake inputs:

```nix
{
  inputs = {
    rwxd-nixpkgs.url = "github:rwxd/my-nixpkgs";
  };
  
  outputs = { nixpkgs, my-nixpkgs, ... }: {
    # Use the overlay
    nixpkgs.overlays = [ my-nixpkgs.overlays.default ];
    
    # Or use packages directly
    packages.x86_64-linux.default = rwxd-nixpkgs.packages.x86_64-linux.vmrss;
  };
}
```

## Packages

- `vmrss` - Memory usage monitoring tool (latest: v1.0.5)
  - `vmrss/vmrss` - Latest version (1.0.5)
  - `vmrss/vmrss_1_0_5` - Version 1.0.5
  - `vmrss/vmrss_1_0_4` - Version 1.0.4

## Version Management

Multiple versions can be accessed:

- `vmrss/vmrss` - Latest/default version
- `vmrss/vmrss_1_0_5` - Specific version 1.0.5
- `vmrss/vmrss_1_0_4` - Specific version 1.0.4

## Adding New Packages

Create a new package in `pkgs/by-name/<package-name>/package.nix`.

## Updating Versions

1. Add new version to the package.nix file:

   ```nix
   vmrss_1_0_6 = buildVmrss {
     version = "1.0.6";
     hash = "sha256-...";
   };
   ```

2. Get the hash:

   ```bash
   nix-prefetch-url --unpack https://github.com/rwxd/vmrss/archive/refs/tags/v1.0.6.tar.gz
   nix hash convert --to sri --type sha256 <hash>
   ```

3. Update the default `vmrss` to point to the latest version
4. Commit and push

## Testing

```bash
# Show all packages
nix flake show

# Build a specific version
nix build '.#"vmrss/vmrss_1_0_4"'

# Run directly
nix run '.#"vmrss/vmrss"' -- --help
```
