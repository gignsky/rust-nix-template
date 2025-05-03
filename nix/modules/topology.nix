{ inputs, ... }:
{
  imports = [
    inputs.nix-topology.flakeModule
  ];

  perSystem = { config, self', pkgs, lib, ... }: {
    topology = {
      # pkgs = [ ];
      modules = [
        {
          nodes.main = {
            name = "main";
            deviceType = "device";
          };
        }
      ];
    };
  };
}
