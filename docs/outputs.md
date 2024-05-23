## Workflow outputs

These are the outputs of the `SingleSampleQc.wdl` workflow.

### File outputs

These outputs are the products of running tools in the workflow.

| Name | Source Tool | Notes |
|------|-------------|-------|
| `validation_report` | Picard ValidateSamFile | |
| `alignment_summary_metrics_file` | Picard CollectAlignmentSummaryMetrics | |
| `bait_bias_detail_metrics` | Picard CollectSequencingArtifactMetrics | |
| `bait_bias_summary_metrics` | Picard CollectSequencingArtifactMetrics | |
| `gc_bias_detail_metrics` | Picard CollectGcBiasMetrics | |
| `gc_bias_pdf` | Picard CollectGcBiasMetrics | |
| `gc_bias_summary_metrics` | Picard CollectGcBiasMetrics | |
| `insert_size_histograph_pdf` | Picard CollectInsertSizeMetrics | |
| `insert_size_metrics_file` | Picard CollectInsertSizeMetrics | |
| `pre_adapter_detail_metrics` | Picard CollectSequencingArtifactMetrics | |
| `pre_adapter_summary_metrics` | Picard CollectSequencingArtifactMetrics | |
| `quality_distribution_pdf` | Picard QualityScoreDistribution | |
| `quality_distribution_metrics` | Picard QualityScoreDistribution | |
| `error_summary_metrics` | Picard CollectSequencingArtifactMetrics | |
| `selfSM` | VerifyBamId | |
| `duplication_metrics_file` | Picard CollectDuplicateMetrics | |
| `quality_yield_metrics` | Picard CollectQualityYieldMetrics | |
| `raw_wgs_metrics` | Picard CollectWgsMetrics | (WGS only) |
| `hs_metrics` | Picard CollectHsMetrics | (exome only) |
| `input_bam_md5` | md5sum | |
| `input_bam_index` | samtools index  | |
| `input_bam_idxstats` | samtools idxstats | |
| `input_bam_rx_result` | RxIdentifier | (tool implemented in this workflow) |
| `evaluated_metrics_File` | EvaluateMetrics | (tool implemented in this workflow) |

### Value outputs

The workflow parses the above output files to additionally yield WDL outputs of certain values directly.  (When this workflow is run in Terra, these values can be output directly into a datatable.)

| Name | Description | Purpose | Source Tool |
|------|-------------|---------|-------------|
| `pct_chimeras` | % Chimeras | Variant detection | Picard CollectAlignmentSummaryMetrics |
| `read1_pf_mismatch_rate` | Read1 base mismatch rate | Sequence quality | Picard CollectAlignmentSummaryMetrics |
| `read2_pf_mismatch_rate` | Read2 base mismatch rate | Sequence quality | Picard CollectAlignmentSummaryMetrics |
| `median_insert_size` | Library insert size median | Batch characteristics | Picard CollectInsertSizeMetrics |
| `median_absolute_deviation` | Library insert size mad | Batch characteristics | Picard CollectInsertSizeMetrics |
| `contamination` | FREEMIX | Sample contamination | VerifyBamId |
| `percent_duplication` | % Duplication | | Picard CollectDuplicateMetrics |
| `q20_bases` | Total bases with Q20 or higher | Sequence quality | Picard CollectQualityYieldMetrics |
| `pf_q20_bases` | | | Picard CollectQualityYieldMetrics |
| `q30_bases` | Total bases with Q30 or higher | Sequence quality | Picard CollectQualityYieldMetrics |
| `pf_q30_bases` | | | Picard CollectQualityYieldMetrics |
| `mean_coverage` | Haploid coverage (WGS only) | Coverage depth | Picard CollectWgsMetrics |
| `pct_10x` | % coverage at 10X (WGS only) | Coverage breadth | Picard CollectWgsMetrics |
| `pct_20x` | % coverage at 20X (WGS only) | Coverage breadth | Picard CollectWgsMetrics |
| `pct_30x` | % coverage at 30X (WGS only) | Coverage breadth | Picard CollectWgsMetrics |
| `mean_target_coverage` | Coverage of the target regions (exome only) | Coverage depth | Picard CollectHsMetrics |
| `pct_target_bases_10x` | % target coverage at 10x (exome only) | Coverage breadth | Picard CollectHsMetrics |
| `pct_target_bases_20x` | % target coverage at 20x (exome only) | Coverage breadth | Picard CollectHsMetrics |
| `pct_target_bases_30x` | % target coverage at 30x (exome only) | Coverage breadth | Picard CollectHsMetrics |
| `input_bam_md5_hash` | MD5sum of the input BAM/CRAM file | Data integrity | md5sum |
| `input_bam_rx_value` | Estimated sex from evaluating the Rx | Sex estimation | RxIdentifier (implemented in workflow) |
| `evaluated_metrics` | Map data structure of which metrics pass and fail from the thresholds | Metric evaluation | EvaluateMetrics (implemented in workflow) | 
| `overall_evaluation` | PASS/FAIL status for the sample | Quality control | EvaluateMetrics (implemented in workflow) |
