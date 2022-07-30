#!/usr/bin/env bash
#
# updates all packages for home-manager and system
#

nix flake update ## --recreate-lock-file  ## changed in v3
