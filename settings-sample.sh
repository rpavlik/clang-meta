# This is for Ubuntu 12.04 with a stow-managed prefix at /home/rpavlik/deps.
# Copy to settings.sh and customize if you like.

export PREFIX=/home/rpavlik/deps
export INSTALLDIR=/home/rpavlik/deps/stow/llvm
export CXXABI=libstdc++
export DISABLED_REPOS=(libcxx compiler-rt)

# Determined using echo | g++ -Wp,-v -x c++ - -fsyntax-only
# as explained on the libcxx web site.
export EXTRA_CONFIG="-DLIBCXX_LIBSUPCXX_INCLUDE_PATHS=/usr/include/c++/4.6;/usr/include/c++/4.6/x86_64-linux-gnu;/usr/lib/gcc/x86_64-linux-gnu/4.6/include;/usr/lib/gcc/x86_64-linux-gnu/4.6/include-fixed;/usr/include/x86_64-linux-gnu"

# For the parallel and adventurous - use generic-build instead of build-with-make
# export EXTRA_CONFIG="-G Ninja"
