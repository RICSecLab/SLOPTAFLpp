# SLOPT-AFL++

This repository contains the implementations of SLOPT-AFL++ and the three existing methods Karamcheti-AFL++, CMFuzz-AFL++, and HavocMAB-AFL++, all of which are introduced in our paper "SLOPT: Bandit Optimization Framework for Mutation-Based Fuzzing".

<strong>SLOPT</strong> enhances AFL++'s mutation scheme by introducing bandit-friendly mutation scheme and mutation-scheme-friendly bandit algorithms to AFL++. 
Our experiments showed SLOPT can achieve higher code coverage than AFL++ in ten real-world Fuzz thanks to its PUT-agnostic optimization.
Please see our paper for further detail.

To compare our fuzzer with the previous methods, we also implemented three fuzzers that applies online opitimizations to their mutation: Karamcheti-AFL++ [1], CMFuzz-AFL++ [2] and HavocMAB-AFL++ [3]. 

# Branches

SLOPT-AFL++ is implemented in the `main` branch.
The existing methods are implemented in the following branches:

- `karamcheti`
- `cmfuzz`
- `havoc_mab`

All the implementations are based on AFL++, and therefore the following description can be applied to all these branches; you can build and execute all the fuzzers with the specified commands below.

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

Note that for some cases, afl-fuzz will complain about your environment. 
In such case, basically, please follow the instruction shown as an error message.
For example, if your `core_pattern` setting is not suitable for fuzzing, typically, afl-fuzz shows the following message:

```
[-] Hmm, your system is configured to send core dump notifications to an
    external utility. This will cause issues: there will be an extended delay
    between stumbling upon a crash and having this information relayed to the
    fuzzer via the standard waitpid() API.
    If you're just testing, set 'AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1'.

    To avoid having crashes misinterpreted as timeouts, please log in as root
    and temporarily modify /proc/sys/kernel/core_pattern, like so:

    echo core >/proc/sys/kernel/core_pattern

[-] PROGRAM ABORT : Pipe at the beginning of 'core_pattern'
         Location : check_crash_handling(), src/afl-fuzz-init.c:2219
```
In this case, you have to update your <strong>host machine's</strong> `core_pattern` by `echo core >/proc/sys/kernel/core_pattern`.

Another example is 

```
Whoops, your system uses on-demand CPU frequency scaling, adjusted
between 1562 and 3222 MHz. Unfortunately, the scaling algorithm in the
kernel is imperfect and can miss the short-lived processes spawned by
afl-fuzz. To keep things moving, run these commands as root:

cd /sys/devices/system/cpu
echo performance | tee cpu*/cpufreq/scaling_governor

You can later go back to the original state by replacing 'performance' with
'ondemand'. If you don't want to change the settings, set AFL_SKIP_CPUFREQ
to make afl-fuzz skip this check - but expect some performance drop.
```

In this case, you can skip this message just by enabling `AFL_SKIP_CPUFREQ`, but we recommend updating `scaling_governor`.


# How to take the benchmarks taken in our paper

In our paper, we used as benchmarks FuzzBench and Magma, both of which are very standardized and don't require much of manual effort.
Moreover, because every fuzzer is implemented as a small patch to AFL++, these fuzzers are much easier to run than a general fuzzer.
You can run these fuzzers basically just by copying the configuration files for AFL++ and replacing the AFL++ directory with the directory of each fuzzer.

To run these benchmarks, please follow the instructions of FuzzBench and Magma:
  - https://google.github.io/fuzzbench/getting-started/adding-a-new-fuzzer/
  - https://hexhive.epfl.ch/magma/docs/getting-started.html

For Magma, we also made it possible to take the benchmark with one command in https://github.com/RICSecLab/SLOPT_magma.

For FuzzBench, we recommend cloning its latest repository and putting these fuzzers by yourself because FuzzBench sometimes looks buggy and hard to run on some envrironments.
However, we instead put the actual PUTs, seeds and dictionaries used for our evaluation in https://github.com/RICSecLab/SLOPTAFLpp/tree/main/PUTs and `/FuzzbenchPUTs` of the above docker images.

To fuzz each PUT, move to the corresponding subdirectory and run one of the following commands:

- freetype2-2017:    `afl-fuzz -i ./seeds -o ./outdir -x ./afl++.dict -- ./ftfuzzer @@`
- lcms-2017-03-21:   `afl-fuzz -i ./seeds -o ./outdir -x ./afl++.dict -x ./cms_transform_fuzzer.dict -- ./cms_transform_fuzzer @@`
- vorbis-2017-12-11: `afl-fuzz -i ./seeds -o ./outdir -x ./afl++.dict -- ./decode_fuzzer @@`
- libpcap\_fuzz\_both: `afl-fuzz -i ./seeds -o ./outdir -x ./afl++.dict -- ./fuzz_both @@`
- openssl\_x509:      `afl-fuzz -i ./seeds -o ./outdir -x ./afl++.dict -x ./x509.dict -- ./x509 @@`
- sqlite3\_ossfuzz:   `afl-fuzz -i ./seeds -o ./outdir -x ./afl++.dict -x ./ossfuzz.dict -- ./ossfuzz @@`
- libxml2-v2.9.2:    `afl-fuzz -i ./seeds -o ./outdir -x ./afl++.dict -x ./xml.dict -- ./xml @@`
- re2-2014-12-09:    `afl-fuzz -i ./seeds -o ./outdir -x ./afl++.dict -x ./fuzz-target.dict -- ./fuzzer @@`
- proj4-2017-08-14:  `afl-fuzz -i ./seeds -o ./outdir -x ./afl++.dict -x ./standard_fuzzer.dict -- ./standard_fuzzer @@`
- libpng-1.2.56:     `afl-fuzz -i ./seeds -o ./outdir -x ./afl++.dict -x ./libpng_read_fuzzer.dict -- ./libpng_read_fuzzer @@`


The results of the FuzzBench and Magma benchmark in our paper can be downloaded from [GitHub Releases](https://github.com/RICSecLab/SLOPTAFLpp/releases).

To fully reproduce our results, a considerable amount of computing resources is required. For FuzzBench, we used 1 [day] x 1 [CPU] x 6 (fuzzers) x 10 (PUTs) x 30 (instances) = 1800 [CPU x day]. For Magma, we used 1 [d] x 1 [CPU] x 6 (fuzzers) x 21 (PUTs) x 10 (instances) = 1260 [CPU x day]. Note that, moreover, we took benchmarks with AMD EPYC 7742 2.25GHz CPU, which may run somewhat faster than ordinary CPUs used in clouds although we ran 110 fuzzer instances in parallel. To check whether it is faster, please compare the `execs_per_sec` column of `plot_data` in `slopt_fuzzbench_and_bandit_plot_data.tar.gz`.

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

# Reference

- [1] Siddharth Karamcheti, Gideon Mann, and David S. Rosenberg. 2018. Adaptive Grey-Box Fuzz-Testing with Thompson Sampling. In Proceedings of the 11th ACM Workshop on Artificial Intelligence and Security. ACM, 37–47. https://doi.org/10.1145/3270101.3270108
- [2] Xiajing Wang, Changzhen Hu, Rui Ma, Donghai Tian, and Jinyuan He. 2021. CMFuzz: context-aware adaptive mutation for fuzzers. Empirical Software Engineering 26, 1 (2021), 10. https://doi.org/10.1007/s10664-020-09927-3
- [3] Mingyuan Wu, Ling Jiang, Jiahong Xiang, Yanwei Huang, Heming Cui, Lingming Zhang, and Yuqun Zhang. 2022. One Fuzzing Strategy to Rule Them All. In Proceedings of the 44th IEEE/ACM International Conference on Software Engineering. IEEE, 1634–1645. https://doi.org/10.1145/3510003.3510174
