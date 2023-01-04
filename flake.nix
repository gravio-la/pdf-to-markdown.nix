{
  description = "Flake for a tool that converts a PDF file into markdown";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system}; 
      pythonPkgs = pkgs.python38Packages;
    in rec
    {
      packages.pdf-to-markdown = pythonPkgs.buildPythonPackage rec {
        pname = "pdf-to-markdown";
        version = "0.1.0";

        doCheck = false; # Hopefully someone else has run the tests.
        propagatedBuildInputs = with pythonPkgs; [
          pdfminer
        ];


        #https://github.com/johnlinp/pdf-to-markdown
        src = pythonPkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-bN94VtOp/76MLlkBu8ASY4g7OaDMtqTgnl1jJ+wPRYk=";
        };
      };
      packages.default = packages.pdf-to-markdown;
    });
}
