# Automating input using ToL organism and project IDs

## Scripts

- `bin/tol_input.sh`: Takes ToL ID and project name as input. Creates the samplesheet with aligned CRAM files, links to the unmasked genome file and its `fai` index. Imp
- `bin/samplesheet_check.py`: Takes the samplesheet created by `input_tol`. Validates and updates the samplesheet csv.

## Modules

- `input_tol`: Implements `bin/tol_input.sh`
- `samplesheet_check`: Implements `bin/samplesheet_check.py`
- `samtools_view`: Takes the aligned `cram` file data channels, along with unmasked genome file and its `fai` index. Coverts `cram` file to `bam` for downstream processing.

## Subworkflows

- `input_check`: Combines the modules `input_tol` and `samplesheet_check`

## Execution `main.nf`

Passes inputs, either genome fasta and samplesheet csv or Tree of Life organism and project IDs, as a tuple into the subworkflow `input_check`. Next, converts `input_check` genome queue channel to value channel, and passes it to module `samtools_view`.

## Integration


