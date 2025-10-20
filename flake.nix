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
          packages = with pkgs; [
            cmake
            gcc
            gdb
            curl
          ];
        };
      });

      packages = eachSystem (pkgs: {
        default =
          let
            fs = pkgs.lib.fileset;
          in
          pkgs.stdenvNoCC.mkDerivation {
            name = "nix-c-example";
            version = "1.0.0";
            strictDeps = true;
            nativeBuildInputs = with pkgs; [ gcc ];
            buildInputs = with pkgs; [ curl ];
            src = fs.toSource {
              root = ./.;
              fileset = fs.unions [
                ./Makefile
                ./src/main.c
              ];
            };
            installPhase = ''
              runHook preInstall

              mkdir -p $out/bin
              make
              mv nix-c-example $out/bin

              runHook postInstall
            '';
          };
      });

      apps = eachSystem (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.system}.default}/bin/nix-c-example";
        };
      });
    };
}
