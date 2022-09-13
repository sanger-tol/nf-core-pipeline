//
// Extract the masked regions from a Fasta file as BED,
// and prepare indexes for it
//

include { REPEATS_BED                      } from '../../modules/local/repeats_bed'
include { TABIX_BGZIP                      } from '../../modules/nf-core/modules/tabix/bgzip/main'
include { TABIX_TABIX as TABIX_TABIX_CSI   } from '../../modules/nf-core/modules/tabix/tabix/main'
include { TABIX_TABIX as TABIX_TABIX_TBI   } from '../../modules/nf-core/modules/tabix/tabix/main'


workflow PREPARE_REPEATS {

    take:
    fasta  // file: /path/to/genome.fa


    main:
    ch_versions = Channel.empty()

    // BED file
    ch_bed              = REPEATS_BED ( fasta ).bed
    ch_versions         = ch_versions.mix(REPEATS_BED.out.versions)

    // Compress the BED file
    ch_compressed_bed   = TABIX_BGZIP ( ch_bed ).output
    ch_versions         = ch_versions.mix(TABIX_BGZIP.out.versions)

    // Index the BED file in two formats for maximum compatibility
    ch_indexed_bed_csi  = TABIX_TABIX_CSI ( ch_compressed_bed ).csi
    ch_versions         = ch_versions.mix(TABIX_TABIX_CSI.out.versions)
    ch_indexed_bed_tbi  = TABIX_TABIX_TBI ( ch_compressed_bed ).tbi
    ch_versions         = ch_versions.mix(TABIX_TABIX_TBI.out.versions)


    emit:
    bed_gz   = ch_compressed_bed            // path: genome.bed.gz
    bed_csi  = ch_indexed_bed_csi           // path: genome.bed.gz.csi
    bed_tbi  = ch_indexed_bed_tbi           // path: genome.bed.gz.tbi
    versions = ch_versions.ifEmpty(null)    // channel: [ versions.yml ]
}
