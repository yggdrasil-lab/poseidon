#!/bin/bash
set -e

source ./scripts/load_env.sh

# Usage: ./scripts/deploy.sh <STACK_NAME> [COMPOSE_FILES...]
./scripts/deploy.sh --skip-build "poseidon" docker-compose.yml