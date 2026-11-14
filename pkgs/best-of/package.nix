{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:

buildGoModule rec {
  pname = "best-of";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "rwxd";
    repo = "best-of";
    rev = "v${version}";
    sha256 = "sha256-TCVKbpwxSq/CIxKodMSeuLgoeVQwYumhwdZ+S2cOJ8Q=";
  };

  vendorHash = null;

  meta = {
    description = "CLI tool to find the best of something";
    homepage = "https://github.com/rwxd/best-of";
    changelog = "https://github.com/rwxd/best-of/releases";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rwxd ];
    mainProgram = "best-of";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
