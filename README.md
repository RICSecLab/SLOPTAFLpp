# SLOPT-AFL++

This repository contains the implementation of SLOPT-AFL++ and 3 existing methods.
Some of them requires GSL (GNU Scientific Library) for build. In Debian/Ubuntu, it can be installed as the package `libgsl-dev`.

The existing methods are implemented in the following branches:

- cmfuzz
- havoc\_mab
- karamcheti

For SLOPT-AFL++, You can switch bandit algorithms in `include/afl-fuzz.h`.
The unaltered AFL++ and MOpt-AFL++ can be used by checking out tag `baseline`.

The results of benchmarks are left in `./benchs` of the `benchmark` branch.
