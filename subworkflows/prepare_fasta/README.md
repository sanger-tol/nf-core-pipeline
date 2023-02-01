# Preparing a Fasta file for efficient access

This subworkflow compresses the Fasta file with bgzip,
then prepares the faidx, sizes, and gzi indices, as
well as the samtools dictionary.

## Scripts

_None_

## Modules

### Local

_None_

### nf-core

- `tabix/bgzip`: compress to bgzip;
- `custom/getchromsizes`: faidx, sizes, and gzi indices;
- `samtools/dict`: dictionary of sequence checksums.

## Subworkflows

- `prepare_fasta`: Chain the modules to generate all indices.

## Execution `main.nf`

Simply call the `prepare_fasta` subworkflow on a Fasta file.

## Integration

Currently to integrate this subworkflow into an nf-core pipeline:

- Install all three nf-core modules
- Copy the subworkflow file in
- Add in `conf/base.config` the highlighted section from `nextflow.config`,
  modifying the `withName` clause to macth your pipeline's namespace
- Add in `conf/modules.config` the highlighted section from `nextflow.config`,
  modifying the `withName` clause to macth your pipeline's namespace
- Connect `PREPARE_FASTA` to a channel of Fasta files
