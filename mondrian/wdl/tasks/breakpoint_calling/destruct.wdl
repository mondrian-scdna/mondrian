version development

import "https://raw.githubusercontent.com/mondrian-scwgs/mondrian/dev/mondrian/wdl/types/breakpoint_refdata.wdl" as refdata_struct


task runDestruct{
    input{
        File normal_bam
        File tumour_bam
        File reference
        File reference_fai
        File reference_gtf
        File reference_fa_1_ebwt
        File reference_fa_2_ebwt
        File reference_fa_3_ebwt
        File reference_fa_4_ebwt
        File reference_fa_rev_1_ebwt
        File reference_fa_rev_2_ebwt
        File dgv
        File repeats_satellite_regions
        String num_threads
    }
    command<<<
        echo "genome_fasta = '~{reference}'; genome_fai = '~{reference_fai}'; gtf_filename = '~{reference_gtf}'" > config.py

        destruct run $(dirname ~{reference}) \
        breakpoint_table.csv breakpoint_library_table.csv \
        breakpoint_read_table.csv \
        --bam_files ~{tumour_bam} ~{normal_bam} \
        --lib_ids tumour normal \
        --tmpdir tempdir --pipelinedir pipelinedir --submit local --config config.py --loglevel DEBUG --maxjobs ~{num_threads}
    >>>
    output{
        File breakpoint_table = "breakpoint_table.csv"
        File library_table = "breakpoint_library_table.csv"
        File read_table = "breakpoint_read_table.csv"
    }
    runtime{
        memory: "12 GB"
        cpu: 1
        walltime: "48:00"
        docker: 'quay.io/mondrianscwgs/breakpoint:v0.0.1'
    }
}