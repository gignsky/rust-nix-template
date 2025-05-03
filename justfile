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

om *ARGS:
	nix run github:juspay/omnix -- {{ ARGS }}

show:
	just dont-fuck-my-build
	just om show .

health:
	just dont-fuck-my-build
	just om health .

clean:
	rm -rfv results
	cargo clean

dont-fuck-my-build:
	git ls-files --others --exclude-standard -- '*.nix' | xargs -r git add -v | lolcat
	echo "No chance your build is fucked! 👍" | lolcat

update:
	just dont-fuck-my-build
	just cargo-update
	nix flake update --commit-lock-file

update-no-commit:
	just dont-fuck-my-build
	just cargo-update-no-commit
	nix flake update

cargo-update-no-commit:
	cargo update

cargo-update:
	cargo update
	git add Cargo.lock

build:
	nix build
	quick-results

check *ARGS:
	just dont-fuck-my-build
	nix flake check --impure --no-build {{ ARGS }}
	nix-shell -p lolcat --run 'echo "[CHECK] Finished." | lolcat'
