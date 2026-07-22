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
assert_config_line "process.'withName:STAR_ALIGN'.cpus = 12"
assert_config_line "process.'withName:STAR_ALIGN'.memory = { 52.GB * task.attempt }"
assert_config_line "process.'withName:STAR_ALIGN'.maxForks = 2"
assert_config_line "process.'withName:PICARD_MARKDUPLICATES'.cpus = 2"
assert_config_line "process.'withName:PICARD_MARKDUPLICATES'.memory = { 36.GB * task.attempt }"
assert_config_any_line \
    "process.'withName:PICARD_MARKDUPLICATES'.publishDir = [enabled:false]" \
    "process.'withName:PICARD_MARKDUPLICATES'.publishDir.enabled = false"
assert_config_line "process.'withName:PICARD_MARKDUPLICATES'.maxForks = 2"
assert_config_line "process.'withName:GTF2BED'.cpus = 1"
assert_config_line "process.'withName:GTF2BED'.memory = { 4.GB * task.attempt }"
assert_config_line "process.'withName:GATK4_BEDTOINTERVALLIST'.cpus = 2"
assert_config_line "process.'withName:GATK4_BEDTOINTERVALLIST'.memory = { 2.GB * task.attempt }"
assert_config_line "process.'withName:GATK4_INTERVALLISTTOOLS'.cpus = 2"
assert_config_line "process.'withName:GATK4_INTERVALLISTTOOLS'.memory = { 4.GB * task.attempt }"
assert_config_line "process.'withName:GATK4_SPLITNCIGARREADS'.cpus = 1"
assert_config_line "process.'withName:GATK4_SPLITNCIGARREADS'.memory = { 6.GB * task.attempt }"
assert_config_line "process.'withName:GATK4_SPLITNCIGARREADS'.maxForks = 40"
assert_config_line "process.'withName:GATK4_HAPLOTYPECALLER'.cpus = 2"
assert_config_line "process.'withName:GATK4_HAPLOTYPECALLER'.memory = { 4.GB * task.attempt }"
assert_config_line "process.'withName:GATK4_HAPLOTYPECALLER'.maxForks = 40"
assert_config_line "process.'withName:ENSEMBLVEP_VEP'.cpus = 3"
assert_config_line "process.'withName:ENSEMBLVEP_VEP'.memory = { 4.GB * task.attempt }"
assert_config_line "process.'withName:ENSEMBLVEP_VEP'.maxForks = 4"
assert_config_line "process.'withName:.*:FASTQ_ALIGN_STAR:BAM_SORT_STATS_SAMTOOLS_GENOME:SAMTOOLS_SORT'.cpus = 4"
assert_config_line "process.'withName:.*:FASTQ_ALIGN_STAR:BAM_SORT_STATS_SAMTOOLS_GENOME:SAMTOOLS_SORT'.memory = { 8.GB * task.attempt }"
assert_config_line "process.'withName:.*:FASTQ_ALIGN_STAR:BAM_SORT_STATS_SAMTOOLS_GENOME:SAMTOOLS_SORT'.maxForks = 4"
assert_config_line "process.'withName:FASTQC'.cpus = 2"
assert_config_line "process.'withName:FASTQC'.memory = { 6.GB * task.attempt }"
assert_config_line "process.'withName:FASTQC'.maxForks = 8"
assert_config_line "process.'withName:.*:SPLITNCIGAR:SAMTOOLS_MERGE'.cpus = 2"
assert_config_line "process.'withName:.*:SPLITNCIGAR:SAMTOOLS_MERGE'.memory = { 4.GB * task.attempt }"
assert_config_line "process.'withName:GATK4_MERGEVCFS'.cpus = 2"
assert_config_line "process.'withName:GATK4_MERGEVCFS'.memory = { 4.GB * task.attempt }"
assert_config_line "process.'withName:GATK4_VARIANTFILTRATION'.cpus = 1"
assert_config_line "process.'withName:GATK4_VARIANTFILTRATION'.memory = { 2.GB * task.attempt }"
assert_config_line "process.'withName:SAMTOOLS_INDEX'.cpus = 2"
assert_config_line "process.'withName:SAMTOOLS_INDEX'.memory = { 2.GB * task.attempt }"
assert_config_line "process.'withName:SAMTOOLS_STATS'.cpus = 1"
assert_config_line "process.'withName:SAMTOOLS_STATS'.memory = { 2.GB * task.attempt }"
assert_config_line "process.'withName:SAMTOOLS_FLAGSTAT'.cpus = 1"
assert_config_line "process.'withName:SAMTOOLS_FLAGSTAT'.memory = { 2.GB * task.attempt }"
assert_config_line "process.'withName:SAMTOOLS_IDXSTATS'.cpus = 1"
assert_config_line "process.'withName:SAMTOOLS_IDXSTATS'.memory = { 2.GB * task.attempt }"
assert_config_line "process.'withName:MULTIQC'.cpus = 1"
assert_config_line "process.'withName:MULTIQC'.memory = { 3.GB * task.attempt }"
