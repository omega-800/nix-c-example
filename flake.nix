{
  description = "nix-c-example";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = nixpkgs.lib.platforms.unix;
      eachSystem =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f (
            import nixpkgs {
              inherit system;
              config = { };
              overlays = [ ];
            }
          )
        );
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShellNoCC {
          # TODO: add default devshell
          # tip: figure out which dependencies have to be added to be able to compile the c project with the given Makefile
          # bonus: enable debugging tools for this project
        };
      });

      packages = eachSystem (pkgs: {
        default = pkgs.stdenvNoCC.mkDerivation {
          # TODO: add default package with the code in this repository
          # tip: remember which dependencies you added at the devShells output
          # tip: you probably won't need every package from above
          # tip: look at the Makefile to figure out the binary name
          # bonus: only include ./Makefile and ./src/main.c in the source files
          # bonus: differentiate between buildInputs and nativeBuildInputs
          # bonus: implement the package so that its potentially overridden preInstall and postInstall hooks can be applied
        };
      });

      apps = eachSystem (pkgs: {
        default = {
          # TODO: add default app to run the previously declared package
          # tip: look at the app definition declared in the flake of https://github.com/omega-800/nix-as-a-devtool
        };
      });
    };
}
