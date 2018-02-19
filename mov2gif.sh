#!/usr/bin/env bash

set -e

readonly VERSION='1.0.1'
readonly DEPENDENCIES=('ffmpeg' 'convert')
readonly ARGS="$@"

checkDependencies() {
  for dep in ${DEPENDENCIES[@]}
  do
    command -v ${dep} > /dev/null 2>&1 || (echo "Missing required dependency ${dep}. Please make sure it is installed on your system." >&2 && exit 1)
  done
}

cleanup() {
  if [ -d ${TMPDIR} ]; then
    rm -rf "{TMPDIR}"
  fi
}

usage() {
  cat <<-EOF
  ${0} [-hv] file.mov [-o output.gif] [-w width]
  Convert .mov to animted GIF.
EOF
}

version() {
  echo "mov2gif v${VERSION}"
}

mov2png() {
  local input=${1}
  local width=${2}

  ffmpeg -i "${input}" -vf scale="${width}":-1 -r 10 "${TMPDIR}/ffout%3d.png" > /dev/null 2>&1
}

png2gif() {
  local output=${1}

  convert -delay 8 -loop 0 "${TMPDIR}/ffout*.png" "${output}" > /dev/null 2>&1
}

main() {
  local arg
  for arg
  do
    case "${arg}" in
      --help)     args="${args}-h " ;;
      --output)   args="${args}-o " ;;
      --version)  args="${args}-v " ;;
      --width)    args="${args}-w " ;;
      *)          args="${args} ${arg} " ;;
    esac
  done

  eval set -- ${args}

  local gif
  local width

  while getopts "ho:vw:" OPTION;
  do
    case ${OPTION} in
      h)
        usage
        exit 0
        ;;
      o)
        gif="${OPTARG}"
        ;;
      v)
        version
        exit 0
        ;;
      w)
        width="${OPTARG}"
        ;;
    esac
  done

  shift $((OPTIND-1))

  local mov=${1}
  if [ -z ${mov} ]; then
    echo "No .mov file given. Nothing to do."
    usage
    exit 0
  elif [ ${mov: -4} != '.mov' ]; then
    echo "Not a .mov file: ${mov}" >&2
    exit 1
  fi

  mov=$(realpath "${mov}")
  if ! [ -f ${mov} ]; then
    echo "File does not exist: ${mov}" >&2
    exit 1
  fi

  if [ -z ${gif} ]; then
    gif="$(dirname ${mov})/$(basename ${mov}).gif"
  elif [ ${gif: -4} != '.gif' ]; then
    gif="${gif}.gif"
  fi
  
  gif=$(realpath "${gif}")
  if [ -f ${gif} ]; then
    echo "File already exists: ${gif}" >&2
    exit 1
  fi

  if [ -z ${width} ]; then
    width=-1
  elif [ "${width//[0-9]}" != "" ]; then
    echo "Width must be an integer. ${width} given." >&2
    exit 1
  fi

  readonly TMPDIR=$(mktemp -d)
  printf "Converting\n${mov}\nto\n${gif}\n"
  mov2png "${mov}" "${width}"
  png2gif "${gif}"
}

trap cleanup EXIT

checkDependencies
main ${ARGS[@]}
