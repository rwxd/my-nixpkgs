{ pkgs, lib, ... }:

pkgs.buildGoModule {
  pname = "best-of";
  version = "1.5.1";

  src = pkgs.fetchFromGitHub {
    owner = "rwxd";
    repo = "best-of";
    rev = "v1.5.1";
    sha256 = "sha256-6a9NMAb70cP/o7nhvcFgk+l7r5TeXBEqY6PdDkaVtkA=";
  };

  vendorHash = null;

  meta = {
    description = "CLI tool to find the best of something";
    homepage = "https://github.com/rwxd/best-of";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rwxd ];
  };
}
