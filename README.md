# my-nixpkgs

[![CI](https://github.com/rwxd/my-nixpkgs/actions/workflows/ci.yml/badge.svg)](https://github.com/rwxd/my-nixpkgs/actions/workflows/ci.yml)

Personal Nix flake with packaged Go tools and utilities. Everything is evaluated
and built in CI, and package updates are automated.

Supported systems:

- `x86_64-linux`
- `aarch64-linux`
- `aarch64-darwin`

## Usage

### As a flake input

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rwxd-nixpkgs.url = "github:rwxd/my-nixpkgs";
    rwxd-nixpkgs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, rwxd-nixpkgs, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = with rwxd-nixpkgs.packages.${pkgs.stdenv.hostPlatform.system}; [
            vmrss
            notify-me
          ];
        })
      ];
    };
  };
}
```

### As an overlay

```nix
{
  nixpkgs.overlays = [ rwxd-nixpkgs.overlays.default ];

  environment.systemPackages = [
    pkgs.local.vmrss
    pkgs.local.notify-me
  ];
}
```

The overlay builds the packages against your own nixpkgs, so overrides and
binary caches work as usual.

### Directly

```bash
nix run github:rwxd/my-nixpkgs#vmrss -- --help
nix build github:rwxd/my-nixpkgs#pdnsgrep
```

## Packages

| Package | Upstream | Notes |
| --- | --- | --- |
| `best-of` | [rwxd/best-of](https://github.com/rwxd/best-of) | CLI tool to find the best of something |
| `dnsbl-exporter` | [Luzilla/dnsbl_exporter](https://github.com/Luzilla/dnsbl_exporter) | Prometheus exporter for DNS block lists |
| `immich-wallpaper-sync` | [rwxd/immich-wallpaper-sync](https://git.chaops.de/rwxd/immich-wallpaper-sync) | Sync Immich images into a wallpaper directory |
| `notify-me` | [rwxd/notify-me](https://github.com/rwxd/notify-me) | Send notifications to various services |
| `pdnsgrep` | [akquinet/pdnsgrep](https://github.com/akquinet/pdnsgrep) | Search PowerDNS entries |
| `vmrss` | [rwxd/vmrss](https://github.com/rwxd/vmrss) | Show memory usage of a process and its children (Linux only) |

## Development

```bash
nix develop          # dev shell with nixd/nil, nixfmt, statix, deadnix, nix-update, gh, ...
nix flake check -L   # evaluate and build every package for the current system
nix build .#vmrss    # build a single package
nix fmt              # format all files with treefmt
```

Packages are listed under `packages.<system>.<name>`, and `nix flake check`
builds them through the `checks` output.

## Adding a package

Create `pkgs/<name>/package.nix` using standard `callPackage` arguments:

```nix
{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "<name>";
  version = "x.y.z";

  src = fetchFromGitHub {
    owner = "<owner>";
    repo = "<repo>";
    rev = "v${version}";
    hash = "...";
  };

  vendorHash = "...";

  meta = {
    description = "...";
    homepage = "...";
    license = lib.licenses.mit;
    mainProgram = "<name>";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
```

## Updating

- **Flake inputs** are maintained by Renovate (see the dependency dashboard).
- **Packages** are updated weekly by the `Update packages` GitHub Actions
  workflow using [`nix-update`](https://github.com/Mic92/nix-update). It bumps
  the version, source hash and Go `vendorHash`, rebuilds the package, and opens
  a pull request assigned to the repository owner.

To update manually:

```bash
nix develop
nix-update --flake --build --format vmrss
```

> [!NOTE]
> Pull requests created with the default `GITHUB_TOKEN` do not trigger other
> workflows, so CI will not run on automated update PRs. Add an `UPDATE_TOKEN`
> repository secret (a fine-grained PAT with `contents: write` and
> `pull-requests: write`) to make automated PRs run CI.

## CI

The CI workflow runs `nix flake check` on:

- `ubuntu-latest` (`x86_64-linux`)
- `ubuntu-24.04-arm` (`aarch64-linux`)
- `macos-latest` (`aarch64-darwin`)

The Nix store is cached with `nix-community/cache-nix-action`.

## License

[MIT](./LICENSE)
