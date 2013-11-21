# This is for Ubuntu 12.04 with a stow-managed prefix at /home/rpavlik/deps.
# Copy to settings.sh and customize if you like.

export PREFIX=/home/rpavlik/deps
export INSTALLDIR=/home/rpavlik/deps/stow/llvm
export CXXABI=libstdc++
export EXTRA_CONFIG="-DLIBCXX_LIBSUPCXX_INCLUDE_PATHS=/usr/include/c++/4.6;/usr/include/c++/4.6/x86_64-linux-gnu;/usr/lib/gcc/x86_64-linux-gnu/4.6/include;/usr/lib/gcc/x86_64-linux-gnu/4.6/include-fixed;/usr/include/x86_64-linux-gnu"

