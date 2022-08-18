process INPUT_TOL {
    label 'process_single'

    conda (params.enable_conda ? "conda-forge::gawk=5.1.0" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/gawk:5.1.0' :
        'quay.io/biocontainers/gawk:5.1.0' }"

    input:
    val tolid
    val project

    output:
    path "*.unmasked.fasta", emit: fasta
    path "samplesheet.csv",  emit: csv

    when:
    task.ext.when == null || task.ext.when

    script:
    def proj = project ?: ""
    """
    tol_input.sh "$tolid" "$proj"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        tol_input.sh: \$(tol_input.sh | tail -n 1 | cut -d' ' -f2)
    END_VERSIONS
    """
}
