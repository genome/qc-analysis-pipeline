## Generating a threshold file

### Format

The threshold file for the workflow has a three-column tab-delimited format.  The first column is the name of the metric, the second is the threshold at which to evaluate it, and the third is the comparison that needs to be true for the metric to pass the threshold.  For example:

```MEAN_COVERAGE	30	>=```

This would indicate that the same should pass QC for the `MEAN_COVERAGE` metric when the coverage is greater than or equal to `30`. Some example files can be found in the `threshold_files/` directory in this repo.

#### Operators

The operators can be any of `=`, `<`, `<=`, `>`, and `>=`. The equality operator `=` requires an exact match. To accomoate a range of values, add two rows the file--one with each boundary condition of the range.


### Available metrics

The following metrics can be evaluated in the workflow.

| Name | Source Tool | Notes |
|------|-------------|-------|
| TOTAL_READS-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_READS-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_PF_READS-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_NOISE_READS-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_READS_ALIGNED-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_PF_READS_ALIGNED-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_ALIGNED_BASES-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_ALIGNED_READS-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_ALIGNED_BASES-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_ALIGNED_Q20_BASES-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_MEDIAN_MISMATCHES-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_MISMATCH_RATE-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_ERROR_RATE-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_INDEL_RATE-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| MEAN_READ_LENGTH-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| READS_ALIGNED_IN_PAIRS-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_READS_ALIGNED_IN_PAIRS-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_READS_IMPROPER_PAIRS-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_PF_READS_IMPROPER_PAIRS-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| BAD_CYCLES-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| STRAND_BALANCE-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_CHIMERAS-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_ADAPTER-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| SAMPLE-FIRST_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| CATEGORY-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| TOTAL_READS-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_READS-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_PF_READS-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_NOISE_READS-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_READS_ALIGNED-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_PF_READS_ALIGNED-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_ALIGNED_BASES-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_ALIGNED_READS-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_ALIGNED_BASES-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_ALIGNED_Q20_BASES-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_MEDIAN_MISMATCHES-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_MISMATCH_RATE-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_ERROR_RATE-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_INDEL_RATE-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| MEAN_READ_LENGTH-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| READS_ALIGNED_IN_PAIRS-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_READS_ALIGNED_IN_PAIRS-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_READS_IMPROPER_PAIRS-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_PF_READS_IMPROPER_PAIRS-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| BAD_CYCLES-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| STRAND_BALANCE-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_CHIMERAS-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_ADAPTER-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| SAMPLE-SECOND_OF_PAIR | Picard CollectAlignmentSummaryMetrics | |
| CATEGORY-PAIR | Picard CollectAlignmentSummaryMetrics | |
| TOTAL_READS-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_READS-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_PF_READS-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_NOISE_READS-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_READS_ALIGNED-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_PF_READS_ALIGNED-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_ALIGNED_BASES-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_ALIGNED_READS-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_ALIGNED_BASES-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_ALIGNED_Q20_BASES-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_MEDIAN_MISMATCHES-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_MISMATCH_RATE-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_HQ_ERROR_RATE-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_INDEL_RATE-PAIR | Picard CollectAlignmentSummaryMetrics | |
| MEAN_READ_LENGTH-PAIR | Picard CollectAlignmentSummaryMetrics | |
| READS_ALIGNED_IN_PAIRS-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_READS_ALIGNED_IN_PAIRS-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PF_READS_IMPROPER_PAIRS-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_PF_READS_IMPROPER_PAIRS-PAIR | Picard CollectAlignmentSummaryMetrics | |
| BAD_CYCLES-PAIR | Picard CollectAlignmentSummaryMetrics | |
| STRAND_BALANCE-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_CHIMERAS-PAIR | Picard CollectAlignmentSummaryMetrics | |
| PCT_ADAPTER-PAIR | Picard CollectAlignmentSummaryMetrics | |
| SAMPLE-PAIR | Picard CollectAlignmentSummaryMetrics | |
| LIBRARY | Picard CollectDuplicateMetrics | |
| UNPAIRED_READS_EXAMINED | Picard CollectDuplicateMetrics | |
| READ_PAIRS_EXAMINED | Picard CollectDuplicateMetrics | |
| SECONDARY_OR_SUPPLEMENTARY_RDS | Picard CollectDuplicateMetrics | |
| UNMAPPED_READS | Picard CollectDuplicateMetrics | |
| UNPAIRED_READ_DUPLICATES | Picard CollectDuplicateMetrics | |
| READ_PAIR_DUPLICATES | Picard CollectDuplicateMetrics | |
| READ_PAIR_OPTICAL_DUPLICATES | Picard CollectDuplicateMetrics | |
| PERCENT_DUPLICATION | Picard CollectDuplicateMetrics | |
| ESTIMATED_LIBRARY_SIZE | Picard CollectDuplicateMetrics | |
| MEDIAN_INSERT_SIZE | Picard CollectInsertSizeMetrics | |
| MODE_INSERT_SIZE | Picard CollectInsertSizeMetrics | |
| MEDIAN_ABSOLUTE_DEVIATION | Picard CollectInsertSizeMetrics | |
| MIN_INSERT_SIZE | Picard CollectInsertSizeMetrics | |
| MAX_INSERT_SIZE | Picard CollectInsertSizeMetrics | |
| MEAN_INSERT_SIZE | Picard CollectInsertSizeMetrics | |
| STANDARD_DEVIATION | Picard CollectInsertSizeMetrics | |
| READ_PAIRS | Picard CollectInsertSizeMetrics | |
| PAIR_ORIENTATION | Picard CollectInsertSizeMetrics | |
| WIDTH_OF_10_PERCENT | Picard CollectInsertSizeMetrics | |
| WIDTH_OF_20_PERCENT | Picard CollectInsertSizeMetrics | |
| WIDTH_OF_30_PERCENT | Picard CollectInsertSizeMetrics | |
| WIDTH_OF_40_PERCENT | Picard CollectInsertSizeMetrics | |
| WIDTH_OF_50_PERCENT | Picard CollectInsertSizeMetrics | |
| WIDTH_OF_60_PERCENT | Picard CollectInsertSizeMetrics | |
| WIDTH_OF_70_PERCENT | Picard CollectInsertSizeMetrics | |
| WIDTH_OF_80_PERCENT | Picard CollectInsertSizeMetrics | |
| WIDTH_OF_90_PERCENT | Picard CollectInsertSizeMetrics | |
| WIDTH_OF_95_PERCENT | Picard CollectInsertSizeMetrics | |
| WIDTH_OF_99_PERCENT | Picard CollectInsertSizeMetrics | |
| SAMPLE | Picard CollectInsertSizeMetrics | |
| TOTAL_READS | Picard CollectQualityYieldMetrics | (for exome, the evaluator will use value from CollectHsMetrics instead) |
| PF_READS | Picard CollectQualityYieldMetrics | (for exome, the evaluator will use value from CollectHsMetrics instead) |
| READ_LENGTH | Picard CollectQualityYieldMetrics | |
| TOTAL_BASES | Picard CollectQualityYieldMetrics | |
| PF_BASES | Picard CollectQualityYieldMetrics | |
| Q20_BASES | Picard CollectQualityYieldMetrics | |
| PF_Q20_BASES | Picard CollectQualityYieldMetrics | |
| Q30_BASES | Picard CollectQualityYieldMetrics | |
| PF_Q30_BASES | Picard CollectQualityYieldMetrics | |
| Q20_EQUIVALENT_YIELD | Picard CollectQualityYieldMetrics | |
| PF_Q20_EQUIVALENT_YIELD | Picard CollectQualityYieldMetrics | |
| FREEMIX | VerifyBamId | |
GENOME_TERRITORY | Picard CollectWgsMetrics | (WGS only) |
| MEAN_COVERAGE | Picard CollectWgsMetrics | (WGS only) |
| SD_COVERAGE | Picard CollectWgsMetrics | (WGS only) |
| MEDIAN_COVERAGE | Picard CollectWgsMetrics | (WGS only) |
| MAD_COVERAGE | Picard CollectWgsMetrics | (WGS only) |
| PCT_EXC_ADAPTER | Picard CollectWgsMetrics | (WGS only) |
| PCT_EXC_MAPQ | Picard CollectWgsMetrics | (WGS only) |
| PCT_EXC_DUPE | Picard CollectWgsMetrics | (WGS only) |
| PCT_EXC_UNPAIRED | Picard CollectWgsMetrics | (WGS only) |
| PCT_EXC_BASEQ | Picard CollectWgsMetrics | (WGS only) |
| PCT_EXC_OVERLAP | Picard CollectWgsMetrics | (WGS only) |
| PCT_EXC_CAPPED | Picard CollectWgsMetrics | (WGS only) |
| PCT_EXC_TOTAL | Picard CollectWgsMetrics | (WGS only) |
| PCT_1X | Picard CollectWgsMetrics | (WGS only) |
| PCT_5X | Picard CollectWgsMetrics | (WGS only) |
| PCT_10X | Picard CollectWgsMetrics | (WGS only) |
| PCT_15X | Picard CollectWgsMetrics | (WGS only) |
| PCT_20X | Picard CollectWgsMetrics | (WGS only) |
| PCT_25X | Picard CollectWgsMetrics | (WGS only) |
| PCT_30X | Picard CollectWgsMetrics | (WGS only) |
| PCT_40X | Picard CollectWgsMetrics | (WGS only) |
| PCT_50X | Picard CollectWgsMetrics | (WGS only) |
| PCT_60X | Picard CollectWgsMetrics | (WGS only) |
| PCT_70X | Picard CollectWgsMetrics | (WGS only) |
| PCT_80X | Picard CollectWgsMetrics | (WGS only) |
| PCT_90X | Picard CollectWgsMetrics | (WGS only) |
| PCT_100X | Picard CollectWgsMetrics | (WGS only) |
| HET_SNP_SENSITIVITY | Picard CollectWgsMetrics | (WGS only) |
| HET_SNP_Q | Picard CollectWgsMetrics | (WGS only) |
| BAIT_SET	The name of the bait set used in the hybrid selection.
| GENOME_SIZE | Picard CollectHsMetrics | (exome only) |
| BAIT_TERRITORY | Picard CollectHsMetrics | (exome only) |
| TARGET_TERRITORY | Picard CollectHsMetrics | (exome only) |
| BAIT_DESIGN_EFFICIENCY | Picard CollectHsMetrics | (exome only) |
| TOTAL_READS | Picard CollectHsMetrics | (exome only) |
| PF_READS | Picard CollectHsMetrics | (exome only) |
| PF_UNIQUE_READS | Picard CollectHsMetrics | (exome only) |
| PCT_PF_READS | Picard CollectHsMetrics | (exome only) |
| PCT_PF_UQ_READS | Picard CollectHsMetrics | (exome only) |
| PF_UQ_READS_ALIGNED | Picard CollectHsMetrics | (exome only) |
| PCT_PF_UQ_READS_ALIGNED | Picard CollectHsMetrics | (exome only) |
| PF_BASES_ALIGNED | Picard CollectHsMetrics | (exome only) |
| PF_UQ_BASES_ALIGNED | Picard CollectHsMetrics | (exome only) |
| ON_BAIT_BASES | Picard CollectHsMetrics | (exome only) |
| NEAR_BAIT_BASES | Picard CollectHsMetrics | (exome only) |
| OFF_BAIT_BASES | Picard CollectHsMetrics | (exome only) |
| ON_TARGET_BASES | Picard CollectHsMetrics | (exome only) |
| PCT_SELECTED_BASES | Picard CollectHsMetrics | (exome only) |
| PCT_OFF_BAIT | Picard CollectHsMetrics | (exome only) |
| ON_BAIT_VS_SELECTED | Picard CollectHsMetrics | (exome only) |
| MEAN_BAIT_COVERAGE | Picard CollectHsMetrics | (exome only) |
| MEAN_TARGET_COVERAGE | Picard CollectHsMetrics | (exome only) |
| MEDIAN_TARGET_COVERAGE | Picard CollectHsMetrics | (exome only) |
| MAX_TARGET_COVERAGE | Picard CollectHsMetrics | (exome only) |
| PCT_USABLE_BASES_ON_BAIT | Picard CollectHsMetrics | (exome only) |
| PCT_USABLE_BASES_ON_TARGET | Picard CollectHsMetrics | (exome only) |
| FOLD_ENRICHMENT | Picard CollectHsMetrics | (exome only) |
| ZERO_CVG_TARGETS_PCT | Picard CollectHsMetrics | (exome only) |
| PCT_EXC_DUPE | Picard CollectHsMetrics | (exome only) |
| PCT_EXC_MAPQ | Picard CollectHsMetrics | (exome only) |
| PCT_EXC_BASEQ | Picard CollectHsMetrics | (exome only) |
| PCT_EXC_OVERLAP | Picard CollectHsMetrics | (exome only) |
| PCT_EXC_OFF_TARGET | Picard CollectHsMetrics | (exome only) |
| FOLD_80_BASE_PENALTY | Picard CollectHsMetrics | (exome only) |
| PCT_TARGET_BASES_1X | Picard CollectHsMetrics | (exome only) |
| PCT_TARGET_BASES_2X | Picard CollectHsMetrics | (exome only) |
| PCT_TARGET_BASES_10X | Picard CollectHsMetrics | (exome only) |
| PCT_TARGET_BASES_20X | Picard CollectHsMetrics | (exome only) |
| PCT_TARGET_BASES_30X | Picard CollectHsMetrics | (exome only) |
| PCT_TARGET_BASES_40X | Picard CollectHsMetrics | (exome only) |
| PCT_TARGET_BASES_50X | Picard CollectHsMetrics | (exome only) |
| PCT_TARGET_BASES_100X | Picard CollectHsMetrics | (exome only) |
| HS_LIBRARY_SIZE | Picard CollectHsMetrics | (exome only) |
| HS_PENALTY_10X | Picard CollectHsMetrics | (exome only) |
| HS_PENALTY_20X | Picard CollectHsMetrics | (exome only) |
| HS_PENALTY_30X | Picard CollectHsMetrics | (exome only) |
| HS_PENALTY_40X | Picard CollectHsMetrics | (exome only) |
| HS_PENALTY_50X | Picard CollectHsMetrics | (exome only) |
| HS_PENALTY_100X | Picard CollectHsMetrics | (exome only) |
| AT_DROPOUT | Picard CollectHsMetrics | (exome only) |
| GC_DROPOUT | Picard CollectHsMetrics | (exome only) |
| HET_SNP_SENSITIVITY | Picard CollectHsMetrics | (exome only) |
| HET_SNP_Q | Picard CollectHsMetrics | (exome only) |
