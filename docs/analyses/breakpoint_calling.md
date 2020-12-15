# breakpoint calling Analysis

Breakpoint calling analysis runs the following workflows:

- Destruct
- Lumpy
- Gridss
- Svaba

The analysis takes in tumour and normal bam files as input and generates a set of high confidence breakpoints that can be used for downstream analyses. The high confidence breakpoints are breakpoints that were detected by 2 or more callers out of the 4, which was supported by our benchmarking efforts. 




## Input Data Format:

### Tumour:

A Bam file:
- generated by the `merge_cells` analysis from mondrian, as explained [here](data_formats/merged_library_bam.md) or
- single bam file with all tumour cells merged, and one read group per sample


### Normal:

A normal Bam file:
- generated by the `merge_cells` analysis on normal cell bams from mondrian as explained [here](data_formats/merged_library_bam.md), or
- single bam file with all normal cells merged, and one read group per sample, or
- bam file generated by bulk WGS sequencing


#### NOTES:
- adapters must be trimmed.
- ideally, no secondary alignments in bam files



### Output Data Format:

- Gridss.vcf
- svaba.vcf
- destruct.csv
- lumpy.vcf
- high_confidence.csv.gz