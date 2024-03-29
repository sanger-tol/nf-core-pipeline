# Aligning short read data (HiC or Illumina) to genome, marking duplicates and calculating statistics

## Scripts

_None_

## Modules

### Local

_None_

### nf-core

- `bwamem2/mem`: performs fastq alignment to a fasta reference using BWA;
- `samtools/collate`: shuffles and groups reads together by their names;
- `samtools/fastq`: converts a SAM/BAM/CRAM file to FASTQ;
- `samtools/fixmate`: fill in information (insert size, cigar, mapq) about paired end reads onto the corresponding other read;
- `samtools/flagstat`: counts the number of alignments in a BAM/CRAM/SAM file for each FLAG type;
- `samtools/idxstats`: reports alignment summary statistics for a BAM/CRAM/SAM file;
- `samtools/index`: index SAM/BAM/CRAM file;
- `samtools/markdup`: mark duplicate alignments in a coordinate sorted file;
- `samtools/merge`: merge BAM or CRAM file;
- `samtools/sort`: sort SAM/BAM/CRAM file;
- `samtools/stats`: produces comprehensive statistics from SAM/BAM/CRAM file;
- `samtools/view`: filter/convert SAM/BAM/CRAM file.

## Subworkflows

Although the short-read alignment functionality could easily be shipped as a single subworkflow, the example here breaks it down into multiple subworkflows. This is to maximise modularity and the reusability of its components, especially in the light of our [read-mapping pipeline](https://github.com/sanger-tol/readmapping). 

1. `align_short`: align short read (HiC and Illumina) data against the genome;
2. `markdup_stats`: sorts aligned file, and executes markduplicate and statistics subworkflows;
3. `markduplicate`: merge and markdup aligned reads;
4. `convert_stats`: convert to CRAM and calculate statistics.

## Execution `main.nf`

Call the `align_short` subworkflow using:

1. genome: `/path/to/genome.fasta`
2. index: `/path/to/bwamem2_index/`
3. reads: `[ [id, datatype, read_group], read_file ]`

## Integration

Currently to integrate this subworkflow into an nf-core pipeline (see `main.nf` for an example):

1. Install all nf-core modules
2. Copy the subworkflows
3. Add in `conf/modules.config` the highlighted section from `nextflow.config`
4. Connect `ALIGN_SHORT` to the genome fasta, genome index and read channels

For the subworkflow to work as-is, the `meta.id` of the reads MUST be written as the sample identifier followed by an underscore and a unique read identifier that does NOT contain an underscore. For instance, `mMelMel3_T1` and `mMelMel3_T2` comply, but `mMelMel3_1_a` and `mMelMel3_2_a` don't.
If that's not the case, edit the `map` before the `groupTuple` in `subworkflows/local/markdup_stats.nf` accordingly.
Although not a requirement of the subworkflow, you probably want to make sure that the sample identifier is the same as the `SM` tag in the read group.
