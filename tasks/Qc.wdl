version 1.0

## Copyright Broad Institute, 2018
##
## This WDL defines tasks used for QC of human whole-genome or exome sequencing data.
## ## Runtime parameters are often optimized for Broad's Google Cloud Platform implementation.
## For program versions, see docker containers.
##
## LICENSING :
## This script is released under the WDL source code license (BSD-3) (see LICENSE in
## https://github.com/broadinstitute/wdl). Note however that the programs it calls may
## be subject to different licenses. Users are responsible for checking that they are
## authorized to run all programs before running this script. Please see the docker
## page at https://hub.docker.com/r/broadinstitute/genomes-in-the-cloud/ for detailed
## licensing information pertaining to the included programs.

# Collect sequencing yield quality metrics
task CollectQualityYieldMetrics {
  input {
    File input_bam
    File input_bam_index
    String metrics_filename
    File ref_dict
    File ref_fasta
    File ref_fasta_index
    Int preemptible_tries
  }

  Float ref_size = size(ref_fasta, "GiB") + size(ref_fasta_index, "GiB") + size(ref_dict, "GiB")
  Int disk_size = ceil(size(input_bam, "GiB") + ref_size) + 20

  command {
    java -Xms2000m -jar /usr/picard/picard.jar \
      CollectQualityYieldMetrics \
      INPUT=~{input_bam} \
      REFERENCE_SEQUENCE=~{ref_fasta} \
      OQ=true \
      OUTPUT=~{metrics_filename}
  }
  runtime {
    docker: "us.gcr.io/broad-gotc-prod/picard-cloud:2.21.7"
    disks: "local-disk " + disk_size + " HDD"
    memory: "3 GiB"
    preemptible: preemptible_tries
  }
  output {
    File quality_yield_metrics = "~{metrics_filename}"
  }
}

# Collect quality metrics from the aggregated bam
task CollectAggregationMetrics {
  input {
    File input_bam
    File input_bam_index
    String base_name
    File ref_dict
    File ref_fasta
    File ref_fasta_index
    Boolean collect_gc_bias_metrics = true
    Int preemptible_tries
  }

  Float ref_size = size(ref_fasta, "GiB") + size(ref_fasta_index, "GiB") + size(ref_dict, "GiB")
  Int disk_size = ceil(size(input_bam, "GiB") + ref_size) + 20

  command {
    # These are optionally generated, but need to exist for Cromwell's sake
    touch ~{base_name}.gc_bias.detail_metrics \
      ~{base_name}.gc_bias.pdf \
      ~{base_name}.gc_bias.summary_metrics \
      ~{base_name}.insert_size_metrics \
      ~{base_name}.insert_size_histogram.pdf

    java -Xms5000m -jar /usr/picard/picard.jar \
      CollectMultipleMetrics \
      INPUT=~{input_bam} \
      REFERENCE_SEQUENCE=~{ref_fasta} \
      OUTPUT=~{base_name} \
      ASSUME_SORTED=true \
      PROGRAM=null \
      PROGRAM=CollectAlignmentSummaryMetrics \
      PROGRAM=CollectInsertSizeMetrics \
      PROGRAM=CollectSequencingArtifactMetrics \
      PROGRAM=QualityScoreDistribution \
      ~{true='PROGRAM="CollectGcBiasMetrics"' false="" collect_gc_bias_metrics} \
      METRIC_ACCUMULATION_LEVEL=null \
      METRIC_ACCUMULATION_LEVEL=SAMPLE \
      METRIC_ACCUMULATION_LEVEL=LIBRARY
  }
  runtime {
    docker: "us.gcr.io/broad-gotc-prod/picard-cloud:2.21.7"
    memory: "7 GiB"
    disks: "local-disk " + disk_size + " HDD"
    preemptible: preemptible_tries
  }
  output {
    File alignment_summary_metrics = "~{base_name}.alignment_summary_metrics"
    File bait_bias_detail_metrics = "~{base_name}.bait_bias_detail_metrics"
    File bait_bias_summary_metrics = "~{base_name}.bait_bias_summary_metrics"
    File gc_bias_detail_metrics = "~{base_name}.gc_bias.detail_metrics"
    File gc_bias_pdf = "~{base_name}.gc_bias.pdf"
    File gc_bias_summary_metrics = "~{base_name}.gc_bias.summary_metrics"
    File insert_size_histogram_pdf = "~{base_name}.insert_size_histogram.pdf"
    File insert_size_metrics = "~{base_name}.insert_size_metrics"
    File pre_adapter_detail_metrics = "~{base_name}.pre_adapter_detail_metrics"
    File pre_adapter_summary_metrics = "~{base_name}.pre_adapter_summary_metrics"
    File quality_distribution_pdf = "~{base_name}.quality_distribution.pdf"
    File quality_distribution_metrics = "~{base_name}.quality_distribution_metrics"
    File error_summary_metrics = "~{base_name}.error_summary_metrics"
  }
}

# Collect raw WGS metrics (commonly used QC thresholds)
task CollectRawWgsMetrics {
  input {
    File input_bam
    File input_bam_index
    String metrics_filename
    File wgs_coverage_interval_list
    File ref_fasta
    File ref_fasta_index
    Int read_length
    Int preemptible_tries
    Int memory_multiplier = 1
  }

  Float ref_size = size(ref_fasta, "GiB") + size(ref_fasta_index, "GiB")
  Int disk_size = ceil(size(input_bam, "GiB") + ref_size) + 20

  Int memory_size = ceil((if (disk_size < 110) then 5 else 7) * memory_multiplier)
  String java_memory_size = (memory_size - 1) * 1000

  command {
    java -Xms~{java_memory_size}m -jar /usr/picard/picard.jar \
      CollectWgsMetrics \
      INPUT=~{input_bam} \
      MINIMUM_MAPPING_QUALITY=0 \
      MINIMUM_BASE_QUALITY=3 \
      VALIDATION_STRINGENCY=SILENT \
      REFERENCE_SEQUENCE=~{ref_fasta} \
      INCLUDE_BQ_HISTOGRAM=true \
      INTERVALS=~{wgs_coverage_interval_list} \
      OUTPUT=~{metrics_filename} \
      USE_FAST_ALGORITHM=true \
      READ_LENGTH=~{read_length}

    sed -i.original 's/picard.analysis.WgsMetrics/picard.analysis.CollectWgsMetrics\$WgsMetrics/' ~{metrics_filename}
  }
  runtime {
    # Using older image due to: https://github.com/broadinstitute/picard/issues/1402
    docker: "us.gcr.io/broad-gotc-prod/picard-cloud:2.20.4"
    preemptible: preemptible_tries
    memory: "~{memory_size} GiB"
    disks: "local-disk " + disk_size + " HDD"
  }
  output {
    File metrics = "~{metrics_filename}"
  }
}

task CollectHsMetrics {
  input {
    File input_bam
    File input_bam_index
    File ref_fasta
    File ref_fasta_index
    String metrics_filename
    File target_interval_list
    File bait_interval_list
    Int preemptible_tries
    Int memory_multiplier = 1
  }

  Float ref_size = size(ref_fasta, "GiB") + size(ref_fasta_index, "GiB")
  Int disk_size = ceil(size(input_bam, "GiB") + ref_size) + 20
  # Try to fit the input bam into memory, within reason.
  Int rounded_bam_size = ceil(size(input_bam, "GiB") + 0.5)
  Int rounded_memory_size = ceil((if (rounded_bam_size > 10) then 10 else rounded_bam_size) * memory_multiplier)
  Int memory_size = if rounded_memory_size < 7 then 7 else rounded_memory_size
  Int java_memory_size = (memory_size - 1) * 1000

  # There are probably more metrics we want to generate with this tool
  command {
    java -Xms~{java_memory_size}m -jar /usr/picard/picard.jar \
      CollectHsMetrics \
      INPUT=~{input_bam} \
      REFERENCE_SEQUENCE=~{ref_fasta} \
      VALIDATION_STRINGENCY=SILENT \
      TARGET_INTERVALS=~{target_interval_list} \
      BAIT_INTERVALS=~{bait_interval_list} \
      METRIC_ACCUMULATION_LEVEL=null \
      METRIC_ACCUMULATION_LEVEL=SAMPLE \
      OUTPUT=~{metrics_filename}
  }

  runtime {
    docker: "us.gcr.io/broad-gotc-prod/picard-cloud:2.21.7"
    preemptible: preemptible_tries
    memory: "~{memory_size} GiB"
    disks: "local-disk " + disk_size + " HDD"
  }

  output {
    File metrics = metrics_filename
  }
}

# Collect duplicate metrics
task CollectDuplicateMetrics {
  input {
    File input_bam
    File input_bam_index
    String output_bam_prefix
    File ref_dict
    File ref_fasta
    File ref_fasta_index
    Int preemptible_tries
  }

  Float ref_size = size(ref_fasta, "GiB") + size(ref_fasta_index, "GiB") + size(ref_dict, "GiB")
  Int disk_size = ceil(size(input_bam, "GiB") + ref_size) + 20

  command {
    java -Xms5000m -jar /usr/picard/picard.jar \
      CollectDuplicateMetrics \
      METRICS_FILE=~{output_bam_prefix}.duplication_metrics \
      INPUT=~{input_bam} \
      ASSUME_SORTED=true \
      REFERENCE_SEQUENCE=~{ref_fasta}
  }
  runtime {
    docker: "us.gcr.io/broad-gotc-prod/picard-cloud:2.21.7"
    memory: "7 GiB"
    disks: "local-disk " + disk_size + " HDD"
    preemptible: preemptible_tries
  }
  output {
    File duplication_metrics = "~{output_bam_prefix}.duplication_metrics"
  }
}

# Build BAM/CRAM index, this should run before all other QC tasks
task BuildBamIndex {
  input {
    File input_bam
    String base_name
    File ref_cache
    Int preemptible_tries
  }

  Float ref_size = size(ref_cache, "GiB") * 5 + 1.0
  Int disk_size = ceil(size(input_bam, "GiB") + ref_size) + 20
  String bam_link = sub(basename(input_bam), basename(basename(input_bam, ".bam"), ".cram"), base_name )
  
  command {
    # Link the BAM/CRAM to a harmonized name and path
    ln -s ~{input_bam} ~{bam_link}

    # build the reference sequence cache
    tar -zxf ~{ref_cache}
    export REF_PATH=./cache/%2s/%2s/%s
    export REF_CACHE=./cache/%2s/%2s/%s

    # index the BAM or CRAM
    /usr/local/bin/samtools index ~{bam_link}
  }
  runtime {
    docker: "us.gcr.io/broad-gotc-prod/genomes-in-the-cloud:2.4.2-1564506709"
    memory: "1 GiB"
    disks: "local-disk " + disk_size + " HDD"
    preemptible: preemptible_tries
  }
  output {
    File bam = bam_link
    File bam_index = sub(sub(bam_link, "bam$", "bam.bai"), "cram$", "cram.crai")
  }
}

# Notes on the contamination estimate:
# The contamination value is read from the FREEMIX field of the selfSM file output by verifyBamId
#
# In Zamboni production, this value is stored directly in METRICS.AGGREGATION_CONTAM
#
# Contamination is also stored in GVCF_CALLING and thereby passed to HAPLOTYPE_CALLER
# But first, it is divided by an underestimation factor thusly:
#   float(FREEMIX) / ContaminationUnderestimationFactor
#     where the denominator is hardcoded in Zamboni:
#     val ContaminationUnderestimationFactor = 0.75f
#
# Here, I am handling this by returning both the original selfSM file for reporting, and the adjusted
# contamination estimate for use in variant calling
task CheckContamination {
  input {
    File input_bam
    File input_bam_index
    File contamination_sites_ud
    File contamination_sites_bed
    File contamination_sites_mu
    File ref_fasta
    File ref_fasta_index
    String output_prefix
    Int preemptible_tries
    Boolean disable_sanity_check = false
  }

  Int disk_size = ceil(size(input_bam, "GiB") + size(ref_fasta, "GiB")) + 30

  command <<<
    set -e

    # creates a ~{output_prefix}.selfSM file, a TSV file with 2 rows, 19 columns.
    # First row are the keys (e.g., SEQ_SM, RG, FREEMIX), second row are the associated values
    /usr/gitc/VerifyBamID \
    --Verbose \
    --NumPC 4 \
    --Output ~{output_prefix} \
    --BamFile ~{input_bam} \
    --Reference ~{ref_fasta} \
    --UDPath ~{contamination_sites_ud} \
    --MeanPath ~{contamination_sites_mu} \
    --BedPath ~{contamination_sites_bed} \
    ~{true="--DisableSanityCheck" false="" disable_sanity_check} \
    1>/dev/null

    # used to read from the selfSM file and calculate contamination, which gets printed out
    python3 <<CODE
    import csv
    import sys
    with open('~{output_prefix}.selfSM') as selfSM:
      reader = csv.DictReader(selfSM, delimiter='\t')
      i = 0
      for row in reader:
        if float(row["FREELK0"])==0 and float(row["FREELK1"])==0:
          # a zero value for the likelihoods implies no data. This usually indicates a problem rather than a real event.
          # if the bam isn't really empty, this is probably due to the use of a incompatible reference build between
          # vcf and bam.
          sys.stderr.write("Found zero likelihoods. Bam is either very-very shallow, or aligned to the wrong reference (relative to the vcf).")
          sys.exit(1)
        print(float(row["FREEMIX"]))
        i = i + 1
        # there should be exactly one row, and if this isn't the case the format of the output is unexpectedly different
        # and the results are not reliable.
        if i != 1:
          sys.stderr.write("Found %d rows in .selfSM file. Was expecting exactly 1. This is an error"%(i))
          sys.exit(2)
    CODE
  >>>
  runtime {
    preemptible: preemptible_tries
    memory: "4 GiB"
    disks: "local-disk " + disk_size + " HDD"
    docker: "us.gcr.io/broad-gotc-prod/verify-bam-id:c1cba76e979904eb69c31520a0d7f5be63c72253-1553018888"
    cpu: "2"
  }
  output {
    File selfSM = "~{output_prefix}.selfSM"
    Float contamination = read_float(stdout())
  }
}

task CalculateChecksum {
  input {
    File input_bam
    Int preemptible_tries
  }

  Int disk_size = ceil(size(input_bam, "GiB")) + 20

  String output_name = basename(input_bam)

  command {
    md5sum ~{input_bam} > ~{output_name}.md5
  }
  runtime {
    preemptible: preemptible_tries
    memory: "2 GiB"
    disks: "local-disk " + disk_size + " HDD"
    docker: "us.gcr.io/gcp-runtimes/ubuntu_16_0_4:latest"
  }
  output {
    File md5 = "~{output_name}.md5"
    String md5_hash = sub(read_string(md5), " .+$", "")
  }
}
