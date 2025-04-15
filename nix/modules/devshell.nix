{ inputs, ... }:
{
  perSystem = { config, self', pkgs, lib, ... }: {
    devShells.default = pkgs.mkShell {
      name = "rust-nix-template-shell";
      inputsFrom = [
        self'.devShells.rust
        config.treefmt.build.devShell
        config.pre-commit.devShell # See ./nix/modules/pre-commit.nix
      ];
      packages = with pkgs; [
        just
        nixd # Nix language server  
        bacon
        config.process-compose.cargo-doc-live.outputs.package
        nil
        lolcat
        wslu
        #add quickresults one day
      ];
      shellHook = ''
        echo "welcome to the rust development environment" | lolcat
      '';
    };
  };
}
