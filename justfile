default:
    @just --list

# Auto-format the source tree
fmt:
    treefmt

# Run 'cargo run' on the project
run *ARGS:
    just dont-fuck-my-build
    cargo run {{ARGS}}

# Run 'bacon' to run the project (auto-recompiles)
watch *ARGS:
	bacon --job run -- -- {{ ARGS }}


show:
    just dont-fuck-my-build
    om show .

dont-fuck-my-build:
    git ls-files --others --exclude-standard -- '*.nix' | xargs -r git add -v | lolcat
    echo "No chance your build is fucked! 👍" | lolcat

update:
	just dont-fuck-my-build
	nix flake lock --update-input nixpkgs
	git add flake.lock
build:
    nix build
    quick-results
