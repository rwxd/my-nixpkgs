{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:

buildGoModule rec {
  pname = "vmrss";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "rwxd";
    repo = "vmrss";
    rev = "v${version}";
    sha256 = "sha256-BB3Xg0CIjcH4fnzLTHuClzFCsE254uB8AlPrL4LbB3g=";
  };

  vendorHash = null;

  meta = {
    description = "Simple tool to show the memory usage of a process and its children";
    homepage = "https://github.com/rwxd/vmrss";
    changelog = "https://github.com/rwxd/vmrss/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rwxd ];
    mainProgram = "vmrss";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
