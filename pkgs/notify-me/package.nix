{ pkgs, lib, ... }:

pkgs.buildGoModule {
  pname = "notify-me";
  version = "1.2.6";

  src = pkgs.fetchFromGitHub {
    owner = "rwxd";
    repo = "notify-me";
    rev = "v1.2.6";
    sha256 = "sha256-TlVdScPrVMQQKT3qFdH3ozM7nWelMafifhGDqq4vR0g=";
  };

  vendorHash = "sha256-lMm2SY0sQjjfFPf0WoqxLKzY/oXQHekNpIcoF/5KUZM=";
  proxyVendor = true;

  meta = {
    description = "CLI tool to send notifications to various services";
    homepage = "https://github.com/rwxd/notify-me";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rwxd ];
  };
}
