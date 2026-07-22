#!/usr/bin/env bash
set -euo pipefail

default_config="$(nextflow config -flat)"
resolved_config="$(nextflow config -profile kiin -flat)"

assert_config_line() {
    local expected_line="$1"

    if ! grep -Fqx "$expected_line" <<<"${resolved_config}"; then
        printf 'Missing resolved config line: %s\n' "$expected_line" >&2
        exit 1
    fi
}

assert_config_contains() {
    local expected_text="$1"

    if ! grep -Fq -- "$expected_text" <<<"${resolved_config}"; then
        printf 'Missing resolved config text: %s\n' "$expected_text" >&2
        exit 1
    fi
}

assert_config_any_line() {
    local expected_line

    for expected_line in "$@"; do
        if grep -Fqx "$expected_line" <<<"${resolved_config}"; then
            return
        fi
    done

    printf 'Missing all accepted resolved config lines:\n' >&2
    printf '  %s\n' "$@" >&2
    exit 1
}

assert_default_config_line() {
    local expected_line="$1"

    if ! grep -Fqx "$expected_line" <<<"${default_config}"; then
        printf 'Missing default config line: %s\n' "$expected_line" >&2
        exit 1
    fi
}

assert_default_config_absent() {
    local unexpected_line="$1"

    if grep -Fqx "$unexpected_line" <<<"${default_config}"; then
        printf 'Unexpected default config line: %s\n' "$unexpected_line" >&2
        exit 1
    fi
}

assert_default_config_line "process.'withLabel:process_high'.memory = { 72.GB * task.attempt }"
assert_default_config_absent "process.'withName:PICARD_MARKDUPLICATES'.publishDir = [enabled:false]"

assert_config_line "params.gatk_interval_scatter_count = 40"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:FASTQ_ALIGN_STAR:STAR_ALIGN'.cpus = 12"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:FASTQ_ALIGN_STAR:STAR_ALIGN'.memory = { 52.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:BAM_MARKDUPLICATES_PICARD:PICARD_MARKDUPLICATES'.cpus = 2"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:BAM_MARKDUPLICATES_PICARD:PICARD_MARKDUPLICATES'.memory = { 36.GB * task.attempt }"
assert_config_any_line \
    "process.'withName:NFCORE_RNAVAR:RNAVAR:BAM_MARKDUPLICATES_PICARD:PICARD_MARKDUPLICATES'.publishDir = [enabled:false]" \
    "process.'withName:NFCORE_RNAVAR:RNAVAR:BAM_MARKDUPLICATES_PICARD:PICARD_MARKDUPLICATES'.publishDir.enabled = false"
assert_config_line "process.'withName:NFCORE_RNAVAR:PREPARE_GENOME:GTF2BED'.cpus = 1"
assert_config_line "process.'withName:NFCORE_RNAVAR:PREPARE_GENOME:GTF2BED'.memory = { 4.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:GATK4_BEDTOINTERVALLIST'.cpus = 2"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:GATK4_BEDTOINTERVALLIST'.memory = { 2.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:GATK4_INTERVALLISTTOOLS'.cpus = 2"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:GATK4_INTERVALLISTTOOLS'.memory = { 4.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:SPLITNCIGAR:GATK4_SPLITNCIGARREADS'.cpus = 1"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:SPLITNCIGAR:GATK4_SPLITNCIGARREADS'.memory = { 6.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:GATK4_HAPLOTYPECALLER'.cpus = 2"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:GATK4_HAPLOTYPECALLER'.memory = { 4.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:VCF_ANNOTATE_ALL:VCF_ANNOTATE_ENSEMBLVEP:ENSEMBLVEP_VEP'.cpus = 3"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:VCF_ANNOTATE_ALL:VCF_ANNOTATE_ENSEMBLVEP:ENSEMBLVEP_VEP'.memory = { 4.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:FASTQ_ALIGN_STAR:BAM_SORT_STATS_SAMTOOLS_GENOME:SAMTOOLS_SORT'.cpus = 4"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:FASTQ_ALIGN_STAR:BAM_SORT_STATS_SAMTOOLS_GENOME:SAMTOOLS_SORT'.memory = { 8.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:FASTQC'.cpus = 2"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:FASTQC'.memory = { 6.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:SPLITNCIGAR:SAMTOOLS_MERGE'.cpus = 2"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:SPLITNCIGAR:SAMTOOLS_MERGE'.memory = { 4.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:GATK4_MERGEVCFS'.cpus = 2"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:GATK4_MERGEVCFS'.memory = { 4.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:GATK4_VARIANTFILTRATION'.cpus = 1"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:GATK4_VARIANTFILTRATION'.memory = { 2.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:.*:SAMTOOLS_INDEX'.cpus = 2"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:.*:SAMTOOLS_INDEX'.memory = { 2.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:.*:SAMTOOLS_STATS'.cpus = 1"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:.*:SAMTOOLS_STATS'.memory = { 2.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:.*:SAMTOOLS_FLAGSTAT'.cpus = 1"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:.*:SAMTOOLS_FLAGSTAT'.memory = { 2.GB * task.attempt }"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:.*:SAMTOOLS_IDXSTATS'.cpus = 1"
assert_config_line "process.'withName:NFCORE_RNAVAR:RNAVAR:.*:SAMTOOLS_IDXSTATS'.memory = { 2.GB * task.attempt }"
assert_config_line "process.'withName:^MULTIQC$'.cpus = 1"
assert_config_line "process.'withName:^MULTIQC$'.memory = { 3.GB * task.attempt }"

assert_config_contains "process.'withName:STAR_ALIGN'.ext.args = {"
assert_config_contains "process.'withName:PICARD_MARKDUPLICATES'.ext.args = {"
assert_config_contains "process.'withName:GTF2BED'.publishDir"
assert_config_contains "process.'withName:GATK4_BEDTOINTERVALLIST'.ext.args ="
assert_config_contains "--DROP_MISSING_CONTIGS TRUE"
assert_config_contains "process.'withName:GATK4_INTERVALLISTTOOLS'.ext.args = {"
assert_config_contains "--SUBDIVISION_MODE BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW"
assert_config_contains "--SCATTER_COUNT \${params.gatk_interval_scatter_count}"
assert_config_contains "process.'withName:GATK4_SPLITNCIGARREADS'.ext.args ="
assert_config_contains "--create-output-bam-index false"
assert_config_contains "process.'withName:GATK4_HAPLOTYPECALLER'.ext.args = {"
assert_config_contains "--dont-use-soft-clipped-bases"
assert_config_contains "process.'withName:ENSEMBLVEP_VEP'.ext.args = {"
assert_config_contains "process.'withName:.*:FASTQ_ALIGN_STAR:BAM_SORT_STATS_SAMTOOLS_GENOME:SAMTOOLS_SORT'.ext.prefix ="
assert_config_contains "\${meta.id}.aligned"
assert_config_contains "process.'withName:FASTQC'.ext.args ="
assert_config_contains "--quiet"
assert_config_contains "process.'withName:GATK4_MERGEVCFS'.ext.prefix ="
assert_config_contains "\${meta.id}.haplotypecaller"
assert_config_contains "process.'withName:GATK4_VARIANTFILTRATION'.ext.args = {"
assert_config_contains "process.'withName:SAMTOOLS_INDEX'.ext.args ="
assert_config_contains "params.bam_csi_index"
assert_config_contains "process.'withName:MULTIQC'.ext.args ="
assert_config_contains "params.multiqc_title"
