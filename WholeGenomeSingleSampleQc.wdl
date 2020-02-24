version 1.0

## Copyright Broad Institute, 2018
##
## This WDL pipeline implements QC in human whole-genome sequencing data.
##
## Requirements/expectations
## - Human whole-genome paired-end sequencing data in aligned BAM or CRAM format
## - Input BAM/CRAM files must additionally comply with the following requirements:
## - - files must pass validation by ValidateSamFile
## - - reads are provided in query-sorted order
## - - all reads must have an RG tag
## - Reference genome must be Hg38 with ALT contigs
##
## Runtime parameters are optimized for Broad's Google Cloud Platform implementation.
## For program versions, see docker containers.
##
## LICENSING :
## This script is released under the WDL open source code license (BSD-3).
## Full license text at https://github.com/openwdl/wdl/blob/master/LICENSE
## Note however that the programs it calls may be subject to different licenses. 
## Users are responsible for checking that they are authorized to run all programs before running this script.
## - [Picard](https://broadinstitute.github.io/picard/)
## - [VerifyBamID2](https://github.com/Griffan/VerifyBamID)

# Git URL import
import "https://raw.githubusercontent.com/genome/qc-analysis-pipeline/cache-bypass/tasks/Qc.wdl" as QC
# import "./tasks/Qc.wdl" as QC

# WORKFLOW DEFINITION
workflow WholeGenomeSingleSampleQc {
  input {
    File input_bam
    File ref_dict
    File ref_fasta
    File ref_fasta_index
    String base_name
    Int preemptible_tries
    File wgs_coverage_interval_list
    File contamination_sites_ud
    File contamination_sites_bed
    File contamination_sites_mu
    Boolean? is_outlier_data
  }

  # Not overridable:
  Int read_length = 250
  
  # Generate a BAM or CRAM index
  call QC.BuildBamIndex as BuildBamIndex {
    input:
      input_bam = input_bam,
      ref_dict = ref_dict,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      preemptible_tries = preemptible_tries
  }
  # Validate the BAM or CRAM file
  # call QC.ValidateSamFile as ValidateSamFile {
  #  input:
  #    input_bam = input_bam,
  #    input_bam_index = input_bam_index,
  #    report_filename = base_name + ".validation_report",
  #    ref_dict = ref_dict,
  #    ref_fasta = ref_fasta,
  #    ref_fasta_index = ref_fasta_index,
  #    ignore = ["MISSING_TAG_NM"],
  #    max_output = 1000000000,
  #    is_outlier_data = is_outlier_data,
  #    preemptible_tries = preemptible_tries
  # }

  # generate a md5
  call QC.CalculateChecksum as CalculateChecksum {
    input:
      input_bam = input_bam,
      preemptible_tries = preemptible_tries
  }

  # QC the final BAM some more (no such thing as too much QC)
  call QC.CollectAggregationMetrics as CollectAggregationMetrics {
    input:
      input_bam = input_bam,
      input_bam_index = BuildBamIndex.bam_index,
      base_name = base_name,
      ref_dict = ref_dict,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      preemptible_tries = preemptible_tries
  }

  # QC the BAM sequence yield
  call QC.CollectQualityYieldMetrics as CollectQualityYieldMetrics {
    input:
      input_bam = input_bam,
      input_bam_index = BuildBamIndex.bam_index,
      ref_dict = ref_dict,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      metrics_filename = base_name + ".quality_yield_metrics",
      preemptible_tries = preemptible_tries
  }

  # QC the sample raw WGS metrics (common thresholds)
  call QC.CollectRawWgsMetrics as CollectRawWgsMetrics {
    input:
      input_bam = input_bam,
      input_bam_index = BuildBamIndex.bam_index,
      metrics_filename = base_name + ".raw_wgs_metrics",
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      wgs_coverage_interval_list = wgs_coverage_interval_list,
      read_length = read_length,
      preemptible_tries = preemptible_tries
  }

  # Estimate level of cross-sample contamination
  call QC.CheckContamination as CheckContamination {
    input:
      input_bam = input_bam,
      input_bam_index = BuildBamIndex.bam_index,
      contamination_sites_ud = contamination_sites_ud,
      contamination_sites_bed = contamination_sites_bed,
      contamination_sites_mu = contamination_sites_mu,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      output_prefix = base_name + ".verify_bam_id",
      preemptible_tries = preemptible_tries,
  }

  # Calculate the duplication rate since MarkDuplicates was already performed
  call QC.CollectDuplicateMetrics as CollectDuplicateMetrics {
    input:
      input_bam = input_bam,
      output_bam_prefix = base_name,
      ref_dict = ref_dict,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      preemptible_tries = preemptible_tries
  }

  # Outputs that will be retained when execution is complete
  output {

    # File validation_report = ValidateSamFile.report
    File input_bam_index = BuildBamIndex.bam_index

    File alignment_summary_metrics = CollectAggregationMetrics.alignment_summary_metrics
    File bait_bias_detail_metrics = CollectAggregationMetrics.bait_bias_detail_metrics
    File bait_bias_summary_metrics = CollectAggregationMetrics.bait_bias_summary_metrics
    File gc_bias_detail_metrics = CollectAggregationMetrics.gc_bias_detail_metrics
    File gc_bias_pdf = CollectAggregationMetrics.gc_bias_pdf
    File gc_bias_summary_metrics = CollectAggregationMetrics.gc_bias_summary_metrics
    File insert_size_histogram_pdf = CollectAggregationMetrics.insert_size_histogram_pdf
    File insert_size_metrics = CollectAggregationMetrics.insert_size_metrics
    File pre_adapter_detail_metrics = CollectAggregationMetrics.pre_adapter_detail_metrics
    File pre_adapter_summary_metrics = CollectAggregationMetrics.pre_adapter_summary_metrics
    File quality_distribution_pdf = CollectAggregationMetrics.quality_distribution_pdf
    File quality_distribution_metrics = CollectAggregationMetrics.quality_distribution_metrics
    File error_summary_metrics = CollectAggregationMetrics.error_summary_metrics

    File selfSM = CheckContamination.selfSM
    Float contamination = CheckContamination.contamination    

    File duplication_metrics = CollectDuplicateMetrics.duplication_metrics

    File quality_yield_metrics = CollectQualityYieldMetrics.quality_yield_metrics

    File raw_wgs_metrics = CollectRawWgsMetrics.metrics

    File input_bam_md5 = CalculateChecksum.md5
  }
}
