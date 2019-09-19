# SPDX-License-Identifier: MIT
#
# Auxiliary functions and variables.
#
# Usage: . utils.sh

# All variables prefixed with __lsr_ are used internally and should not be
# changed by the user in .travis/config.sh (but the user may read them).

# Code that prints the version of Python interpreter to standard output; it
# should be compatible across Python 2 and Python 3, the version is printed as
# "{major}.{minor}".
__lsr_get_python_version_py='
import sys

sys.stdout.write("%s.%s\n" % sys.version_info[:2])
'

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

# Get the version of Python interpreter used in this Travis job. First, try to
# extract "{major}.{minor}" from TRAVIS_PYTHON_VERSION. If that fails, fallback
# to `python -c "__lsr_get_python_version_py"` (from logs, python refers to
# Python interpreter associated with Travis job, i.e. for "- python: 3.6" in
# .travis.yml job matrix definiton, `python --version`, when run from inside
# the job, it prints "Python 3.6.7" or similar).
if [[ "${TRAVIS}" ]]; then
  __lsr_travis_python_version=$( \
    expr "${TRAVIS_PYTHON_VERSION}" : '^\([[:digit:]]\.[[:digit:]]\).*$' \
  )
  if [[ -z "${__lsr_travis_python_version}" ]]; then
    __lsr_travis_python_version=$(lsr_get_python_version python)
  fi
  # Store version in a form of array.
  __lsr_travis_python_version=( \
    $(echo ${__lsr_travis_python_version} | tr '.' ' ') \
  )
fi

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
# If envname contains characters 'X' and 'Y', then these are replaced by major
# and minor version of Python interpreter used in this Travis job,
# respectively.
#
# Examples:
#
#   For Python 2.7, add py27 to LSR_ENVLIST; for Python 3.6, add py36 to
#   LSR_ENVLIST:
#
#     lsr_envlist_add 'pyXY' --if-travis-python-in '2.7 3.6'
#
function lsr_envlist_add() {
  local envname
  local X="${__lsr_travis_python_version[0]}"
  local Y="${__lsr_travis_python_version[1]}"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --if-travis-python-in)
        shift
        if [[ -z "${X}${Y}" || ! "$1" =~ ${X}\.${Y} ]]; then
          return
        fi
        ;;
      --if-travis-python-is-system-python)
        if [[ \
          "$(lsr_get_python_version /usr/bin/python3)" != "${X}.${Y}" \
        ]]; then
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

  envname=$(echo ${envname} | tr XY ${X:-X}${Y:-Y})

  if [[ "${envname}" ]]; then
    if [[ "${LSR_ENVLIST}" ]]; then
      LSR_ENVLIST="${LSR_ENVLIST},${envname}"
    else
      LSR_ENVLIST="${envname}"
    fi
  fi
}
