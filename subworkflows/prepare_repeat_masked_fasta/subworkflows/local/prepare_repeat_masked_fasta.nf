//
// Extract the masked regions from a Fasta file as BED,
// and prepare indexes for both
//

include { MASKING_TO_BED          } from '../../modules/local/masking_to_bed'
include { CUSTOM_GETCHROMSIZES    } from '../../modules/nf-core/modules/custom/getchromsizes/main'
include { SAMTOOLS_DICT           } from '../../modules/nf-core/modules/samtools/dict/main'
include { TABIX_BGZIP as TABIX_BGZIP_BED   } from '../../modules/nf-core/modules/tabix/bgzip/main'
include { TABIX_BGZIP as TABIX_BGZIP_FASTA } from '../../modules/nf-core/modules/tabix/bgzip/main'
include { TABIX_TABIX as TABIX_TABIX_CSI   } from '../../modules/nf-core/modules/tabix/tabix/main'
include { TABIX_TABIX as TABIX_TABIX_TBI   } from '../../modules/nf-core/modules/tabix/tabix/main'


workflow PREPARE_REPEAT_MASKED_FASTA {

    take:
    fasta  // file: /path/to/genome.fa


    main:
    ch_versions = Channel.empty()

    // BED file
    ch_masking_bed      = MASKING_TO_BED ( fasta ).bed
    ch_versions         = ch_versions.mix(MASKING_TO_BED.out.versions)

    // Compress the BED file
    ch_compressed_bed   = TABIX_BGZIP_BED ( ch_masking_bed ).output
    ch_versions         = ch_versions.mix(TABIX_BGZIP_BED.out.versions)

    // Index the BED file in two formats for maximum compatibility
    ch_indexed_bed_csi  = TABIX_TABIX_CSI ( ch_compressed_bed ).csi
    ch_versions         = ch_versions.mix(TABIX_TABIX_CSI.out.versions)
    ch_indexed_bed_tbi  = TABIX_TABIX_TBI ( ch_compressed_bed ).tbi
    ch_versions         = ch_versions.mix(TABIX_TABIX_TBI.out.versions)

    // Compress the Fasta file
    ch_compressed_fasta = TABIX_BGZIP_FASTA (fasta).output
    ch_versions         = ch_versions.mix(TABIX_BGZIP_FASTA.out.versions)

    // Generate Samtools index and chromosome sizes file
    ch_samtools_faidx   = CUSTOM_GETCHROMSIZES (ch_compressed_fasta).fai
    ch_versions         = ch_versions.mix(CUSTOM_GETCHROMSIZES.out.versions)

    // Generate Samtools dictionary
    ch_samtools_dict    = SAMTOOLS_DICT (fasta).dict
    ch_versions         = ch_versions.mix(SAMTOOLS_DICT.out.versions)


    emit:
    bed_gz   = ch_compressed_bed         // path: genome.bed.gz
    bed_csi  = ch_indexed_bed_csi        // path: genome.bed.gz.csi
    bed_tbi  = ch_indexed_bed_tbi        // path: genome.bed.gz.tbi
    fasta_gz = ch_compressed_fasta       // path: genome.fa.gz
    faidx    = ch_samtools_faidx         // path: genome.fa.gz.fai
    dict     = ch_samtools_dict          // path: genome.fa.dict
    gzi      = CUSTOM_GETCHROMSIZES.out.gzi     // path: genome.fa.gz.gzi
    sizes    = CUSTOM_GETCHROMSIZES.out.sizes   // path: genome.fa.gz.sizes
    versions = ch_versions.ifEmpty(null) // channel: [ versions.yml ]
}
