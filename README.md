# PairUX Nix Flake

Nix flake for [PairUX](https://pairux.com) - Collaborative screen sharing with remote control.

## Installation

### Using flakes (recommended)

```bash
# Install directly
nix profile install github:profullstack/pairux-nix

# Or run without installing
nix run github:profullstack/pairux-nix
```

### Using nix-shell

```bash
nix-shell -p "(builtins.getFlake \"github:profullstack/pairux-nix\").packages.x86_64-linux.default"
```

### NixOS configuration

Add to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pairux.url = "github:profullstack/pairux-nix";
  };

  outputs = { self, nixpkgs, pairux }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            pairux.packages.${pkgs.system}.default
          ];
        })
      ];
    };
  };
}
```

## Version

Current version: 0.5.35

## License

MIT
