# Example of a binary packaging(storing a frozen binary with deps WITH compiler build) in nix:
# $ nix run --impure --expr 'let pkgs = import <nixpkgs> {}; in pkgs.callPackage ./bitbox-bridge.nix {}'
{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libudev-zero,
}:

rustPlatform.buildRustPackage rec {
  pname = "bitbox-bridge";
  version = "1.6.1";
  src = fetchFromGitHub {
    owner = "BitBoxSwiss";
    repo = "bitbox-bridge";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-+pMXWXGHyyBx3N0kiro9NS0mPmSQzzBmp+pkoBLH7z0=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-6vD0XjGH1PXjiRjgnHWSZSixXOc2Yecui8U5FAGefBU=";
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    libudev-zero
  ];
  meta = {
    description = "A bridge service that connects web wallets like Rabbit to BitBox02";
    homepage = "https://github.com/BitBoxSwiss/bitbox-bridge";
    downloadPage = "https://bitbox.swiss/download/";
    changelog = "https://github.com/BitBoxSwiss/bitbox-bridge/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      izelnakri
      tensor5
    ];
    mainProgram = "bitbox-bridge";
    platforms = with lib.platforms; darwin ++ linux;
  };
}
