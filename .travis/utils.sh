# SPDX-License-Identifier: MIT
#
# Auxiliary functions and variables.
#
# Usage: . utils.sh

# All variables prefixed with __lsr_ are internal.

# Code that prints the version of Python interpreter to standard output; it
# should be compatible across Python 2 and Python 3, the version is printed as
# "{major}.{minor}".
__lsr_get_python_version_py='
import sys

sys.stdout.write("%s.%s\n" % sys.version_info[:2])
'

echo "COLORTERM=${COLORTERM}"
echo "TERM=${TERM}"
echo "lowercase(TERM)=${TERM,,}"

# Colors for lsr_info and lsr_error.
if [[ "${COLORTERM}" || "${TERM,,}" =~ ^(xterm|linux|.*color.*)$ ]]; then
  __lsr_color_normal='\033[39m'
  __lsr_color_red='\033[31m'
  __lsr_color_blue='\033[34m'
fi

##
# lsr_info ARGS
#
# Print ARGS (in blue) to stdout.
function lsr_info() {
  echo -e "${__lsr_color_blue}$*${__lsr_color_normal}"
}

##
# lsr_error ARGS
#
# Print ARGS (in red) to stderr and exit with exit code 1.
function lsr_error() {
  echo -e "${__lsr_color_red}$*${__lsr_color_normal}" >&2
  exit 1
}

##
# lsr_get_python_version $1
#
#   $1 - command or full path to Python interpreter
#
# If $1 is installed, return its version.
function lsr_get_python_version() {
  if command -v $1 >/dev/null 2>&1; then
    $1 -c "${__lsr_get_python_version_py}"
  fi
}

##
# lsr_compare_versions $1 $2 $3
#
#   $1 - version string (see notes below)
#   $2 - binary operation (see TEST(1))
#   $3 - version string (see notes below)
#
# Exit with 0 if `$1 $2 $3`.
#
# Notes:
#   A version string is of the format [:digit:] "." [:digit:].
function lsr_compare_versions() {
  if [[ $# -lt 3 ]]; then
    return 1
  fi

  test ${1//./} $2 ${3//./}
}

##
# lsr_check_python_version $1 $2 $3
#
#   $1 - command or full path to Python interpreter
#   $2 - binary operation (see TEST(1))
#   $3 - version string in [:digit:] "." [:digit:] format.
#
# Exit with 0 if `version($1) $2 $3`.
function lsr_check_python_version() {
  if [[ $# -lt 3 ]]; then
    return 1
  fi

  lsr_compare_versions $(lsr_get_python_version $1) $2 $3
}

##
# lsr_compare_pythons $1 $2 $3
#
#   $1 - command or full path to Python interpreter
#   $2 - binary operation (see TEST(1))
#   $3 - command or full path to Python interpreter
#
# Exit with 0 if `version($1) $2 version($3)`.
function lsr_compare_pythons() {
  if [[ $# -lt 3 ]]; then
    return 1
  fi

  lsr_compare_versions \
    $(lsr_get_python_version $1) $2 $(lsr_get_python_version $3)
}
