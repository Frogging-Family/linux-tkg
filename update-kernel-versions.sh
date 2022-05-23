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
trap - EXIT

# Start by making sure our GnuPG environment is sane
if [[ ! -x /usr/bin/gpg ]]; then
  echo "Could not find gpg"
  exit 4
fi

## Generate the keyring
if [ ! -s gnupg/keyring.gpg ]; then
  if [[ ! -d gnupg ]]; then
    echo "gnupg directory does not exist"
    mkdir -p -m 0700 gnupg
  fi
  echo "Making sure we have all the necessary keys"
  gpg --batch --quiet --homedir gnupg --auto-key-locate wkd --locate-keys torvalds@kernel.org gregkh@kernel.org autosigner@kernel.org
  if [[ $? != "0" ]]; then
    echo "FAILED to retrieve keys"
    exit 3
  fi
  gpg --batch --homedir gnupg --export torvalds@kernel.org gregkh@kernel.org autosigner@kernel.org > gnupg/keyring.gpg
  echo "----------------------"
fi

# Cleanup
rm -f v*.x.sha256sums{,.asc}

updates=""
for _key in "${_current_kernels[@]}"; do
  latest_full_ver=$(echo "$kernel_tags" | grep -F "v$_key" | tail -1 | cut -c2-)
  kver_major="$(echo ${_key} | cut -d. -f1)"
  kver_base="$(echo ${_key} | tr -d ".")"

  ## Getting sha256sums by sha256sums.asc
  if [ ! -s v${kver_major}.x.sha256sums ]; then
    echo "Downloading the checksums file for linux-v${kver_major}.x"
    curl -sL --retry 2 -o "v${kver_major}.x.sha256sums.asc" https://cdn.kernel.org/pub/linux/kernel/v${kver_major}.x/sha256sums.asc
    if [[ $? != "0" ]]; then
      echo "FAILED to download the v${kver_major}.x checksums file"
      exit 3
    fi
    echo "Verifying the v${kver_major}.x checksums file"
    count_gpg=$(gpg --homedir gnupg --keyring=gnupg/keyring.gpg --status-fd=1 v${kver_major}.x.sha256sums.asc | grep -c -E '^\[GNUPG:\] (GOODSIG|VALIDSIG)')
    if [[ ${count_gpg} -lt 2 ]]; then
      echo "FAILED to verify the v${kver_major}.x.sha256sums file."
      rm -f "v${kver_major}.x.sha256sums"
      exit 3
    fi
    rm -f "v${kver_major}.x.sha256sums.asc"
    echo "----------------------"
  fi

  _from_rc_to_release="false"
  if [[ "${_kver_subver_map[$_key]}" == rc* ]]; then
    if [[ "$latest_full_ver" == *rc* ]]; then
      latest_subver="${latest_full_ver##*-rc}"
    else
      _from_rc_to_release="true"
      if [ "$latest_full_ver" = "$_key" ]; then
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

    old_kernel_shasum=$(grep -A$(wc -l PKGBUILD | cut -d' ' -f1) "${kver_base})" PKGBUILD | grep sha256sums -m 1 - | cut -d \' -f2)
    new_kernel_shasum=$(grep linux-${_key}.tar.xz v${kver_major}.x.sha256sums | cut -d' ' -f1)

    if [ ! -n "$new_kernel_shasum" ]; then
      echo "WARNING sha256sum for linux-${_key} was not found."
      echo "Downloading the XZ tarball for linux-${_key}"
      curl -sL --retry 2 -o "linux-${_key}.tar.xz" https://cdn.kernel.org/pub/linux/kernel/v${kver_major}.x/linux-${_key}.tar.xz 
      if [[ $? != "0" ]]; then
        echo "FAILED to download the linux-${_key}.tar.xz"
        exit 3
      fi

      echo "Downloading and verifying developer signature on the tarball for linux-${_key}"
      curl -sL --retry 2 -o "linux-${_key}.tar.sign" https://cdn.kernel.org/pub/linux/kernel/v${kver_major}.x/linux-${_key}.tar.sign 
      if [[ $? != "0" ]]; then
        echo "FAILED to download the linux-${_key}.tar.sign"
        exit 3
      fi
      xz -kdf linux-${_key}.tar.xz
      count_gpg=$(gpg --homedir gnupg --keyring=gnupg/keyring.gpg --status-fd=1 linux-${_key}.tar.sign | grep -c -E '^\[GNUPG:\] (GOODSIG|VALIDSIG)')
      if [[ ${count_gpg} -lt 2 ]]; then
        echo "FAILED to verify the linux-${_key}.tar file."
        exit 3
      fi
      rm -f linux-${_key}.tar{,.sign}

      new_kernel_shasum=$(sha256sum linux-${_key}.tar.xz | cut -d' ' -f1)
    fi

    if [ "$latest_subver" != "0" ]; then
      # we move from an rc release directly to a kernel with a subversion update
      sed -i "s|#\"\$patch_site\"|\"\$patch_site\"|g" PKGBUILD
      old_kernel_patch_shasum="#upcoming_kernel_patch_sha256"
      new_kernel_patch_shasum="'$(grep patch-${_key}.${latest_subver}.xz v${kver_major}.x.sha256sums | cut -d' ' -f1)'"
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

      old_kernel_shasum=$(grep -A$(wc -l PKGBUILD | cut -d' ' -f1) "${kver_base})" PKGBUILD | grep sha256sums -m 1 - | cut -d \' -f2)

      # For RC we need download the original file
      echo "Downloading the GZ tarball for linux-${_key}-rc${latest_subver}"
      curl -sL --retry 2 -o "linux-${_key}-rc${latest_subver}.tar.gz" https://git.kernel.org/torvalds/t/linux-${_key}-rc${latest_subver}.tar.gz
      if [[ $? != "0" ]]; then
        echo "FAILED to download the linux-${_key}-rc${latest_subver}.tar.gz"
        exit 3
      fi

      new_kernel_shasum=$(sha256sum linux-${_key}-rc${latest_subver}.tar.gz | cut -d' ' -f1)
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
        new_kernel_patch_shasum="'$(grep patch-${_key}.${latest_subver}.xz v${kver_major}.x.sha256sums | cut -d' ' -f1)'"
      else
        old_kernel_patch_shasum="$(grep patch-${_key}.${current_subver}.xz v${kver_major}.x.sha256sums | cut -d' ' -f1)"
        new_kernel_patch_shasum="$(grep patch-${_key}.${latest_subver}.xz v${kver_major}.x.sha256sums | cut -d' ' -f1)"
      fi
    fi
  else
    echo "Same upstream"
  fi

  if [ -n "$new_kernel_shasum" ]; then
    echo "Updating kernel shasum in PKGBUILD"
    echo "old kernel: $old_kernel_shasum"
    echo "new kernel: $new_kernel_shasum"
    sed -i "s|$old_kernel_shasum|$new_kernel_shasum|g" PKGBUILD
  fi

  if [ -n "$new_kernel_patch_shasum" ]; then
    echo "Updating kernel patch shasum in PKGBUILD"
    echo "old kernel patch: $old_kernel_patch_shasum"
    echo "new kernel patch: $new_kernel_patch_shasum"
    sed -i "s|$old_kernel_patch_shasum|$new_kernel_patch_shasum|g" PKGBUILD
  fi

  echo "----------------------"
done

echo "$updates" > kernel_updates
