Clang Meta
==========

The purpose of this repository is to make it easy to get a full LLVM and Clang compiler system set up, built, and then updated. Designed for *nix-type platforms: the clone/pull scripts might work under Git for Windows.

These scripts allow you to follow the latest development (trunk/master) on:

- [llvm][]
- [clang][]
- [clang-tools-extra][]
- [include-what-you-use][]
- [compiler-rt][]

Because these are scripts to check out git repos, not a set of submodules, the fact that this repository goes for a long time between commits doesn't mean it won't work: it just means it still works.  It's effectively "feature complete" until there's a new project I'd like built.

For all of these, the git mirror is used.  In the absence of an official git mirror for include-what-you-use (IWYU), I've set up an automatic mirror here: <http://github.com/vancegroup-mirrors/include-what-you-use>

The CMake build system is used. Patches are applied in the Clang tree in order to include the IWYU directory in the build.

Occasionally, Clang updates will break IWYU. IWYU is usually fairly quickly updated to match, but reporting a breakage (after trying pulling again) on their mailing list or issue tracker would likely be appreciated.


[llvm]:http://llvm.org
[clang]:http://clang.llvm.org
[clang-tools-extra]:http://clang.llvm.org/docs/ClangTools.html
[include-what-you-use]:https://code.google.com/p/include-what-you-use/
[compiler-rt]:http://compiler-rt.llvm.org/

Dependencies
------------

- git
- CMake (post-2.8.10 if you want compiler-rt to build, or for just llvm, clang, and iwyu an older version is OK)
- a C/C++ compiler on your system (gcc is usually there and usually works)
- Optional dependencies for some llvm parts:
   - libxml2 and its dev package/files
   - doxygen, its tools (`dot`, etc.), and the `xdot.py` tool
   - others, unknown?


Using These Scripts
-------------------
When first setting up a build, you will want to run the following (after setting install directory if desired, see below):

    ./clone && ./reconfigure


To compile and install, just run (with any arguments passed through to "make", so `-jX` for an `X`-parallel build):

    ./build [-j4]

To update the source trees:

    ./pull

You may proceed right to a build from that point, or choose to `reconfigure` - the latter is generally recommended if the version has been bumped due to release, if you've changed the install directory, and as just a general good practice once in a while.

If this repo is updated to include more llvm-related projects, `./clone` and `./reconfigure` should be good to get you going. You might see some weird things that appear to be errors in `clone` (trouble applying patches) but it will catch them and move on. In the worst case scenario, you can just blow away the `src` directory and run `clone` from scratch.

Bootstrapping
-------------
If there's nothing in your install directory, the `reconfigure` script will just use your system compilers to build the suite.  However, once you've done a build, running `reconfigure` will allow it to see that you have a Clang build which it will use for compilation from that point.

Configuration
-------------
The directory where you've cloned this repo is the base directory for all the following paths.  `clone` and `pull` will create/update git repos in `src/`.  The `reconfigure` and `build` scripts manage a build tree in `builddir/`. Finally, by default, `$INSTALLDIR` gets set to `installdir/`.

You can modify the install directory by placing a file named `settings.sh` in the base directory with a line like:

    export INSTALLDIR=$HOME/llvm

If you want the target set to be different than `X86`, you can include a line like:

    export TARGETS="ALL"

As of right now, that's all the configuration possible (or really required).

Using the Compiler
------------------
This is hopefully a little bit unnecessary, but basically you'll have `bin/clang` and `bin/clang++` files in the install directory (C and C++ compiler respectively). You can use these in place of GCC, just tell your configure script/CMake instance/makefile/environment variable about it.  You can add that directory to your `PATH` if desired. For IWYU instructions see their web site.

Tested On
---------

- Ubuntu 10.04 stock GCC
- Ubuntu 12.04 stock GCC
- RHEL 6 stock GCC
