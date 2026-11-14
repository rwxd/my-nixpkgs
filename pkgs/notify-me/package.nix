{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:

buildGoModule rec {
  pname = "notify-me";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "rwxd";
    repo = "notify-me";
    rev = "v${version}";
    sha256 = "sha256-TlVdScPrVMQQKT3qFdH3ozM7nWelMafifhGDqq4vR0g=";
  };

  vendorHash = "sha256-lMm2SY0sQjjfFPf0WoqxLKzY/oXQHekNpIcoF/5KUZM=";
  proxyVendor = true;

  meta = {
    description = "CLI tool to send notifications to various services";
    homepage = "https://github.com/rwxd/notify-me";
    changelog = "https://github.com/rwxd/notify-me/releases";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rwxd ];
    mainProgram = "notify-me";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
