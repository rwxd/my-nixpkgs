{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:

buildGoModule rec {
  pname = "pdnsgrep";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "akquinet";
    repo = "pdnsgrep";
    rev = "v${version}";
    sha256 = "sha256-O1oTVdzptLBv47xp8JurSC4c6ofGOr1FKPOkiUizg+w=";
  };

  vendorHash = "sha256-Rx2TmYubU+EqvfyWjX5A3EC+7Pt/k68I6PmQdCwYlfE=";
  proxyVendor = true;

  meta = {
    description = "Search tool for PowerDNS logs";
    homepage = "https://github.com/akquinet/pdnsgrep";
    changelog = "https://github.com/akquinet/pdnsgrep/releases";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rwxd ];
    mainProgram = "pdnsgrep";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
