#!/bin/bash

script="`dirname \"$(readlink -f $0)\"`/server"

# options
user=deploy
env=production
port=3000
host=0.0.0.0

usage() {
  echo "Usage: $0 [options]"
  echo
  echo "options:"
  echo "-u USER        (default: $user)"
  echo "-d DIRECTORY   (default: current directory)"
  echo "-e ENVIRONMENT (default: $env)"
  echo "-p PORT        (default: $port)"
  echo "-o HOST        (default: $host)"
  echo
  exit
}

while getopts u:d:e:p:o:h arg
do
  case "$arg" in
    u)
      user="$OPTARG"
      ;;
    d)
      dir="$OPTARG"
      ;;
    e)
      env="$OPTARG"
      ;;
    p)
      port="$OPTARG"
      ;;
    o)
      host="$OPTARG"
      ;;
    h)
      usage
      ;;
    ?)
      usage
  esac
done

if [ ! -z "$dir" ]; then
  script="$dir/scripts/server"
fi

su -c "bash -l -c 'rvm 1.9.2 ruby $script -p $port -e $env -o $host -d'" -l $user
