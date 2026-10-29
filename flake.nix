{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      overlays.default = final: prev: {
        tailmux-desktop = final.callPackage ./tailmux-desktop.nix { };
        tailmux = final.callPackage ./tailmux.nix { };
      };

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system}.extend self.overlays.default;
        in
        {
          inherit (pkgs) tailmux tailmux-desktop;
          default = pkgs.tailmux;
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
