# Extracting the masked regions from a Fasta file as BED, and preparing the files for efficient acces

## Scripts

- `bin/masking_to_bed.py`: Takes a Fasta file as input, and print the coordinates of the masked regions as BED

## Modules

### Local

- `masking_to_bed`: wrapper around the script `bin/masking_to_bed.py`.

### nf-core

- `tabix/bgzip`: compress to bgzip;
- `tabix/tabix`: index the BED file with tabix (as CSI and TBI);

## Subworkflows

- `prepare_fasta`: Auxiliary subworkflow to compress and generate the indices for a Fasta file. See its own [description](../prepare_fasta/README.md).
- `prepare_repeat_masked_fasta`: Chain the modules to extract the BED file and generate its indices, and defer to `prepare_fasta` for the Fasta-related work.

## Execution `main.nf`

Simply call the `prepare_repeat_masked_fasta` subworkflow on a Fasta file.

## Integration

Currently to integrate this subworkflow into an nf-core pipeline:

- Install the `prepare_fasta` subworkflow as per its [integration guide](../prepare_fasta/README.md#Integration).
- Install the `tabix/tabix` nf-core module
- Copy the script, the local module, and the subworkflow file in
- Add in `conf/modules.config` the highlighted section from `nextflow.config`
- Connect `PREPARE_REPEAT_MASKED_FASTA` to a channel of Fasta files
