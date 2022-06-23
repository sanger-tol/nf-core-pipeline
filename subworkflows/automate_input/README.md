# Automating input using ToL organism and project IDs

## Scripts

- `bin/tol_input.sh`: Takes ToL ID and project name as input. Creates the samplesheet with aligned CRAM files, links to the unmasked genome file and its `fai` index.
- `bin/samplesheet_check.py`: Takes the samplesheet created by `input_tol` or provided by user. Validates and updates the samplesheet csv.

## Modules

- `input_tol`: Implements `bin/tol_input.sh`
- `samplesheet_check`: Implements `bin/samplesheet_check.py`
- `samtools_view`: Takes the aligned `cram` file data channels, along with unmasked genome file and its `fai` index. Coverts `cram` file to `bam` for downstream processing.

## Subworkflows

- `input_check`: Combines the modules `input_tol` and `samplesheet_check`

## Execution `main.nf`

Passes inputs, either genome fasta and samplesheet csv or Tree of Life organism and project IDs, as a tuple into the subworkflow `input_check`. Next, converts `input_check` genome queue channel to value channel, and passes it to module `samtools_view`.

## Integration

Currently to integrate this subworkflow into an nf-core pipeline,
- Remove path check for input parameter in `workflows/pipeline.nf`
```
def checkPathParamList = [ params.multiqc_config, params.fasta ]
```
- Modify `input` details in `nextflow_schema.json`
```
                "input": {
                    "type": "string",
                    "description": "Path to comma-separated file containing information about the samples in the experiment.",
                    "format": "file-path",
                    "help_text": "Provide a Tree of Life organism ID. Otherwise, you will need to create a design file with information about the samples in your experiment bef
ore running the pipeline. Use this parameter to specify its location. It has to be a comma-separated file with 3 columns, and a header row. See [usage docs](https://nf-co.re/va
riantcalling/usage#samplesheet-input).",
                    "fa_icon": "fas fa-file-csv"
                },
```
- Disable fasta check in `lib/WorkflowVariantcalling.groovy`
```
        //if (!params.fasta) {
        //    log.error "Genome fasta file not specified with e.g. '--fasta genome.fa' or via a detectable config file."
        //    System.exit(1)
        //}
```
– Update log error for input check in `lib/WorkflowMain.groovy`
```
            log.error "Please provide an input samplesheet to the pipeline e.g. '--input samplesheet.csv' or organism ID '--input tolid'"
```
