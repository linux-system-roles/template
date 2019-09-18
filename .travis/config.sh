# SPDX-License-Identifier: MIT
#
# Use this file to specify custom configuration for a project. Generally, this
# involves the modification of the content of LSR_* environment variables, see
#
#   * .travis/utils.sh:
#
#       - LSR_ENVLIST
#
#   * .travis/preinstall:
#
#       - LSR_EXTRA_PACKAGES
#
#   * .travis/runtox:
#
#       - LSR_MSCENARIOS
#
#   * tox.ini:
#
#       - LSR_MOLECULE_DEPS
#       - LSR_TEXTRA_DEPS
#       - LSR_TEXTRA_DIR
#       - LSR_TEXTRA_CMD
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
