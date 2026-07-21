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

assert_config_line "process.'withName:STAR_ALIGN'.cpus = 12"
assert_config_line "process.'withName:STAR_ALIGN'.memory = { 52.GB * task.attempt }"
assert_config_line "process.'withName:PICARD_MARKDUPLICATES'.cpus = 2"
assert_config_line "process.'withName:PICARD_MARKDUPLICATES'.memory = { 36.GB * task.attempt }"
assert_config_line "process.'withName:PICARD_MARKDUPLICATES'.publishDir = [enabled:false]"
assert_config_line "process.'withName:GATK4_SPLITNCIGARREADS'.cpus = 1"
assert_config_line "process.'withName:GATK4_SPLITNCIGARREADS'.memory = { 6.GB * task.attempt }"
assert_config_line "process.'withName:GATK4_HAPLOTYPECALLER'.cpus = 2"
assert_config_line "process.'withName:GATK4_HAPLOTYPECALLER'.memory = { 6.GB * task.attempt }"
assert_config_line "process.'withName:ENSEMBLVEP_VEP'.cpus = 3"
assert_config_line "process.'withName:ENSEMBLVEP_VEP'.memory = { 6.GB * task.attempt }"
assert_config_line "process.'withName:.*:FASTQ_ALIGN_STAR:BAM_SORT_STATS_SAMTOOLS_GENOME:SAMTOOLS_SORT'.cpus = 4"
assert_config_line "process.'withName:.*:FASTQ_ALIGN_STAR:BAM_SORT_STATS_SAMTOOLS_GENOME:SAMTOOLS_SORT'.memory = { 8.GB * task.attempt }"
assert_config_line "process.'withName:FASTQC'.cpus = 2"
assert_config_line "process.'withName:FASTQC'.memory = { 6.GB * task.attempt }"
assert_config_line "process.'withName:.*:SPLITNCIGAR:SAMTOOLS_MERGE'.cpus = 2"
assert_config_line "process.'withName:.*:SPLITNCIGAR:SAMTOOLS_MERGE'.memory = { 4.GB * task.attempt }"
