{
  description = "Northstar Server System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catornot-flakes.url = "github:catornot/catornot-flakes";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      systems,
      ...
    }@inputs:
    let
      # Small tool to iterate over each systems
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

      # user used by the system and hostname
      user = "northstarhost";
      hostname = "northstar-host";
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # replace with your hostname
        ${hostname} = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs user hostname; };
          # > Our main nixos configuration file <
          modules = [
            ./nixos/configuration.nix
            inputs.catornot-flakes.nixosModules.northstar-dedicated # northstar server related stuff
          ];
        };
      };

      # for `nix fmt`
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);
      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });
    };
}
