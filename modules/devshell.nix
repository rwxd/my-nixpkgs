_: {
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        actionlint
        deadnix
        gh
        jq
        nil
        nix-update
        nixd
        nixfmt
        statix
      ];
    };
  };
}
