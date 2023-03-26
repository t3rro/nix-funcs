{
  description = "nix utility functions";
  inputs.nixpkgs.url = github:NixOS/nixpkgs?branch=master;

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" ];
      l = nixpkgs.lib // builtins;

      # do this for all systems
      forAllSystems = f: l.genAttrs systems (
        system: f system (nixpkgs.legacyPackages.${system})
      );

      # convert an attr set to an array
      attrsToArr = attrs:
        let
          addAttr = attrName: result: result ++ [
            { name = attrName; value = attrs.${attrName}; }
          ];
          allAttrs = builtins.attrNames attrs;
        in
        builtins.foldl' addAttr [ ] allAttrs;
    in
    {
      # use lib keyword on outputs to expose nix functions
      lib = {
        inherit
          attrsToArr
          forAllSystems;
      };
    };
}
