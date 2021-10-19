version 1.0

import "imports/workflows/variant_calling/sample_level_variant_workflow.wdl" as variant
import "imports/mondrian_tasks/mondrian_tasks/variant_calling/vcf2maf.wdl" as vcf2maf
import "imports/mondrian_tasks/mondrian_tasks/io/vcf/bcftools.wdl" as bcftools


struct Sample{
    String sample_id
    File tumour
    File tumour_bai
}


workflow VariantWorkflow{
    input{
        File normal_bam
        File normal_bai
        String ref_dir
        Int numThreads
        Array[String] chromosomes
        String normal_id
        Array[Sample] samples
        String? singularity_dir = ""
    }

    VariantRefdata ref = {
        "reference": ref_dir+'/human/GRCh37-lite.fa',
        "reference_dict": ref_dir+'/human/GRCh37-lite.dict',
        "reference_fa_fai": ref_dir+'/human/GRCh37-lite.fa.fai',
        'vep_ref': ref_dir + '/vep.tar'
    }


    scatter (sample in samples){
        String tumour_id = sample.sample_id
        File bam = sample.tumour
        File bai = sample.tumour_bai


        call variant.SampleLevelVariantWorkflow as variant_workflow{
            input:
                normal_bam = normal_bam,
                normal_bai = normal_bai,
                tumour_bam = bam,
                tumour_bai = bai,
                reference = ref.reference,
                reference_fai = ref.reference_fa_fai,
                reference_dict = ref.reference_dict,
                numThreads=numThreads,
                chromosomes = chromosomes,
                vep_ref = ref.vep_ref,
                tumour_id = tumour_id,
                normal_id = normal_id,
                singularity_dir = singularity_dir
        }
    }

    call bcftools.mergeVcf as merge_vcf{
        input:
            vcf_files = variant_workflow.vcf_output,
            csi_files = variant_workflow.vcf_csi_output,
            tbi_files = variant_workflow.vcf_tbi_output,
            singularity_dir = singularity_dir
    }
    call vcf2maf.MergeMafs as merge_mafs{
        input:
            input_mafs = variant_workflow.maf_output,
            singularity_dir = singularity_dir
    }
}