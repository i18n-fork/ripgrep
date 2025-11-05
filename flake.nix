{
  description = cargoToml.package.description;

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rustVersion = pkgs.rust-bin.stable.latest.default;
        rustPlatform = pkgs.makeRustPlatform {
          cargo = rustVersion;
          rustc = rustVersion;
        };
        cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
      in
      {
        packages = {
          default = rustPlatform.buildRustPackage {
            pname = cargoToml.package.name;
            version = cargoToml.package.version;

            src = ./.;

            cargoLock = {
              lockFile = ./Cargo.lock;
            };

            nativeBuildInputs = with pkgs; [
              pkg-config
            ];

            buildInputs = with pkgs; [
              pcre2
            ];
          };
        };

        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (pkgs.rust-bin.stable.latest.default.override {
              extensions = [ "rust-src" ];
            })
            cargo
            pcre2
            pkg-config
          ];
          RUST_SRC_PATH = "${(pkgs.rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })}/lib/rustlib/src/rust/library";
        };
      });
}
