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

## Version Management

All packages support dynamic version overriding using Nix's `.override` mechanism. You don't need to maintain a hardcoded list of versions!

### Using the Latest Version

```nix
# In your flake or configuration
pkgs.vmrss
```

### Using a Specific Version

Override the version and hash for any package:

```nix
pkgs.vmrss.override {
  version = "1.0.4";
  hash = "sha256-RsnylFdtr9Y+2/hFLDSxcp6MmsKA/KT0605PweYvFko=";
}
```

### Finding the Hash for a Version

To get the hash for a specific version:

```bash
# Method 1: Using nix-prefetch-url
nix-prefetch-url --unpack https://github.com/rwxd/vmrss/archive/refs/tags/v1.0.4.tar.gz
nix hash convert --to sri --type sha256 <hash>

# Method 2: Use a fake hash and let Nix tell you the correct one (recommended)
# The --impure flag is needed because we're intentionally using an invalid hash
nix build --impure '.#vmrss.override { version = "1.0.4"; hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; }'
# This will fail with an error message like:
#   "got: sha256-AAAA..."
#   "expected: sha256-RsnylFdtr9Y+2/hFLDSxcp6MmsKA/KT0605PweYvFko="
# Copy the "expected" hash and use it in your override
```

## Adding New Packages

1. Create a new package directory in `pkgs/by-name/<package-name>/`
2. Add a `package.nix` file using the version helper:

```nix
{ pkgs, lib, ... }:

let
  versionHelper = import ../../../lib/fetchGithubRelease.nix { inherit pkgs lib; };
in
{
  mypackage = versionHelper.makeVersionedGithubPackage {
    pname = "mypackage";
    owner = "github-owner";
    repo = "repo-name";
    version = "1.0.0";
    hash = "sha256-...";
    
    build = { src, version, ... }: pkgs.buildGoModule {
      # or pkgs.rustPlatform.buildRustPackage, etc.
      pname = "mypackage";
      inherit version src;
      
      vendorHash = null;  # or "sha256-..." for Go modules with dependencies
      
      meta = {
        description = "Description of your package";
        homepage = "https://github.com/owner/repo";
        license = lib.licenses.mit;
      };
    };
  };
}
```

## Updating Versions

When a new version is released, simply update the default version in the package.nix file:

1. Change the `version` field to the new version
2. Update the `hash` field (use the fake hash method above to find it)
3. Commit and push

No need to maintain a list of old versions! Users can override to any version they need.

## Testing

```bash
# Show all packages
nix flake show

# Build the default version
nix build '.#vmrss'

# Build a specific version
nix build --impure '.#vmrss.override { version = "1.0.4"; hash = "sha256-RsnylFdtr9Y+2/hFLDSxcp6MmsKA/KT0605PweYvFko="; }'

# Run directly
nix run '.#vmrss' -- --help
```
