{ pkgs, lib, ... }:

pkgs.buildGoModule {
  pname = "vmrss";
  version = "1.0.5";

  src = pkgs.fetchFromGitHub {
    owner = "rwxd";
    repo = "vmrss";
    rev = "v1.0.5";
    sha256 = "sha256-1z0y1ENMupzeP3pWnq+fy8W0YfW/jEyP6fxTVWi1YcE=";
  };

  vendorHash = null;

  meta = {
    description = "Simple tool to show the memory usage of a process and its children";
    homepage = "https://github.com/rwxd/vmrss";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rwxd ];
  };
}
