default:
	@just --list

# Auto-format the source tree
fmt:
	cargo fmt
	find . -name "*.nix" -not -path "./result*" | xargs nixpkgs-fmt

# Check formatting without applying changes
fmt-check:
	cargo fmt -- --check
	find . -name "*.nix" -not -path "./result*" | xargs nixpkgs-fmt --check
	nix-shell -p lolcat --run 'echo "[FMT CHECK] Finished." | lolcat 2> /dev/null'

# Run 'cargo run' on the project
run *ARGS:
	just dont-fuck-my-build
	cargo run {{ARGS}}

# Run 'cargo watch' to run the project (auto-recompiles)
watch *ARGS:
	cargo watch -x "run -- {{ARGS}}"

# Show the current state of the project
show:
	just dont-fuck-my-build
	just om show .

# Ensure no untracked or uncommitted .nix files are left out
dont-fuck-my-build:
	git ls-files --others --exclude-standard -- '*.nix' | xargs -r git add -v | lolcat 2> /dev/null
	nix-shell -p lolcat --run 'echo "No chance your build is fucked! 👍" | lolcat 2> /dev/null'

# Run the 'omnix' tool with the provided arguments
om *ARGS:
	nix run github:juspay/omnix -- {{ ARGS }}

# Check the health of the project
health:
	just dont-fuck-my-build
	just om health .

# Clean up build artifacts and temporary files
clean:
	rm -rfv result
	cargo clean
	quick-results

# Update a single flake input using a nice little tool created by vimjoyer
single-update:
	nix run github:gignsky/nix-update-input

# Update dependencies and the Nix flake lock file, committing the changes
update:
	just dont-fuck-my-build
	cargo-update
	nix flake update --commit-lock-file

# Update dependencies and the Nix flake lock file without committing the changes
update-no-commit:
	just dont-fuck-my-build
	cargo-update --no-commit
	nix flake update

# Update only the Nix flake lock file, committing the changes
update-flake:
	nix flake update --commit-lock-file

# Update only the Nix flake lock file without committing the changes
update-flake-no-commit:
	nix flake update

# Build the project using Nix & Cargo
buildr:
	just clean
	cargo build --release
	nix build
	quick-results

# Build the project using Nix & Cargo
build:
	just clean
	cargo build
	nix build
	quick-results

# Build the project using Nix with the provided arguments
nbuild *ARGS:
	nix build {{ ARGS }}
	quick-results

# Build the project using Cargo with the provided arguments
cbuild *ARGS:
	cargo build {{ ARGS }}
	quick-results

# Build the project using Nix with the provided arguments
nbuildr *ARGS:
	nix build {{ ARGS }}
	quick-results

# Build the project using Cargo with the provided arguments
cbuildr *ARGS:
	cargo build --release {{ ARGS }}
	quick-results

# Check the project using Nix flake and other tools (skips template.nix)
check *ARGS:
	just dont-fuck-my-build
	NIX_SKIP_TEMPLATE=1 nix flake check --impure {{ ARGS }}
	nix-shell -p lolcat --run 'echo "[CHECK] Finished." | lolcat 2> /dev/null'

# Check the project including template.nix (for debugging template issues)
check-template *ARGS:
	just dont-fuck-my-build
	nix flake check --impure {{ ARGS }}
	nix-shell -p lolcat --run 'echo "[CHECK] Finished." | lolcat 2> /dev/null'

# Run all tests (Rust + Nix)
test:
	just dont-fuck-my-build
	scripts/test-all.sh
	nix-shell -p lolcat --run 'echo "[TEST] All tests completed." | lolcat 2> /dev/null'

# Run template-specific tests
test-template:
	just dont-fuck-my-build
	scripts/test-template.sh
	nix-shell -p lolcat --run 'echo "[TEMPLATE TEST] Finished." | lolcat 2> /dev/null'

# Run Rust tests only
test-rust:
	cargo test --all-features
	nix-shell -p lolcat --run 'echo "[RUST TEST] Finished." | lolcat 2> /dev/null'

# Run Rust clippy
clippy:
	cargo clippy --all-targets --all-features -- -D warnings
	nix-shell -p lolcat --run 'echo "[CLIPPY] Finished." | lolcat 2> /dev/null'

# Simulate CI locally
ci:
	just dont-fuck-my-build
	scripts/ci-simulation.sh
	nix-shell -p lolcat --run 'echo "[CI SIMULATION] Finished." | lolcat 2> /dev/null'

# Run pre-commit flake check (for git hooks)
pre-commit-check:
	scripts/pre-commit-flake-check.sh
	nix-shell -p lolcat --run 'echo "[PRE-COMMIT] Finished." | lolcat 2> /dev/null'
