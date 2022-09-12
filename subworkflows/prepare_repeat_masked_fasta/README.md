# Extracting the masked regions from a Fasta file as BED, and preparing the files for efficient acces

## Scripts

- `bin/masking_to_bed.py`: Takes a Fasta file as input, and print the coordinates of the masked regions as BED

## Modules

### Local

- `masking_to_bed`: wrapper around the script `bin/masking_to_bed.py`.

### nf-core

- `tabix/bgzip`: compress to bgzip;
- `tabix/tabix`: index the BED file with tabix (as CSI and TBI);
- `custom/getchromsizes`: faidx, sizes, and gzi indices;
- `samtools/dict`: dictionary of sequence checksums.

## Subworkflows

- `prepare_repeat_masked_fasta`: Chain the modules to extract the BED file and generate all indices.

## Execution `main.nf`

Simply call the `prepare_repeat_masked_fasta` subworkflow on a Fasta file.

## Integration

Currently to integrate this subworkflow into an nf-core pipeline:

- Install all four nf-core modules
- Copy the script, the local module, and the subworkflow file in
- Add in `conf/modules.config` the highlighted section from `nextflow.config`
- Connect `PREPARE_REPEAT_MASKED_FASTA` to a channel of Fasta files
