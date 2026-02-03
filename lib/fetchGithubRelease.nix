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
    , revFormat ? null  # Override how tags are formatted (null means "v${version}")
                        # This should be the complete rev string, e.g., "release-1.0.0" not a template
    , ...
    }@args:
    let
      # Remove our custom args before passing to build function
      cleanArgs = builtins.removeAttrs args [ "pname" "owner" "repo" "version" "hash" "build" "revFormat" ];
    in
    lib.makeOverridable
      ({ version, hash, revFormat ? null, ... }@overrideArgs:
        let
          actualRevFormat = if revFormat != null then revFormat else "v${version}";
          src = pkgs.fetchFromGitHub {
            inherit owner repo hash;
            rev = actualRevFormat;
          };
          buildArgs = cleanArgs // overrideArgs // { inherit src version; };
        in
        build buildArgs
      )
      { inherit version hash revFormat; };
}
