# This showcases the most important nix workflow: how to package and run a binary in the most standard way in nix:

# Commands:
# $ nix run . => (.) is optional
# $ nix build . => (.) is optional

# Target a single file instead:
# $ nix build --impure --expr 'let pkgs = import <nixpkgs> {}; in pkgs.callPackage ./studio-link.nix {}'
# $ nix run --impure --expr 'let pkgs = import <nixpkgs> {}; in pkgs.callPackage ./studio-link.nix {}'

# Target a ./default.nix file
# $ nix build -f ./default.nix # nix-build -A foo => would target the key "foo" inside an attribute set(object in nix)
# $ nix run -f ./default.nix # nix run un -A foo => would target the key "foo" inside an attribute set(object in nix)

{
  description = "Example nix project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = 
    { self, nixpkgs }: 

    let
      forAllSystems = f: nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
        f (import nixpkgs { inherit system; })
      );
    in {
      packages = forAllSystems (pkgs: {
        default = pkgs.callPackage ./bitbox-bridge.nix {};
      });

      apps = forAllSystems (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.system}.default}/bin/bitbox-bridge";
        };
      });

      # Allow `nix develop` to create a shell with dependencies
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [ rustc pkg-config libudev-zero ];
        };
      });
    };
}
