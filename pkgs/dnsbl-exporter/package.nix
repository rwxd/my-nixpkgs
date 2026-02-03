{ lib, pkgs, ... }:

pkgs.buildGoModule rec {
  pname = "dnsbl-exporter";
  version = "0.10.0";

  src = pkgs.fetchFromGitHub {
    owner = "Luzilla";
    repo = "dnsbl_exporter";
    rev = "v${version}";
    hash = "sha256-jN8PD1jdXJ7hZKawslqtFUmWAV0DehNS5hBevrFcMMA=";
  };

  vendorHash = "sha256-5RjZEvCYne6vDaSVn7kjZfAoQM/VAmxMxff9St6POjk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.exporterName=${pname}"
    "-X main.exporterVersion=${version}"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp $src/rbls.ini $out/share/
    cp $src/rbls-domain.ini $out/share/
    cp $src/targets.ini $out/share/
  '';

  meta = with lib; {
    description = "Prometheus exporter for DNS Block Lists (DNSBL/RBL)";
    homepage = "https://github.com/Luzilla/dnsbl_exporter";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ rwxd ];
    mainProgram = "dnsbl_exporter";
  };
}
