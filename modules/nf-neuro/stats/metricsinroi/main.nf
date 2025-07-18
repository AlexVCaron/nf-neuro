process STATS_METRICSINROI {
    tag "$meta.id"
    label 'process_single'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://scil.usherbrooke.ca/containers/scilus_latest.sif':
        'scilus/scilus:19c87b72bcbc683fb827097dda7f917940fda123' }"

    input:
    tuple val(meta), path(metrics), path(rois), path(rois_lut)  /* optional, input = [] */

    output:
    tuple val(meta), path("*_stats.json")       , emit: mqc
    path "versions.yml"                         , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def suffix = task.ext.first_suffix ? "${task.ext.first_suffix}_stats" : "stats"
    def bin = task.ext.bin ? "--bin " : ""
    def normalize_weights = task.ext.normalize_weights ? "--normalize_weights " : ""
    def use_label = task.ext.use_label ? true : false
    """
    export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1
    export OMP_NUM_THREADS=1
    export OPENBLAS_NUM_THREADS=1

    if $use_label;
    then
        if [[ ! -f "$rois_lut" ]];
        then
            echo "ROI LUT is missing. Will fail."
        fi

        scil_volume_stats_in_labels.py $rois $rois_lut \
            --metrics $metrics \
            --sort_keys > ${prefix}__${suffix}.json
    else
        scil_volume_stats_in_ROI.py $rois \
            --metrics $metrics \
            --sort_keys \
            $bin $normalize_weights > ${prefix}__${suffix}.json
    fi

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        scilpy: \$(pip list | grep scilpy | tr -s ' ' | cut -d' ' -f2)
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def suffix = task.ext.first_suffix ? "${task.ext.first_suffix}_stats" : "stats"
    """
    scil_volume_stats_in_ROI.py -h
    scil_volume_stats_in_labels.py -h

    touch ${prefix}__${suffix}.json

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        scilpy: \$(pip list | grep scilpy | tr -s ' ' | cut -d' ' -f2)
    END_VERSIONS
    """
}
