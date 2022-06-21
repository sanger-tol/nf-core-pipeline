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
- Disable input parameter validation in `workflows/pipeline.nf`
```
WorkflowVariantcalling.initialise(params, log)
```
- Disable checks to confirm input path parameters exist in `workflows/pipeline.nf`
```
def checkPathParamList = [ params.input, params.multiqc_config, params.fasta ]
for (param in checkPathParamList) { if (param) { file(param, checkIfExists: true) } }
```
- Modify required parameters in `nextflow_schema.json`
```
            "required": ["outdir"],
```
- Disable input check in `lib/WorkflowMain.groovy`
```
        if (!params.input) {
            log.error "Please provide an input samplesheet to the pipeline e.g. '--input samplesheet.csv'"
            System.exit(1)
        }
```
