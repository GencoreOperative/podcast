#!/bin/bash

set -o pipefail

seq "$@" 2>/dev/null | paste -sd,