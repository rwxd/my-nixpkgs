{ pkgs, lib, ... }:

let
  versionHelper = import ../../../lib/fetchGithubRelease.nix { inherit pkgs lib; };
in
{
  vmrss = versionHelper.makeVersionedGithubPackage {
    pname = "vmrss";
    owner = "rwxd";
    repo = "vmrss";
    version = "1.0.5";
    hash = "sha256-1z0y1ENMupzeP3pWnq+fy8W0YfW/jEyP6fxTVWi1YcE=";

    build = { src, version, ... }: pkgs.buildGoModule {
      pname = "vmrss";
      inherit version src;

      vendorHash = null;

      meta = {
        description = "Simple tool to show the memory usage of a process and its children";
        homepage = "https://github.com/rwxd/vmrss";
        license = lib.licenses.mit;
        maintainers = [ ];
      };
    };
  };
}
