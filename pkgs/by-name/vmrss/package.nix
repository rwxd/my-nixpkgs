{ pkgs, lib, ... }:

let
  buildVmrss =
    { version, hash }:
    pkgs.buildGoModule {
      pname = "vmrss";
      inherit version;

      src = pkgs.fetchFromGitHub {
        owner = "rwxd";
        repo = "vmrss";
        rev = "v${version}";
        sha256 = hash;
      };

      vendorHash = null;

      meta = {
        description = "Simple tool to show the memory usage of a process and its children";
        homepage = "https://github.com/rwxd/vmrss";
        license = lib.licenses.mit;
        maintainers = [ ];
      };
    };
in
{
  vmrss = buildVmrss {
    version = "1.0.5";
    hash = "sha256-1z0y1ENMupzeP3pWnq+fy8W0YfW/jEyP6fxTVWi1YcE=";
  };

  vmrss_1_0_5 = buildVmrss {
    version = "1.0.5";
    hash = "sha256-1z0y1ENMupzeP3pWnq+fy8W0YfW/jEyP6fxTVWi1YcE=";
  };

  vmrss_1_0_4 = buildVmrss {
    version = "1.0.4";
    hash = "sha256-RsnylFdtr9Y+2/hFLDSxcp6MmsKA/KT0605PweYvFko=";
  };
}
