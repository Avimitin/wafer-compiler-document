{
  description = "Generic devshell setup from github:Avimitin/flakes#generic";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils }:
    {
      # System-independent attr
      inherit inputs;
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        legacyPackages = pkgs;
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.typst ];
        };
        apps.default = flake-utils.lib.mkApp rec {
          name = "build-doc";
          drv = pkgs.writeShellScriptBin name ''
            mkdir -p ./rendered
            ${pkgs.lib.getExe pkgs.typst} compile ./frontend-design.typ ./rendered/frontend-design.pdf
          '';
        };
      });
}
