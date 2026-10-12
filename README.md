# Extracting Rocq definitions into non-allocating OCaml code

This repo is an experiment with controlling the allocations behavior of OCaml code obtained with Rocq extraction. It relies on [zero_alloc](https://oxcaml.org/documentation/miscellaneous-extensions/zero_alloc_check/) feature of OxCaml compiler that statically ensures the absense of heap allocations. 

At the moment, the repo contains the source Rocq file, and manually modified result of that source's extraction which compiles when the optimizations are enabled. 

To reproduce it in Docker, execute the following. Note that there are two opam switches: some Rocq dependencies conflict with OxCaml installation.

```
  docker build -t extraction-alloc .
  docker run -it extraction-alloc
  # inside the container, in /home/opam/extraction-alloc:
  opam exec --switch=rocq   -- coqc TwoPtr.v # produces two_ptr.ml  
  opam exec --switch=oxcaml -- ocamlopt -O2 two_ptr_manual.ml # compiles manually adjusted OCaml code
```

Adding `@zero_alloc` to  `floyd_array` in generated `two_ptr.ml` and running `opam exec --switch=oxcaml -- ocamlopt -O2 two_ptr.ml` will fail.

To see the exact changes introduced manually, run `git diff --no-index two_ptr.ml two_ptr_manual.ml` in the container. 