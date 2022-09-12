//
// Prepare all the indexes for a Fasta file
//

include { CUSTOM_GETCHROMSIZES    } from '../../modules/nf-core/modules/custom/getchromsizes/main'
include { SAMTOOLS_DICT           } from '../../modules/nf-core/modules/samtools/dict/main'
include { TABIX_BGZIP             } from '../../modules/nf-core/modules/tabix/bgzip/main'


workflow PREPARE_FASTA {

    take:
    fasta  // file: /path/to/genome.fa


    main:
    ch_versions = Channel.empty()

    // Compress the Fasta file
    ch_compressed_fasta = TABIX_BGZIP (fasta).output
    ch_versions         = ch_versions.mix(TABIX_BGZIP.out.versions)

    // Generate Samtools index and chromosome sizes file
    ch_samtools_faidx   = CUSTOM_GETCHROMSIZES (ch_compressed_fasta).fai
    ch_versions         = ch_versions.mix(CUSTOM_GETCHROMSIZES.out.versions)

    // Generate Samtools dictionary
    ch_samtools_dict    = SAMTOOLS_DICT (fasta).dict
    ch_versions         = ch_versions.mix(SAMTOOLS_DICT.out.versions)


    emit:
    fasta_gz = ch_compressed_fasta       // path: genome.fa.gz
    faidx    = ch_samtools_faidx         // path: genome.fa.gz.fai
    dict     = ch_samtools_dict          // path: genome.fa.dict
    gzi      = CUSTOM_GETCHROMSIZES.out.gzi     // path: genome.fa.gz.gzi
    sizes    = CUSTOM_GETCHROMSIZES.out.sizes   // path: genome.fa.gz.sizes
    versions = ch_versions.ifEmpty(null) // channel: [ versions.yml ]
}
