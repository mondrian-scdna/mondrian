version 1.0

import "imports/workflows/haplotype_calling/count_haplotypes.wdl" as count_haps
import "imports/workflows/haplotype_calling/infer_haplotypes.wdl" as infer_haps
import "imports/types/haplotype_refdata.wdl"
import "imports/mondrian_tasks/mondrian_tasks/haplotypes/utils.wdl" as utils
import "imports/mondrian_tasks/mondrian_tasks/io/csverve/csverve.wdl" as csverve


workflow InferHaplotypeWorkflow{
    input{
        File bam
        File bai
        String? sex = 'female'
        String? data_type = 'normal'
        HaplotypeRefdata reference
        Array[String] chromosomes
        String? filename_prefix = "infer_haps"
        String? singularity_image = ""
        String? docker_image = "quay.io/baselibrary/ubuntu"
        Int? num_threads = 8
        Int? memory_override
        Int? walltime_override
    }


    call infer_haps.InferHaplotypesWorkflow as infer_haps{
        input:
            bam = bam,
            bai = bai,
            snp_positions = reference.snp_positions,
            thousand_genomes_tar = reference.thousand_genomes_tar,
            reference_fai = reference.reference_fai,
            chromosomes = chromosomes,
            data_type = data_type,
            sex = sex,
            filename_prefix = filename_prefix,
            singularity_image = singularity_image,
            docker_image = docker_image,
            memory_override = memory_override,
            walltime_override = walltime_override
    }

    output{
        File haplotypes = infer_haps.haplotypes_csv
        File haplotypes_yaml = infer_haps.haplotypes_csv_yaml
    }
}

