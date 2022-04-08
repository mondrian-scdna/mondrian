version 1.0

import "imports/mondrian_tasks/mondrian_tasks/variant_calling/utils.wdl" as utils
import "imports/workflows/variant_calling/consensus.wdl" as consensus
import "imports/types/variant_refdata.wdl"


workflow ConsensusWorkflow{
    input{
        File museq_vcffile
        File museq_vcffile_tbi
        File mutect_vcffile
        File mutect_vcffile_tbi
        File strelka_snv_vcffile
        File strelka_snv_vcffile_tbi
        File strelka_indel_vcffile
        File strelka_indel_vcffile_tbi
        Array[String] chromosomes
        String tumour_id
        String normal_id
        VariantRefdata reference
        String? singularity_image = ""
        String? docker_image = "ubuntu"
        Int? low_mem = 7
        Int? med_mem = 15
        Int? high_mem = 25
        String? low_walltime = 24
        String? med_walltime = 48
        String? high_walltime = 96
    }

    call consensus.ConsensusWorkflow as consensus{
        input:
            museq_vcf = museq_vcffile,
            museq_vcf_tbi = museq_vcffile_tbi,
            mutect_vcf = mutect_vcffile,
            mutect_vcf_tbi = mutect_vcffile_tbi,
            strelka_snv = strelka_snv_vcffile,
            strelka_snv_tbi = strelka_snv_vcffile_tbi,
            strelka_indel = strelka_indel_vcffile,
            strelka_indel_tbi = strelka_indel_vcffile_tbi,
            normal_id = normal_id,
            tumour_id = tumour_id,
            vep_ref = reference.vep_ref,
            vep_fasta_suffix = reference.vep_fasta_suffix,
            ncbi_build = reference.ncbi_build,
            chromosomes = chromosomes,
            singularity_image = singularity_image,
            docker_image = docker_image,
            low_mem = low_mem,
            med_mem = med_mem,
            high_mem = high_mem,
            low_walltime = low_walltime,
            med_walltime = med_walltime,
            high_walltime = high_walltime
    }


    call utils.VariantMetadata as metadata{
        input:
            files = {
                'consensus_vcf': [consensus.vcf_output, consensus.vcf_csi_output, consensus.vcf_tbi_output],
                'consensus_maf': [consensus.maf_output],
            },
            metadata_yaml_files = [],
            samples = [],
            singularity_image = singularity_image,
            docker_image = docker_image,
            memory_gb = low_mem,
            walltime_hours = low_walltime
    }


    output{
        File vcf_output = consensus.vcf_output
        File vcf_csi_output = consensus.vcf_csi_output
        File vcf_tbi_output = consensus.vcf_tbi_output
        File maf_output = consensus.maf_output
        File metadata_output = metadata.metadata_output
    }
}
