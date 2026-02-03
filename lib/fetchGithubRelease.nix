{ pkgs, lib }:

{
  # Creates a versioned package builder that allows users to easily override versions
  # without maintaining a hardcoded list of versions
  #
  # Usage in package.nix:
  #   makeVersionedGithubPackage {
  #     pname = "vmrss";
  #     owner = "rwxd";
  #     repo = "vmrss";
  #     version = "1.0.5";
  #     hash = "sha256-...";
  #     build = { src, version, ... }: pkgs.buildGoModule { ... };
  #   }
  #
  # Users can then override the version:
  #   pkgs.vmrss.override { version = "1.0.4"; hash = "sha256-..."; }
  makeVersionedGithubPackage =
    { pname
    , owner
    , repo
    , version
    , hash
    , build  # Function that takes { src, version, ... } and returns a derivation
    , revFormat ? null  # Optional: Override git tag/rev for non-standard formats.
                        # null (default): uses "v${version}" (e.g., "v1.0.5")
                        # string: uses the exact git tag/rev provided (e.g., "release-1.0.0")
                        # When overriding version, you typically also need to override revFormat
    , ...
    }@args:
    let
      # Remove our custom args before passing to build function
      cleanArgs = builtins.removeAttrs args [ "pname" "owner" "repo" "version" "hash" "build" "revFormat" ];
    in
    lib.makeOverridable
      ({ version, hash, revFormat ? null, ... }@overrideArgs:
        let
          effectiveRev = if revFormat != null then revFormat else "v${version}";
          src = pkgs.fetchFromGitHub {
            inherit owner repo hash;
            rev = effectiveRev;
          };
          buildArgs = cleanArgs // overrideArgs // { inherit src version; };
        in
        build buildArgs
      )
      { inherit version hash revFormat; };
}
