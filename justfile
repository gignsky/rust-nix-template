default:
    @just --list

# Run pre-commit hooks on all files, including autoformatting
pre-commit-all:
    pre-commit run --all-files

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

check:
    just dont-fuck-my-build
    nix flake check --impure --no-build
    nix-shell -p lolcat --run 'echo "[CHECK] Finished." | lolcat'
