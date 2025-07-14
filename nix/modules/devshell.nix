{ inputs, ... }:
{
  perSystem = { config, self', pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "rust-nix-template-shell";
      inputsFrom = [
        self'.devShells.rust
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
        cargo-generate
        lazygit
        gitflow

        # Formatting tools (replacing treefmt)
        nixpkgs-fmt
        rustfmt

        # dotfiles programs
        inputs.dotfiles.packages.${system}.quick-results
        inputs.dotfiles.packages.${system}.upjust
        inputs.dotfiles.packages.${system}.upspell
        inputs.dotfiles.packages.${system}.upflake
        inputs.dotfiles.packages.${system}.cargo-update
      ];
      shellHook = ''
        echo "welcome to the rust development environment for the rust-nix-template package" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat 2> /dev/null;
      '';
    };
  };
}
