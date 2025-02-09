{
  description = "A flake for building and developing my webhook handler";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages =
        let
          beamPackages = with pkgs; beam.packagesWith beam.interpreters.erlang_27;
          pname = "hook";
          version = "0.1.0";
          src = ./.;
          elixir = pkgs.elixir_1_18;
          mixFodDeps = beamPackages.fetchMixDeps {
            pname = "mix-deps-${pname}";
            inherit src version;
            sha256 = "dRikQPA/sJI+MFSeOwVoKD4tCSJ3jA7Tbq9oFt35PW0=";
          };
        in
        {
          hook = beamPackages.mixRelease {
            inherit src pname version mixFodDeps;
            removeCookie = false;
          };
          default = self.packages.${system}.hook;
        };

      devShells = {
        default = self.devShells.${system}.hook;
        hook = pkgs.mkShell {
          buildInputs = with pkgs; [
            elixir_1_18
            elixir-ls

            watchexec

            nil
            nixpkgs-fmt

            curl

            # Sends a request to slskd which triggers it to emit a test event
            # expects base url and auth token to be passed in e.g. test-slskd-hook "https://slskd.example.com" "12345"
            (pkgs.writeShellScriptBin "test-slskd-hook" ''
              #!/usr/bin/env bash
              DATA="''${3:-ExampleData}"
              curl -v --location "''$1/api/v0/events/downloadfilecomplete" \
                --header 'Content-Type: application/json' \
                --header "X-API-Key: ''$2" \
                --data "''$DATA"
            '')
          ] ++ lib.optional stdenv.isLinux inotify-tools;
        };
      };
    });
}
