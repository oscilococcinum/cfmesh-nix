{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    openfoam-pkg.url = "github:oscilococcinum/openfoam-nix";
  };

  outputs = { nixpkgs, openfoam-pkg, ... }@inputs: {
    packages = builtins.listToAttrs (map (system: 
      {
        name = system;
        value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {
          
          cfmesh-cfdof = pkgs.callPackage (import ./cfmesh-cfdof) { openfoam = openfoam-pkg.openfoam.${system}; };
          cfmesh-cfdof-unstable = cfmesh-cfdof.override { version = "unstable"; };
        };
      }
    )[ "x86_64-linux" "aarch64-linux" ]);
  };
}
