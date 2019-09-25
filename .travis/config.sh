# SPDX-License-Identifier: MIT
#
# Use this file to specify custom configuration for a project. Generally, this
# involves the modification of the content of LSR_* environment variables, see
#
#   * .travis/preinstall:
#
#       - LSR_EXTRA_PACKAGES
#
#   * .travis/runtox:
#
#       - LSR_ANSIBLES
#       - LSR_MSCENARIOS
#
#   * .travis/runcoveralls.sh:
#
#       - LSR_PUBLISH_COVERAGE
#
# Environment variables that not start with LSR_* but have influence on CI
# process:
#
#   * run_pylint.py:
#
#       - RUN_PYLINT_INCLUDE
#       - RUN_PYLINT_EXCLUDE
#       - RUN_PYLINT_DISABLED
#

##
# lsr_coveralls_hook ARGS
#
# Called from .travis/runcoveralls.sh.
function lsr_coveralls_hook() {
  # Add custom commands here.
  return 0
}

##
# lsr_runsyspycmd_hook ARGS
#
# Called from .travis/runsyspycmd.sh.
function lsr_runsyspycmd_hook() {
  # Add custom commands here.
  return 0
}
