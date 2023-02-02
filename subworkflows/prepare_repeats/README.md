# Extracting the masked regions from a Fasta file as BED, and preparing it for efficient acces

This sub-workflow extracts the repeat coordinates from an uncompressed
Fasta file, and compresses the reslting BED file with bgzip.
It then indexes it with tabix (both as CSI and TBI).

In order to optimise resource usage, and appropriately make the CSI
and TBI indices, the sub-workflow assumes that the `meta` map has these
keys:

- `n_sequences`: the number of sequences in the Fasta file
- `max_length`: the maximum length of a sequence in the Fasta file

These two keys are automatically populated by the [`prepare_fasta`](../prepare_fasta/README.md)
sub-workflow.

## Scripts

- `bin/repeats_bed.py`: Takes a Fasta file as input, and print the coordinates of the masked regions as BED

## Modules

### Local

- `repeats_bed`: wrapper around the script `bin/repeats_bed.py`.

### nf-core

- `tabix/bgzip`: compress to bgzip;
- `tabix/tabix`: index the BED file with tabix (as CSI and TBI).

## Subworkflows

- `prepare_repeats`: Chain the modules to extract the BED file and generate its indices.

## Execution `main.nf`

Simply call the `prepare_repeats` sub-workflow on a Fasta file.

## Integration

Currently to integrate this sub-workflow into an nf-core pipeline:

- Install the two nf-core modules
- Copy the script, the local module, and the sub-workflow file in
- Add in `conf/base.config` the highlighted section from `nextflow.config`,
  modifying the `withName` clause to macth your pipeline's namespace
- Add in `conf/modules.config` the highlighted section from `nextflow.config`,
  modifying the `withName` clause to macth your pipeline's namespace
- Connect `PREPARE_REPEATS` to a channel of Fasta files
