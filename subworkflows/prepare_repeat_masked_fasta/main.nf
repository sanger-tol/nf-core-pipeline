#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Check mandatory parameters
if (!params.fasta) { exit 1, '--fasta not specified.' }

// Imports
include { PREPARE_REPEAT_MASKED_FASTA } from './subworkflows/local/prepare_repeat_masked_fasta'

workflow {
    file_fasta = file(params.fasta, checkIfExists: true)
    ch_input = Channel.of(
        [[id: file_fasta.baseName], file_fasta]
    )
    PREPARE_REPEAT_MASKED_FASTA ( ch_input )
}
