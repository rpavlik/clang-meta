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

echo "Installing to ${INSTALLDIR}"

GITDIRS=(".:llvm:http://llvm.org/git/llvm.git"
         "llvm/tools:clang:http://llvm.org/git/clang.git"
         "llvm/tools/clang/tools:extra:http://llvm.org/git/clang-tools-extra.git"
         "llvm/tools/clang/tools:include-what-you-use:https://github.com/include-what-you-use/include-what-you-use.git"
         "llvm/projects:compiler-rt:https://github.com/llvm-mirror/compiler-rt.git"
         "llvm/projects:libcxx:http://llvm.org/git/libcxx.git")

ineachrepo() {(
  for entry in "${GITDIRS[@]}" ; do
    PARENTDIR="${entry%%:*}"
    repoanddir="${entry#*:}"
    SUBDIR="${repoanddir%%:*}"
    REPO="${repoanddir#*:}"
    #echo "Parent dir: $PARENTDIR repoanddir: $repoanddir Subdir: $SUBDIR  Repo: $REPO"
    $@ $PARENTDIR $SUBDIR $REPO
  done
)}

inbuilddir() {(
  cd $BUILDDIR && $*
  )
}


