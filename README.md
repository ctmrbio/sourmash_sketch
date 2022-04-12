# CTMR's Nextflow sourmash sketcher
This Nextflow workflow allows you to easily compute
[Sourmash](https://sourmash.readthedocs.io/en/latest/) sketches to make
kmer-based comparisons of samples.

Note that it only uses the forward read of each sample to compute the sketch.

The default output directory is `results`. It is possible to change output
directory by specifying `--outdir FOLDERNAME`.

## How to run locally
```
nextflow run ctmrbio/sourmash_sketch --reads 'path/to/reads/*_{1,2}.fq.gz' 
```

## How to run on Gandalf
```
nextflow run ctmrbio/sourmash_sketch --reads 'path/to/reads/*_{1,2}.fq.gz' -profile gandalf 
```
Note that there is only a single `-` in `-profile` (this sends this argument to
Nextflow instead of the workflow).

## Output files
Three types of output are produced, one folder containing the individual sample
sketches, one comparison matrix in binary NumPy format, and some plots.

