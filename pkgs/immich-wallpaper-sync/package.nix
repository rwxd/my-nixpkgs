{
  lib,
  buildGoModule,
  fetchFromGitea,
  ...
}:

buildGoModule rec {
  pname = "immich-wallpaper-sync";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "git.chaops.de";
    owner = "rwxd";
    repo = "immich-wallpaper-sync";
    rev = "v${version}";
    hash = "sha256-VUg16FJfaFycm4OO7IVNIpYurWGWsJWt5nD6HGhizCg=";
  };

  vendorHash = "sha256-GZJa45RH/0KcfJZKoM4yBiKhRa8+B3kxXyhrc7u7qR0=";

  meta = {
    description = "Sync images from a self-hosted Immich server into a wallpaper directory";
    homepage = "https://git.chaops.de/rwxd/immich-wallpaper-sync";
    changelog = "https://git.chaops.de/rwxd/immich-wallpaper-sync/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rwxd ];
    mainProgram = "immich-wallpaper-sync";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
