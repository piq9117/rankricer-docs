{
  description = "RankRicer Docs";
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  outputs = {self, nixpkgs }: 
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      nixpkgsFor = forAllSystems(system: import nixpkgs {
        inherit system;
      });
    in {
      devShells = forAllSystems (system: 
      let
        pkgs = nixpkgsFor.${system};
        build-book = pkgs.writeScriptBin "build-book" ''
          rm -r ./docs || true
          ${pkgs.mdbook}/bin/mdbook build -d ./docs
          cp CNAME ./docs
        '';
      in {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            mdbook
            treefmt
            mdformat
            build-book
          ];
          shellHook = ''
            export PS1='[$PWD]\n❄ '
          '';
        };
      });
    };
}
