
{
  description = "RP2040 embedded Rust dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rust = pkgs.rust-bin.stable.latest.default.override {
          targets = [ "thumbv6m-none-eabi" ];  # <-- Important
          extensions = [ "rust-src" ];          # <-- Important
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            rust
            pkgs.cargo
            pkgs.pkg-config
            pkgs.openssl
            pkgs.rustup
            pkgs.udev
            pkgs.probe-rs-tools
            pkgs.flip-link
            pkgs.elf2uf2-rs
          ];

          shellHook = ''
            export RUST_SRC_PATH=${rust}/lib/rustlib/src/rust/src
          '';
        };
      });
}