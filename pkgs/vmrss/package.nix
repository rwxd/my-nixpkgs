{ pkgs, lib, ... }:

pkgs.buildGoModule rec {
  pname = "vmrss";
  version = "1.2.2";

  src = pkgs.fetchFromGitHub {
    owner = "rwxd";
    repo = "vmrss";
    rev = "v${version}";
    sha256 = "sha256-BB3Xg0CIjcH4fnzLTHuClzFCsE254uB8AlPrL4LbB3g=";
  };

  vendorHash = null;

  meta = {
    description = "Simple tool to show the memory usage of a process and its children";
    homepage = "https://github.com/rwxd/vmrss";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rwxd ];
  };
}
