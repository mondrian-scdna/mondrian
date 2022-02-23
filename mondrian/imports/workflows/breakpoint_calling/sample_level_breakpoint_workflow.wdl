version 1.0

import "../../mondrian_tasks/mondrian_tasks/io/csverve/csverve.wdl" as csverve
import "../../types/breakpoint_refdata.wdl" as refdata_struct
import "../../workflows/breakpoint_calling/destruct.wdl" as destruct
import "../../workflows/breakpoint_calling/lumpy.wdl" as lumpy
import "../../workflows/breakpoint_calling/gridss.wdl" as gridss
import "../../workflows/breakpoint_calling/svaba.wdl" as svaba
import "../../workflows/breakpoint_calling/consensus.wdl" as consensus
import "../../types/breakpoint_refdata.wdl" as refdata_struct


workflow SampleLevelBreakpointWorkflow {
    input {
        File normal_bam
        File normal_bai
        File tumour_bam
        File tumour_bai
        BreakpointRefdata ref
        String tumour_id
        String normal_id
        String? singularity_image
        String? docker_image
        Int? num_threads = 8
        Int? low_mem = 7
        Int? med_mem = 15
        Int? high_mem = 25
        String? low_walltime = 24
        String? med_walltime = 48
        String? high_walltime = 96
    }
    call lumpy.LumpyWorkflow as lumpy{
        input:
            normal_bam = normal_bam,
            tumour_bam = tumour_bam,
            filename_prefix = tumour_id,
            singularity_image = singularity_image,
            docker_image = docker_image,
            low_mem = low_mem,
            med_mem = med_mem,
            high_mem = high_mem,
            low_walltime = low_walltime,
            med_walltime = med_walltime,
            high_walltime = high_walltime,
    }

    call destruct.DestructWorkflow as destruct{
        input:
            normal_bam = normal_bam,
            tumour_bam = tumour_bam,
            ref = ref,
            num_threads = num_threads,
            filename_prefix = tumour_id,
            singularity_image = singularity_image,
            docker_image = docker_image,
            low_mem = low_mem,
            med_mem = med_mem,
            high_mem = high_mem,
            low_walltime = low_walltime,
            med_walltime = med_walltime,
            high_walltime = high_walltime,
    }

    call gridss.GridssWorkflow as gridss{
        input:
            normal_bam = normal_bam,
            tumour_bam = tumour_bam,
            num_threads = num_threads,
            ref = ref,
            filename_prefix = tumour_id,
            singularity_image = singularity_image,
            docker_image = docker_image,
            low_mem = low_mem,
            med_mem = med_mem,
            high_mem = high_mem,
            low_walltime = low_walltime,
            med_walltime = med_walltime,
            high_walltime = high_walltime,
    }
    call svaba.SvabaWorkflow as svaba{
        input:
            normal_bam = normal_bam,
            normal_bai = normal_bai,
            tumour_bam = tumour_bam,
            tumour_bai = tumour_bai,
            num_threads = num_threads,
            ref = ref,
            filename_prefix = tumour_id,
            singularity_image = singularity_image,
            docker_image = docker_image,
            low_mem = low_mem,
            med_mem = med_mem,
            high_mem = high_mem,
            low_walltime = low_walltime,
            med_walltime = med_walltime,
            high_walltime = high_walltime,
    }

    call consensus.ConsensusWorkflow as cons{
        input:
            destruct = destruct.breakpoint_table,
            lumpy = lumpy.lumpy_vcf,
            gridss = gridss.output_vcf,
            svaba = svaba.output_vcf,
            filename_prefix = tumour_id,
            sample_id = tumour_id,
            singularity_image = singularity_image,
            docker_image = docker_image,
            low_mem = low_mem,
            med_mem = med_mem,
            high_mem = high_mem,
            low_walltime = low_walltime,
            med_walltime = med_walltime,
            high_walltime = high_walltime,
    }
    output{
        File consensus = cons.consensus
        File consensus_yaml = cons.consensus_yaml
        File destruct_outfile = destruct.breakpoint_table
        File destruct_library_outfile = destruct.library_table
        File destruct_read_outfile = destruct.read_table
        File gridss_outfile = gridss.output_vcf
        File svaba_outfile = svaba.output_vcf
        File lumpy_outfile = lumpy.lumpy_vcf
    }
}
