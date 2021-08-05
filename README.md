# S3norm_pipeline

The scripts are used to generate the initial files for S3norm-based normalization methods: https://github.com/guanjue/S3norm

The first step is to generate the individual bedgraph files from bam files. The bedgraphs are then merged together to generate a union of bed files. Then we use awk to split the individual files. This step is done so that each of the bedgraph files have the same start and end location. We also generate a control bdg file with the score "1".

After normalization with S3norm, normalized bdg files will be generated. Convert them to bigwig:
# bedGraphToBigWig
module load conda
conda create -n bedgraphtobigwig -c bioconda ucsc-bedgraphtobigwig
conda activate bedgraphtobigwig
cmd:
bedGraphToBigWig -in_bgd_file -out_bw_file
