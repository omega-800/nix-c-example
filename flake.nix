{
  description = "c development environment";

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
        # TODO: add default devshell
      });

      packages = eachSystem (
        pkgs:
        {
        # TODO: add default package from the code in this repository
        }
      );

      apps = eachSystem (pkgs: {
        # TODO: add default app to run the previously declared package
      });
    };
}
