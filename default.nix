# Optional if you want to run $ nix build -f ./default.nix | index.js for nix
# $ nix build -f ./default.nix # nix-build -A foo => would target the key "foo" inside an attribute set(object in nix)
let
  pkgs = import <nixpkgs> { system = builtins.currentSystem; };
in
pkgs.callPackage ./bitbox-bridge.nix {}
