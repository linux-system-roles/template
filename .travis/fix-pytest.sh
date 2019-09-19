#!/bin/bash
# SPDX-License-Identifier: MIT

set -ex

for D in library module_utils; do
  if [[ ! -d ./${D} ]]; then
    mkdir ./${D}
    touch ./${D}/__init__.py
  fi
done
