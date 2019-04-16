#!/usr/bin/env bash

set -e

PROJECT=${1:-}

if [ "${PROJECT}" == "fa-analyze-vacuum" ]; then bin/run-fa-vacuum-guard.sh
elif [ "${PROJECT}" == "analyze-vacuum" ]; then bin/run-analyze-vacuum-utility.sh
elif [ "${PROJECT}" == "column-encoding" ]; then bin/run-column-encoding-utility.sh
elif [ "${PROJECT}" == "unload-copy" ]; then bin/run-unload-copy-utility.sh
elif [ "${PROJECT}" == "user-last-login" ]; then bin/run-user-last-login.sh
else echo "Unhandled arg for project to run. Please select from either 'fa-analyze-vacuum', 'analyze-vacuum', 'column-encoding' or 'unload-copy'"
fi
