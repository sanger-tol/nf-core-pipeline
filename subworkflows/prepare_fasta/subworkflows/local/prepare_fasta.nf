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

    // Read the .fai file, extract sequence statistics, and make an extended meta map
    sequence_map        = ch_samtools_faidx.map {
        meta, fai -> [meta, meta + get_sequence_map(fai)]
    }
    // Update all channels to use the extended meta map
    fasta_gz            = ch_compressed_fasta.join(sequence_map).map { [it[2], it[1]]}
    faidx               = ch_samtools_faidx.join(sequence_map).map { [it[2], it[1]]}
    gzi                 = CUSTOM_GETCHROMSIZES.out.gzi.join(sequence_map).map { [it[2], it[1]]}
    sizes               = CUSTOM_GETCHROMSIZES.out.sizes.join(sequence_map).map { [it[2], it[1]]}
    expanded_fasta      = fasta.join(sequence_map).map { [it[2], it[1]]}

    // Generate Samtools dictionary
    ch_samtools_dict    = SAMTOOLS_DICT (expanded_fasta).dict
    ch_versions         = ch_versions.mix(SAMTOOLS_DICT.out.versions)


    emit:
    fasta_gz = fasta_gz                  // path: genome.fa.gz
    faidx    = faidx                     // path: genome.fa.gz.fai
    dict     = ch_samtools_dict          // path: genome.fa.dict
    gzi      = gzi                       // path: genome.fa.gz.gzi
    sizes    = sizes                     // path: genome.fa.gz.sizes
    versions = ch_versions.ifEmpty(null) // channel: [ versions.yml ]
}

// Read the .fai file to extract the number of sequences, the maximum and total sequence length
// Inspired from https://github.com/nf-core/rnaseq/blob/3.10.1/lib/WorkflowRnaseq.groovy
def get_sequence_map(fai_file) {
    def n_sequences = 0
    def max_length = 0
    def total_length = 0
    fai_file.eachLine { line ->
        def lspl   = line.split('\t')
        def chrom  = lspl[0]
        def length = lspl[1].toInteger()
        n_sequences ++
        total_length += length
        if (length > max_length) {
            max_length = length
        }
    }

    def sequence_map = [:]
    sequence_map.n_sequences = n_sequences
    sequence_map.total_length = total_length
    if (n_sequences) {
        sequence_map.max_length = max_length
    }
    return sequence_map
}
