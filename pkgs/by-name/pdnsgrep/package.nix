{ lib, pkgs, ... }:

pkgs.buildGoModule {
  pname = "pdnsgrep";
  version = "1.1.2";

  src = pkgs.fetchFromGitHub {
    owner = "akquinet";
    repo = "pdnsgrep";
    rev = "v1.1.2";
    sha256 = "sha256-NFJkLYOHBUYRVehT0VBIFPagLiR8cVvVkAnqCwVUqYg=";
  };

  vendorHash = "sha256-kbX3oTg2OGr4Gj9MEXa2Z7AlYIyv6LNIY4mR06F6OvQ=";
  proxyVendor = true;

  meta = {
    description = "Search tool for PowerDNS logs";
    homepage = "https://github.com/akquinet/pdnsgrep";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rwxd ];
  };
}
