{ pkgs, lib, ... }:

pkgs.buildGoModule.override { go = pkgs.go_1_26; } {
  pname = "vmrss";
  version = "1.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "rwxd";
    repo = "vmrss";
    rev = "v1.2.0";
    sha256 = "sha256-ps87iD52aTwGqkep4G1zDs2CzdU51cUGX+F7fgUITlo=";
  };

  vendorHash = null;

  meta = {
    description = "Simple tool to show the memory usage of a process and its children";
    homepage = "https://github.com/rwxd/vmrss";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rwxd ];
  };
}
