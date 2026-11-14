{ lib, pkgs, ... }:

pkgs.buildGoModule rec {
  pname = "dnsbl-exporter";
  version = "0.12.0";

  src = pkgs.fetchFromGitHub {
    owner = "Luzilla";
    repo = "dnsbl_exporter";
    rev = "v${version}";
    hash = "sha256-QxCXgPRox9Lgfl+3RNxgcgiRSy0C1Gogykby+FcnmTc=";
  };

  vendorHash = "sha256-J+20vMxgLhvouddhKCmB6FSosN8J1FQXA6Ed8JT6h98=";

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
