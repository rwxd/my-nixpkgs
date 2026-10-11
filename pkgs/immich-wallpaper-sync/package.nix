{ lib, pkgs, ... }:

pkgs.buildGoModule {
  pname = "immich-wallpaper-sync";
  version = "0.1.0";

  src = pkgs.fetchFromGitea {
    domain = "git.chaops.de";
    owner = "rwxd";
    repo = "immich-wallpaper-sync";
    rev = "v0.1.0";
    hash = "sha256-VUg16FJfaFycm4OO7IVNIpYurWGWsJWt5nD6HGhizCg=";
  };

  vendorHash = "sha256-GZJa45RH/0KcfJZKoM4yBiKhRa8+B3kxXyhrc7u7qR0=";

  meta = {
    description = "Sync images from a self-hosted Immich server into a wallpaper directory";
    homepage = "https://git.chaops.de/rwxd/immich-wallpaper-sync";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rwxd ];
  };
}