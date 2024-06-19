# Running the QC workflow in AnVIL

This walkthrough demonstrates running the `SingleSampleQc.wdl` workflow in AnVIL and writing the results to a datatable.

## Pre-requisites

* Creating workspaces and running workflows requires accounts and billing to be configured. For more on this, see [Setting up Lab Accounts and Billing in AnVIL](https://anvilproject.org/learn/investigators/setting-up-lab-accounts).


## Preparing a workspace

1. Log into [AnVIL](https://anvil.terra.bio) if you haven't already.
2. Visit the Workspaces page by either choosing "View Workspaces" on the main page or "Workspaces" from the left menu.
3. Create a new workspace by using the "+" button next to the Workspaces heading.  Fill out a name, billing project, and any other desired fields. (A description can be handy for anyone looking at this workspace in the future!)
    * For running QC on an existing workspace, one would instead search on the Workspaces page for the existing workspace and choose "Clone" from the three-dot menu.
4. Wait while the system provisions the new workspace.

## Adding data

There are several ways to add data to a workspace.  This walkthrough will use a simple one using public data for demonstration purposes. See also [Ingest Data](https://anvilproject.org/learn/data-submitters/submission-guide/ingesting-data) for more on the AnVIL process for adding data.

1. Go to the "Data" tab of the new workspace.
2. Select the "Import Data" button.
3. Select "Upload TSV".
4. Switch to "Text Import".
5. Copy the following TSV:
   ```tsv
   entity:sample_id	cram	is_wgs
   NA12878	gs://broad-public-datasets/NA12878/NA12878.cram	true
   ```
6. Paste the TSV into the box and "Start Import Job".
7. Once the import completes, click the "sample" table and see that it contains the single row.
    * The cram will have an info alert that the file is not stored within the workspace.  That is expected here, but for a real dataset normally the files would be a part of the workspace.
8. Select the "Files" section under other data.
9. Download the [thresholds TSV](https://raw.githubusercontent.com/genome/qc-analysis-pipeline/master/threshold_files/anvil_wgs_thresholds.tsv) and "Upload" it to the workspace.

## Setting up the workflow and inputs

1. Visit [the dockstore page for the QC Workflow](https://dockstore.org/workflows/github.com/genome/qc-analysis-pipeline:master).
2. In the "Launch with" section, choose "AnVIL".
3. Choose the correct workspace in the "Destination Workspace" dropdown and "Import" the workflow.
4. Ensure the "Run workflow(s) with inputs defined by data table" option is selected.
5. Select the "sample" data table under "Step 1" and then choose "Select Data" under Step 2.
6. Tick the box for the one and only row and choose "OK".
7. Download the [input JSON](https://raw.githubusercontent.com/genome/qc-analysis-pipeline/master/SingleSampleQc.json) from the github repository, then choose "upload JSON" on the workflow page and upload the JSON that was downloaded.
    * This will fill in all the values necessary to run the workflow.  Since the JSON includes the path to a CRAM and sample name already, if we didn't have a datatable this would be sufficient to launch a single workflow now.
8. Swap out the following values in the "input value" boxes on the "Inputs" tab:
    | Variable  | Input value      |
    |-----------|------------------|
    | base_name | `this.sample_id` |
    | input_bam | `this.cram`      |
    | is_wgs    | `this.is_wgs`    |
9. For the "evaluation_thresholds", press the folder icon in the input value box and then select the `anvil_wgs_thresholds.tsv` uploaded in the previous section.
10. Be sure to "Save" before continuing.

## Running the workflow

1. Switch to the "Outputs" tab" and verify that the "Input value" column is filled in for each output.  If not, choose "Use defaults" in the header of the "Input value" column and be sure to "Save".
2. Tick the "Delete intermediate outputs" box so that the working files are not retained after the workflow completes.
3. Choose "Run analysis" to open the launcher.
4. Confirm that this will launch `1` analysis, enter a description if desired, and "Launch" the analysis.
5. Wait while the workflow runs; this may take several hours.  An e-mail will be sent when the workflow completes.
    * While it is in progress, the "Job History" tab can be used to monitor its progress. More info is available in [Terra's Job History overview](https://support.terra.bio/hc/en-us/articles/360037096272-Job-History-overview-monitoring-workflows).
    * The workflow uses pre-emptible instances to reduce costs, so some steps may take multiple attempts to complete if they were interrupted.
6. Visit the "Data" tab again to see that the outputs of the workflow have been added to the "sample" table in the workspace.

## MultiQC notebook

1. Open the "Analyses" tab of the workflow and press the "Start" button.
2. Download [the notebook](https://raw.githubusercontent.com/genome/qc-analysis-pipeline/master/notebook/MultiQC.ipynb) from the github repository, then upload it using the overlay that appeared.
3. Click on the "MultiQC.ipynb" that appears in the list.
4. Choose the "Open" button next to the preview.
5. As noted in the notebook, set the "Startup script" to `https://raw.githubusercontent.com/genome/qc-analysis-pipeline/master/notebook/multiqc_terra_startup.sh` which will load a special version of MultiQC into the notebook's VM.
6. MultiQC requires more resources than the default, so switch the "CPUs" to 2 and the "Memory (GB)" to 13.
    * The VM should be set to auto-pause after a period of inactivity.  This is important for reducing costs.  At any time, the VM can also be manually paused by clicking the cloud with lightning bolt in the sidebar of the page and pressing Pause.  Under "Settings" the environment can also be deleted to eliminate the ongoing costs associated with the VM.
7. Press "Create" and wait for the VM to be ready.
8. Press "Open" again to open the notebook in the VM.
9. Select the cell that begins `import firecloud.api as fapi` and press the "Run" button.
10. Select the cell below it that begins `import asyncio` and press the "Run" button again.  This one will launch MultiQC.
11. Once it finishes the report will be linked in a line of output starting with "Report has been uploaded to...". Click that link to visit the Cloud Storage page for the report and then click the "Authenticated URL" to view it in your browser.
