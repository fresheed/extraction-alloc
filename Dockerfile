# Two opam switches:
#   rocq   - Coq/Rocq 8.20.0, checks TwoPtr.v and extracts two_ptr.ml
#   oxcaml - OxCaml compiler, compiles two_ptr_manual.ml with -O2
FROM ocaml/opam:ubuntu-22.04-ocaml-5.1

# System packages needed to build the OxCaml compiler
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends autoconf rsync libgmp-dev libffi-dev pkg-config \
 && rm -rf /var/lib/apt/lists/*
USER opam

RUN opam update

# --- Switch 1: Rocq -------------------------------------------------------
RUN opam switch create rocq ocaml-base-compiler.5.1.0 \
 && opam install --switch=rocq -y coq.8.20.0

# --- Switch 2: OxCaml -----------------------------------------------------
RUN opam switch create oxcaml \
      --repos ox=git+https://github.com/oxcaml/opam-repository.git,default \
      ocaml-variants.5.2.0+ox

RUN opam clean -a -c -s --logs

RUN mkdir -p /home/opam/extraction-alloc
WORKDIR /home/opam/extraction-alloc
COPY --chown=opam:opam TwoPtr.v two_ptr_manual.ml ./

# Check the proofs and extract two_ptr.ml / two_ptr.mli
RUN opam exec --switch=rocq -- coqc TwoPtr.v \
 && test -f two_ptr.ml

# Compile the hand-modified version with OxCaml
RUN opam exec --switch=oxcaml -- ocamlopt -O2 two_ptr_manual.ml

CMD ["bash"]
