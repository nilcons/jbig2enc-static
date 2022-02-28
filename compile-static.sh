#!/bin/bash

set -euo pipefail

# When uudecode finishes, if the cat is not there, then the stdin is closed
# and then tee (and docker by extension) gets a SIGPIPE.
docker build . | tee /dev/stderr | { uudecode && cat >/dev/null ; }
