{ inputs, ... }:

{
  flake = rec {
    templates.default = {
      description = "A batteries-included Rust project template for Nix";
      path = builtins.path { path = inputs.self; };
    };

    # https://omnix.page/om/init.html#spec
    om.templates.rust-nix-template = {
      template = templates.default;
      params = [
        {
          name = "package-name";
          description = "Name of the Rust package";
          placeholder = "rust-nix-template";
        }
        {
          name = "author";
          description = "Author name";
          placeholder = "Maxwell Rupp";
        }
        {
          name = "author-email";
          description = "Author email";
          placeholder = "gig@gignsky.com";
        }
        {
          name = "github-ci";
          description = "Include GitHub Actions workflow configuration";
          paths = [
            ".github/**"
          ];
          value = true;
        }
        {
          name = "nix-template";
          description = "Keep the flake template in the project";
          paths = [
            "**/template.nix"
          ];
          value = false;
        }
      ];
      tests = {
        default = {
          params = {
            package-name = "qux";
            author = "John";
            author-email = "john@example.com";
          };
          asserts = {
            source = {
              "Cargo.toml" = true;
              "flake.nix" = true;
              ".github/scripts/update_readme.py" = true;
              ".github/workflows/ci-nix.yml" = true;
              ".github/workflows/check-cargo-version.yml" = true;
              ".github/workflows/check.yml" = true;
              ".github/workflows/docs.yml" = true;
              ".github/workflows/help-to-readme.yml" = true;
              ".github/workflows/release.yml" = true;
              "nix/modules/template.nix" = false;
            };
            packages.default = {
              "bin/qux" = true;
            };
          };
        };
      };
    };
  };
}
