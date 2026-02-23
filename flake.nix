{
  description = "PairUX - Collaborative screen sharing with remote control";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pname = "pairux";
        version = "0.5.28";

        src = pkgs.fetchurl {
          url = "https://github.com/profullstack/pairux.com/releases/download/v${version}/PairUX-${version}-x86_64.AppImage";
          sha256 = "2aef39334c4dd497cbdd90f74f7871ffff9bbefc7346287676387ef7bdc9675a";
        };

        appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };
      in
      {
        packages = {
          default = pkgs.appimageTools.wrapType2 {
            inherit pname version src;

            extraInstallCommands = ''
              install -m 444 -D ${appimageContents}/pairux.desktop $out/share/applications/pairux.desktop
              install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/pairux.png \
                $out/share/icons/hicolor/512x512/apps/pairux.png 2>/dev/null || true
              substituteInPlace $out/share/applications/pairux.desktop \
                --replace 'Exec=AppRun' 'Exec=pairux' 2>/dev/null || true
            '';

            meta = with pkgs.lib; {
              description = "Collaborative screen sharing with remote control";
              longDescription = ''
                PairUX is a collaborative screen sharing application with simultaneous
                remote mouse and keyboard control. Like Screenhero, but open source.
                Perfect for pair programming, remote support, and collaboration.
              '';
              homepage = "https://pairux.com";
              changelog = "https://github.com/profullstack/pairux.com/releases/tag/v${version}";
              license = licenses.mit;
              maintainers = [ ];
              platforms = [ "x86_64-linux" ];
              mainProgram = "pairux";
              sourceProvenance = with sourceTypes; [ binaryNativeCode ];
            };
          };

          pairux = self.packages.${system}.default;
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/pairux";
        };
      }
    );
}
