{
  description = "A flake for a Python application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    poetry2nix.url = "github:trepetti/poetry2nix/pyopencl";
  };

  outputs = { self, nixpkgs, poetry2nix }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor =
        forAllSystems (system:
          import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          });
    in
    {
      overlay = nixpkgs.lib.composeManyExtensions [
        poetry2nix.overlay
        (final: prev: {
          pythonJuliaSet = prev.poetry2nix.mkPoetryApplication {
            projectDir = ./.;
          };
          pythonJuliaSetEnv = prev.poetry2nix.mkPoetryEnv {
            projectDir = ./.;
            editablePackageSources = {
              pythonJuliaSet = ./.;
            };
          };
        })
      ];

      apps =
        forAllSystems (system: {
          pythonJuliaSet = {
            type = "app";
            program = "${nixpkgsFor.${system}.pythonJuliaSet}/bin/cs10";
          };
        });

      defaultPackage =
        forAllSystems (system:
          nixpkgsFor.${system}.pythonJuliaSet);

      defaultApp =
        forAllSystems (system: {
          type = "app";
          program = "${nixpkgsFor.${system}.pythonJuliaSet}/bin/cs10";
        });

      devShell =
        forAllSystems (system:
          nixpkgsFor.${system}.pythonJuliaSetEnv.env);
    };
}

