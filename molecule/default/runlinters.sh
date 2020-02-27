#!/bin/bash
# SPDX-License-Identifier: MIT

set -x

E=0

yamllint -c molecule/default/yamllint.yml . || E=$?
ansible-lint || E=$?

exit $E
