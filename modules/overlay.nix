{ lib, ... }:
{
  flake.overlays.default = final: _prev: {
    local = lib.filterAttrs (_: package: lib.meta.availableOn final.stdenv.hostPlatform package) (
      lib.filesystem.packagesFromDirectoryRecursive {
        directory = ../pkgs;
        inherit (final) callPackage;
      }
    );
  };
}
