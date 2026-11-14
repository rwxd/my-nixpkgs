{
  perSystem =
    { pkgs, ... }:
    let
      # `nix develop` exports NIX_BUILD_TOP/NIX_GCROOT, which makes nix-update's
      # nested `builtins.getFlake` calls fail to see its own flake store path.
      # Unset them in the shell wrapper so `nix-update` works interactively.
      nix-update-wrapped = pkgs.writeShellScriptBin "nix-update" ''
        exec ${pkgs.coreutils}/bin/env -u NIX_BUILD_TOP -u NIX_GCROOT \
          ${pkgs.nix-update}/bin/nix-update "$@"
      '';
    in
    {
      devShells.default = pkgs.mkShell {
        packages =
          (with pkgs; [
            actionlint
            deadnix
            gh
            jq
            nil
            nixd
            nixfmt
            statix
          ])
          ++ [ nix-update-wrapped ];
      };
    };
}
