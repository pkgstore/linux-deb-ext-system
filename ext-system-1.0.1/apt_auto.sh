#!/usr/bin/bash

(( EUID != 0 )) &&
  { echo >&2 "This script should be run as root!"; exit 1; }

init() {
  # Apps.
  apt="$( command -v apt )"
  date="$( command -v date )"
  mkdir="$( command -v mkdir )"

  # Run.
  upgrade
}

_date_year() {
  ${date} -u '+%Y'
}

_date_month() {
  ${date} -u '+%m'
}

_timestamp() {
  ${date} +%s%N | cut -b1-13
}

upgrade() {
  dt="$( _date_year )/$( _date_month )"
  ts="$( _timestamp )"
  dir="/var/log/apt.auto/${dt}"

  [[ -d "${dir}" ]] || ${mkdir} -p "${dir}"

  ${apt} update --quiet --yes >> "${dir}/${ts}.log"
  ${apt} full-upgrade --quiet --yes >> "${dir}/${ts}.log"
}

init
exit 0
