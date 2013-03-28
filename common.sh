#!/bin/bash -E

BASEDIR=$(cd $(dirname $0) && pwd)
SRCROOT=$BASEDIR/src
SRCDIR=$SRCROOT/llvm
BUILDDIR=$BASEDIR/build
INSTALLDIR=$BASEDIR/install

GITDIRS= (".:llvm:http://llvm.org/git/llvm.git"
          "llvm/tools:clang:http://llvm.org/git/clang.git"
          "llvm/tools/clang/tools:extra:http://llvm.org/git/clang-tools-extra.git"
          "llvm/tools/clang/tools:include-what-you-use:git://github.com/vancegroup-mirrors/include-what-you-use.git")

# TODO: should have clone commands in here too, with git config branch.master.rebase true


ineachrepo() {(
  for entry in "${GITDIRS[@]}" ; do
    PARENTDIR="${entry%%:*}"
    repoanddir="${entry#*:}"
    SUBDIR="${repoanddir%%:*}"
    REPO="${repoanddir#:*}"
    $@ $PARENTDIR $SUBDIR $REPO
  done
)}

doclone() {(
  PARENTDIR=$1
  SUBDIR=$2
  REPO=$3
  cd ${SRCROOT}
  mkdir -p $PARENTDIR
  cd $PARENTDIR && git clone $REPO && cd $SUBDIR && git config branch.master.rebase true
)}

clone() {(
  mkdir -p ${SRCROOT}
  ineachrepo doclone
)}

reconfigure() {(
  if [ -x "${INSTALLDIR}/bin/clang" -a -x "${INSTALLDIR}/bin/clang++" ]; then
    echo "Using previous build of Clang for CC/CXX"
    CC=${INSTALLDIR}/bin/clang
    CXX=${INSTALLDIR}/bin/clang++  
  else
    echo "Bootstrapping - using system CC/CXX"
  fi

	mkdir -p $BUILDDIR && cd $BUILDDIR

	rm -f CMakeCache.txt
  cmake $SRCDIR \
    -DCMAKE_INSTALL_PREFIX=$INSTALLDIR \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TARGETS_TO_BUILD=X86
  )
}

inbuilddir() {(
  cd $BUILDDIR && $*
  )
}

dopull() {(
  cd ${SRCROOT} && cd $1 && cd $2 && git pull
  )
}

pull() {
  ineachrepo dopull
}

