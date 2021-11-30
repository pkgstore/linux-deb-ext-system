#!/usr/bin/bash

(( EUID != 0 )) &&
  { echo >&2 "This script should be run as root!"; exit 1; }

# Init.
init() {
  # Apps.
  apt="$( command -v apt )"
  date="$( command -v date )"
  mkdir="$( command -v mkdir )"

  # Run.
  upgrade
}

# Upgrade OS.
upgrade() {
  ts="$( _timestamp )"
  dir="/var/log/apt.auto/$( _year )/$( _month )"

  [[ -d "${dir}" ]] || ${mkdir} -p "${dir}"

  ${apt} update --quiet --yes >> "${dir}/${ts}.log"
  ${apt} full-upgrade --quiet --yes >> "${dir}/${ts}.log"
}

# Year.
_year() {
  ${date} -u '+%Y'
}

# Month.
_month() {
  ${date} -u '+%m'
}

# Timestamp.
_timestamp() {
  ${date} +%s%N | cut -b1-13
}

init
exit 0
