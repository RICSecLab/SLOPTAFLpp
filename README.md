# SLOPT-AFL++

This repository contains the implementation of SLOPT-AFL++ and the three existing methods Karamcheti-AFL++, CMFuzz-AFL++, and HavocMAB-AFL++, all of which are introduced in our paper "SLOPT: Bandit Optimization Framework for Mutation-Based Fuzzing".

SLOPT-AFL++ is implemented in the `main` branch.
The existing methods are implemented in the following branches:

- `karamcheti`
- `cmfuzz`
- `havoc_mab`

# How to build

You can pull the prebuilt docker images via docker hub:
  - https://hub.docker.com/repository/docker/ricsec1hugeh0ge/slopt-aflpp
  - https://hub.docker.com/repository/docker/ricsec1hugeh0ge/karamcheti-aflpp
  - https://hub.docker.com/repository/docker/ricsec1hugeh0ge/cmfuzz-aflpp
  - https://hub.docker.com/repository/docker/ricsec1hugeh0ge/havoc_mab-aflpp

Alternatively, you can use Dockerfile in the top directory of each branch to build these images locally.
Moreover, of course you can build these fuzzers in almost the same way as the unaltered AFL++ on the host environment because they additionally require only the GNU Scientific Library. In Debian/Ubuntu, it can be installed as the package `libgsl-dev`.

For SLOPT-AFL++, you can switch bandit algorithms in `include/afl-fuzz.h`.
The unaltered AFL++ and MOpt-AFL++ can be build by checking out the tag `baseline` in the `main` branch.

# How to use

In all the images, the built fuzzer is registered as the `afl-fuzz` command.
The basic usage of the fuzzers is the same as the unaltered AFL++.
To run the fuzzers, you need to give the paths to program, the initial seeds, and the output directory at least (e.g. `afl-fuzz -i ./seeds/ -o ./output -- ./program @@`). 
Of course, you can feed the other command line arguments the same way as AFL++.

However, note that you should never use `-L` because it enables MOpt instead of each online optimization method incorporated.

# How to take the benchmarks taken in our paper

In our paper, we used as benchmarks FuzzBench and MAGMA, both of which are very standardized and don't require much of manual effort.

To run these benchmarks, please follow the instructions of FuzzBench and MAGMA:
  - https://google.github.io/fuzzbench/getting-started/adding-a-new-fuzzer/
  - https://hexhive.epfl.ch/magma/docs/getting-started.html

The results of benchmarks are left in `./benchs` of the `benchmark` branch.

# Citation

```
@inproceedings{SLOPT-ACSAC22,
  author    = {Yuki Koike and
               Hiroyuki Katsura and
               Hiromu Yakura and
               Yuma Kurogome},
  title     = {SLOPT: Bandit Optimization Framework for Mutation-Based Fuzzing},
  booktitle = {Proceedings of the 38th Annual Computer Security Applications Conference,
               {ACSAC} 2022, Austin, TX, USA, December 5-9, 2022},
  pages     = {to appear},
  publisher = {{ACM}},
  year      = {2022},
}
```
