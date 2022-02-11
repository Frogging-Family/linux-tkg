#!/bin/bash

msg2() {
 echo -e " \033[1;34m->\033[1;0m \033[1;1m$1\033[1;0m" >&2
}

escape() {
  _escaped=$(printf '%s\n' "$1" | sed -e 's/[]\/$*.^[]/\\&/g')
}

kernel_tags=$(git -c 'versionsort.suffix=-' \
    ls-remote --exit-code --refs --sort='version:refname' --tags https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git '*.*' \
    | cut --delimiter='/' --fields=3)

source linux-tkg-config/prepare

updates=""
for _key in "${_current_kernels[@]}"; do
  latest_full_ver=$(echo "$kernel_tags" | grep -F "v$_key" | tail -1 | cut -c2-)

  _from_rc_to_release="false"
  if [[ "${_kver_subver_map[$_key]}" == rc* ]]; then
    if [[ "$latest_full_ver" == *rc* ]]; then
      latest_subver="${latest_full_ver##*-rc}"
    else
      _from_rc_to_release="true"
      if [ "$latest_full_ver" = "$_key "]; then
        # this is the first release after rc, so the kernel version will be 5.xx (and not 5.xx.0)
        latest_subver="0"
      else
        # For whatever reason we are moving from an rc kernel to 5.xx.y
        latest_subver="${latest_full_ver##*.}"
      fi
    fi

    current_subver="${_kver_subver_map[$_key]}"
    current_subver="${current_subver##*rc}"
  else
    if [ "$latest_full_ver" != "$_key" ]; then
      latest_subver="${latest_full_ver##*.}"
    else
      latest_subver="0"
    fi
    current_subver=${_kver_subver_map[$_key]}
  fi

  echo "current version on repository $_key.${_kver_subver_map[$_key]} -> $current_subver"
  echo "upstream version $latest_full_ver -> $latest_subver"

  old_kernel_shasum=""
  new_kernel_shasum=""

  old_kernel_patch_shasum=""
  new_kernel_patch_shasum=""

  if [ "$_from_rc_to_release" = "true" ]; then
    # append kernel version update to updates
    updates="${updates} ${latest_full_ver}"

    echo "Updating from rc kernel to release in linux-tkg-config/prepare"

    escape "[\"${_key}\"]=\"rc${current_subver}\""
    _from="$_escaped"

    escape "[\"${_key}\"]=\"${latest_subver}\""
    _to="$_escaped"

    sed -i "/^_kver_subver_map=($/,/^)$/s|$_from|$_to|g" linux-tkg-config/prepare

    old_kernel_shasum=$(curl -sL https://git.kernel.org/torvalds/t/linux-${_key}-rc${current_subver}.tar.gz | sha256sum | cut -d' ' -f1)
    new_kernel_shasum=$(curl -sL https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${_key}.tar.xz | sha256sum | cut -d' ' -f1)

    if [ "$latest_subver" != "0" ]; then
      # we move from an rc release directly to a kernel with a subversion update
      sed -i "s|#\"\$patch_site\"|\"\$patch_site\"|g" PKGBUILD
      old_kernel_patch_shasum="#upcoming_kernel_patch_sha256"
      new_kernel_patch_shasum="'$(curl -sL https://cdn.kernel.org/pub/linux/kernel/v5.x/patch-${_key}.${latest_subver}.xz | sha256sum | cut -d' ' -f1)'"
    fi
  elif (( "$current_subver" < "$latest_subver" )); then
    # append kernel version update to updates
    updates="${updates} ${latest_full_ver}"

    echo "Newer upstream"
    if [[ "${_kver_subver_map[$_key]}" == rc* ]]; then
      echo "Updating rc kernel version in linux-tkg-config/prepare"

      escape "[\"${_key}\"]=\"rc${current_subver}\""
      _from="$_escaped"

      escape "[\"${_key}\"]=\"rc${latest_subver}\""
      _to="$_escaped"

      sed -i "/^_kver_subver_map=($/,/^)$/s|$_from|$_to|g" linux-tkg-config/prepare

      old_kernel_shasum=$(curl -sL https://git.kernel.org/torvalds/t/linux-${_key}-rc${current_subver}.tar.gz | sha256sum | cut -d' ' -f1)
      new_kernel_shasum=$(curl -sL https://git.kernel.org/torvalds/t/linux-${_key}-rc${latest_subver}.tar.gz | sha256sum | cut -d' ' -f1)
    else
      echo "Updating kernel version in linux-tkg-config/prepare"

      escape "[\"${_key}\"]=\"${current_subver}\""
      _from="$_escaped"

      escape "[\"${_key}\"]=\"${latest_subver}\""
      _to="$_escaped"

      sed -i "/^_kver_subver_map=($/,/^)$/s|$_from|$_to|g" linux-tkg-config/prepare

      if [ "$current_subver" = "0" ]; then
        # we move from an initial release to a kernel subversion update
        sed -i "s|#\"\$patch_site\"|\"\$patch_site\"|g" PKGBUILD
        old_kernel_patch_shasum="#upcoming_kernel_patch_sha256"
        new_kernel_patch_shasum="'$(curl -sL https://cdn.kernel.org/pub/linux/kernel/v5.x/patch-${_key}.${latest_subver}.xz | sha256sum | cut -d' ' -f1)'"
      else
        old_kernel_patch_shasum="$(curl -sL https://cdn.kernel.org/pub/linux/kernel/v5.x/patch-${_key}.${current_subver}.xz | sha256sum | cut -d' ' -f1)"
        new_kernel_patch_shasum="$(curl -sL https://cdn.kernel.org/pub/linux/kernel/v5.x/patch-${_key}.${latest_subver}.xz | sha256sum | cut -d' ' -f1)"
      fi
    fi
  else
    echo "Same upstream"
  fi

  if [ -n "$new_kernel_shasum" ]; then
    echo "Updating kernel shasum in PKGBUILD"
    sed -i "s|$old_kernel_shasum|$new_kernel_shasum|g" PKGBUILD
  fi

  if [ -n "$new_kernel_patch_shasum" ]; then
    echo "Updating kernel patch shasum in PKGBUILD"
    sed -i "s|$old_kernel_patch_shasum|$new_kernel_patch_shasum|g" PKGBUILD
  fi

  echo "----------------------"
done

echo "$updates" > kernel_updates
