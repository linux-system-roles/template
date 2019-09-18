# SPDX-License-Identifier: MIT
#
# Shared shell library.
#
# Usage: . utils.sh
#
# Before including this file, it is recommended to set TOPDIR to refer the top
# directory of the project.

##
# Internal variables:
# - code that prints the version of Python interpreter to standard output; it
#   should be compatible across Python 2 and Python 3, the version is printed
#   as "${major}.${minor}"
__lsr_get_python_version_py='
import sys

sys.stdout.write("%s.%s\n" % sys.version_info[:2])
'
# - major version number from TRAVIS_PYTHON_VERSION
__lsr_travis_python_major=$(expr "${TRAVIS_PYTHON_VERSION}" : '^\([[:digit:]]\)\.[[:digit:]].*$')
# - minor version number from TRAVIS_PYTHON_VERSION
__lsr_travis_python_minor=$(expr "${TRAVIS_PYTHON_VERSION}" : '^[[:digit:]]\.\([[:digit:]]\).*$')
# - 0 if the project contains Python source files
test -n "$(cd ${TRAVIS_BUILD_DIR:-${TOPDIR:-.}} && find . \( \( -name '*.py' -or -name '*.pyi' -or -name '*.pyw' \) ! -path './.*' \))"
__lsr_has_pyfiles=$?
# - 0 if the project contains unit tests runnable in pytest
test -n "$(cd ${TRAVIS_BUILD_DIR:-${TOPDIR:-.}} && find . \( -path './tests/unit/*' -name 'test_*.py' \))"
__lsr_has_unit_tests=$?
# - used by lsr_set_exitcode, lsr_update_exitcode, and lsr_exit
__lsr_exitcode=0

# Comma separated list of environment names that are passed to tox via TOXENV.
LSR_ENVLIST=""

##
# lsr_error ARGS
#
# Print ARGS to stderr and exit with exit code 1.
function lsr_error() {
  echo "$*" >&2
  exit 1
}

##
# lsr_set_exitcode $1
#
#   $1 - exit code
#
# Set the internal variable holding exit code to $1.
function lsr_set_exitcode() {
  __lsr_exitcode=$1
}

##
# lsr_update_exitcode $1
#
#   $1 - exit code
#
# If $1 is non-zero, update the internal variable holding exit code with $1.
function lsr_update_exitcode() {
  if [[ $1 -ne 0 ]]; then
    __lsr_exitcode=$1
  fi
}

##
# lsr_exit $1
#
#   $1 - exit code (optional)
#
# If $1 is given, exit with $1. Otherwise exit with the exit code kept by
# internal variable.
function lsr_exit() {
  exit ${1:-${__lsr_exitcode}}
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
# lsr_envlist_add [conditions] envname
#
# Append envname to LSR_ENVLIST if conditions are met. Conditions are:
#
#   --if-travis-python-in VERSIONS
#
#     Evaluates as true if the version of Python interpreter used in this
#     Travis job is contained in VERSIONS (only the major and minor versions
#     are important). VERSIONS is a space or comma (other delimiters are also
#     possible) separated list of versions of format <major>.<minor>. Example:
#
#       lsr_envlist_add 'flake8' --if-travis-python-in '2.6 2.7 3.6 3.7 3.8'
#
#   --if-travis-python-is-system-python
#
#     Evaluates as true if the version of Python interpreter used in this
#     Travis job is same as the version of the system Python interpreter used
#     in the underlying Travis build environment.
#
#   --if-has-pyfiles
#
#     Evaluates as true if the project contains Python source files.
#
#   --if-has-unit-tests
#
#     Evaluates as true if the project contains unit tests runnable by pytest.
#
# If envname contains characters 'X' and 'Y', then these are replaced by major
# and minor version of Python interpreter used in this Travis job,
# respectively.
#
# Examples:
#
#   For Python 2.7, add py27 to LSR_ENVLIST. For Python 3.6, add py36 to
#   LSR_ENVLIST. The actions are taken only if the project has unit tests
#   runnable by pytest:
#
#     lsr_envlist_add 'pyXY' --if-travis-python-in '2.7 3.6' \
#                            --if-has-unit-tests
#
function lsr_envlist_add() {
  local envname
  local major="${__lsr_travis_python_major}"
  local minor="${__lsr_travis_python_minor}"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --if-travis-python-in)
        shift
        if [[ -z "${major}${minor}" || ! "$1" =~ ${major}\.${minor} ]]; then
          return
        fi
        ;;
      --if-travis-python-is-system-python)
        if [[ "$(lsr_get_python_version /usr/bin/python3)" != "${major}.${minor}" ]]; then
          return
        fi
        ;;
      --if-has-pyfiles)
        if [[ ${__lsr_has_pyfiles} -ne 0 ]]; then
          return
        fi
        ;;
      --if-has-unit-tests)
        if [[ ${__lsr_has_unit_tests} -ne 0 ]]; then
          return
        fi
        ;;
      --*)
        lsr_error "${FUNCNAME[0]}: Unrecognized option '$1'."
        ;;
      *)
        envname="$1"
        ;;
    esac
    shift
  done

  envname=$(echo ${envname} | tr XY ${major:-X}${minor:-Y})

  if [[ "${envname}" ]]; then
    if [[ "${LSR_ENVLIST}" ]]; then
      LSR_ENVLIST="${LSR_ENVLIST},${envname}"
    else
      LSR_ENVLIST="${envname}"
    fi
  fi
}
