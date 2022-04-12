#!/usr/bin/env nextflow

if ( ! params.reads ) {
    log.error "No reads specified! Provide --reads 'path/to/*_{1,2}.fq.gz' (single quotes)"
    exit(1)
}

Channel
    .fromFilePairs(params.reads, checkIfExists:true)
    .set { samples_ch }


process sketch {
  tag { sample_id }
  publishDir "${params.outdir}/sketch", mode: "link"

  input:
  set sample_id, file(reads) from samples_ch

  output:
  file "${sample_id}.sig" into signatures

  script:
  """
  sourmash sketch dna \
  	-p k=21,k=31,k=51,abund \
	--output "${sample_id}.sig" \
  	"${reads[0]}"
  """
}


process compare {
  publishDir "${params.outdir}", mode: "link"

  input:
  file '*' from signatures.collect()


  output:
  set file("comparison_matrix"), file("comparison_matrix.labels.txt") into comparison_matrix
  file "comparison_matrix.csv"

  script:
  """
  sourmash compare \
    --ksize 31 \
    --output comparison_matrix \
	--csv comparison_matrix.csv \
    *.sig 
  """
}


process plot {
  publishDir "${params.outdir}", mode: "link"

  input:
  set file("comparison"), file("comparison.labels.txt") from comparison_matrix

  output:
  file "comparison.dendro.png"
  file "comparison.hist.png"
  file "comparison.matrix.png"
  file "comparison.labels.txt"

  script:
  """
  sourmash plot comparison --labels
  """
}

