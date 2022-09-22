#!/bin/bash

msg2() {
 echo -e " \033[1;34m->\033[1;0m \033[1;1m$1\033[1;0m" >&2
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR/../linux-tkg-config/prepare"
trap - EXIT

# needed to call _set_kver_internal_vars
_where="$SCRIPT_DIR/.."

_kernel_git_tag="${_kver_latest_tags_map[${_current_kernels[0]}]}"
[[ "$_kernel_git_tag" == *rc* ]] && _kernel_git_tag="${_kver_latest_tags_map[${_current_kernels[1]}]}"

_latest_kernel="$_kernel_git_tag"

echo "$_latest_kernel" > "$SCRIPT_DIR/latest-kernel"
