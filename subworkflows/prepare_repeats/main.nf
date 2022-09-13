#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Check mandatory parameters
if (!params.fasta) { exit 1, '--fasta not specified.' }

// Imports
include { PREPARE_REPEATS } from './subworkflows/local/prepare_repeats'

workflow {
    file_fasta = file(params.fasta, checkIfExists: true)
    ch_input = Channel.of(
        [[id: file_fasta.baseName], file_fasta]
    )
    PREPARE_REPEATS ( ch_input )
}
