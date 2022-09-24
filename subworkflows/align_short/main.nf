#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BWAMEM2_INDEX } from './modules/nf-core/modules/bwamem2/index/main'
include { ALIGN_SHORT   } from './subworkflows/local/align_short'

fasta = "${projectDir}/assets/GCA_927399515.1.subset.fasta"
reads = "${projectDir}/assets/40063_3#5.subset.cram"

workflow {

    ch_fasta  = Channel.fromPath(fasta)
    ch_genome = ch_fasta.map { file -> [ [ id: file.baseName.replaceFirst(/.unmasked/, "").replaceFirst(/.subset/, "") ], file ] }
    ch_reads  = Channel.fromPath(reads).map { file -> [ [ id: "mMelMel3_T1", datatype: "hic", read_group: "\'@RG\\tID:" + file.simpleName + "\\tPL:ILLUMINA" + "\\tSM:mMelMel3" + "\'" ], file ] }

    // Add process either to prepare genome subworkflow or equivalent
    ch_index = BWAMEM2_INDEX ( ch_genome ).index

    // Align short read data - Illumina or HiC, markduplicate and calculate relevant statistics 
    ALIGN_SHORT ( ch_fasta, ch_index, ch_reads )
}
