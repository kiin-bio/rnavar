/*
========================================================================================
    RECALIBRATE
========================================================================================
*/

include { GATK4_APPLYBQSR    } from '../../../modules/nf-core/gatk4/applybqsr'
include { SAMTOOLS_INDEX     } from '../../../modules/nf-core/samtools/index'
include { BAM_STATS_SAMTOOLS } from '../../../subworkflows/nf-core/bam_stats_samtools'

workflow RECALIBRATE {
    take:
    bam // channel: [mandatory] bam
    dict // channel: [mandatory] dict
    fai // channel: [mandatory] fai
    fasta // channel: [mandatory] meta, fasta

    main:
    GATK4_APPLYBQSR(
        bam,
        fasta.map { _meta, fasta_ -> [fasta_] },
        fai,
        dict,
    )

    SAMTOOLS_INDEX(GATK4_APPLYBQSR.out.bam)

    def bam_indices = SAMTOOLS_INDEX.out.bai
        .mix(SAMTOOLS_INDEX.out.csi)
        .mix(SAMTOOLS_INDEX.out.crai)

    def bam_recalibrated_index = GATK4_APPLYBQSR.out.bam.join(bam_indices, failOnMismatch: true, failOnDuplicate: true)

    BAM_STATS_SAMTOOLS(bam_recalibrated_index, fasta)

    emit:
    bam      = bam_recalibrated_index
    flagstat = BAM_STATS_SAMTOOLS.out.flagstat
    idxstats = BAM_STATS_SAMTOOLS.out.idxstats
    stats    = BAM_STATS_SAMTOOLS.out.stats
}
