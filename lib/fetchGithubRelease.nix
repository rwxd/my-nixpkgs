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
    , revFormat ? null  # Optional: Override rev format for non-standard tags.
                        # null (default): uses "v${version}" template (e.g., "v1.0.5")
                        # string: uses the exact string provided (must match the git tag exactly)
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
