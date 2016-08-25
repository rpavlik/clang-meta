#!/bin/bash -E

BASEDIR=$(cd $(dirname $0) && pwd)
if [ -f "${BASEDIR}/settings.sh" ]; then
  source "${BASEDIR}/settings.sh"
fi

SRCROOT=$BASEDIR/src
SRCDIR=$SRCROOT/llvm
BUILDDIR=$BASEDIR/builddir
PREFIX=${PREFIX:-$BASEDIR/installdir}
INSTALLDIR=${INSTALLDIR:-$PREFIX}
TARGETS=${TARGETS:-X86}
DISABLED_REPOS=${DISABLED_REPOS:-( )}

echo "Installing to ${INSTALLDIR}"

GITDIRS=(".:llvm:http://llvm.org/git/llvm.git"
         "llvm/tools:clang:http://llvm.org/git/clang.git"
         "llvm/tools/clang/tools:extra:http://llvm.org/git/clang-tools-extra.git"
         "llvm/tools/clang/tools:include-what-you-use:https://github.com/include-what-you-use/include-what-you-use.git"
         "llvm/projects:compiler-rt:https://github.com/llvm-mirror/compiler-rt.git"
         "llvm/projects:libcxx:http://llvm.org/git/libcxx.git")

# modified from http://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value
elementIn () {
  local e
  # the || true is to avoid failure in -E mode.
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0 || true; done
  return 1
}

subdirDisabled() {
    if elementIn $1 "${DISABLED_REPOS[@]}"; then
        return 0
    fi
    return 1
}

ineachrepo() {(
  for entry in "${GITDIRS[@]}" ; do

    # Deletes the longest match of substring :* to end of string
    # - effectively extracting the **first colon-separated field**.
    PARENTDIR="${entry%%:*}"

    # Deletes the shortest match of substring *: from start of string
    # - effectively extracting the second and third colon separated fields,
    # to be used as an intermediate value.
    repoanddir="${entry#*:}"

    # Deletes the longest match of substring :* to end of string
    # - extracting the **second field** from the variable that had just the second and third fields.
    SUBDIR="${repoanddir%%:*}"

    # Deletes the shortest match of substring *: from start of string
    # - extracting the **third field** from the variable that had just the second and third fields.
    REPO="${repoanddir#*:}"
    #echo "Parent dir: $PARENTDIR repoanddir: $repoanddir Subdir: $SUBDIR  Repo: $REPO"

    if ! subdirDisabled $SUBDIR; then
        $@ $PARENTDIR $SUBDIR $REPO
    fi
  done
)}

inbuilddir() {(
  cd $BUILDDIR && $*
  )
}
