#!/usr/bin/env bash
#
# This script tests the local flake configuration.

set -euo pipefail

echo "Building the ripgrep flake..."

# The 'nix build' command builds the default package from flake.nix
# and creates a './result' symlink to the output in the Nix store.
nix build

echo "Build complete. Checking the ripgrep version..."

# Execute the binary from the result and check its version.
# This verifies that the build was successful and the program is executable.
./result/bin/rg --version

echo "Flake test passed successfully!"

# Clean up the result symlink
rm result
