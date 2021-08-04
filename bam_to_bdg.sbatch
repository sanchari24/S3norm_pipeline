#!/bin/bash

#SBATCH -J s3norm_bigwig.%j
#SBATCH -p All # la partition
#SBATCH -n 8 # nombre de processeurs
#SBATCH -N 1 # nombre de noeuds, DO NOT CHANGE THIS SETTING
#SBATCH --mem 30000 # mémoire (en MB)
#SBATCH -o /K/CHROCYC/sanchari/Alice_project/slurm/Bowtie_ChIPseq_ALice.%j.o
#SBATCH -e /K/CHROCYC/sanchari/Alice_project/slurm/Bowtie_ChIPseq_ALice.%j.e
#SBATCH --mail-type=END # notification par e-mail à la fin en cas de réussite ou erreur
#SBATCH --mail-user=sanchari.sircar@u-psud.fr # l’adresse e-mail
##

set -e

export NB_CORE=$SLURM_CPUS_ON_NODE # nb de processeurs alloués sur le noeud (spécifié par le parametre -n)
export OMP_NUM_THREADS=$NB_CORE  # limite du nombre thread à l'exécution
export OMP_THREAD_LIMIT=$NB_CORE # limite du nombre de thread pour l'ensemble du programme

module load deeptools/3.5.0
module load samtools/1.9
module load  bowtie2/2.3.5

#Path to your bam files
Map_Folders=/K/CHROCYC/sanchari/Alice_project/Mapping/bam
principaloutputDir=/K/CHROCYC/sanchari/Alice_project/Mapping/s3norm_bigwig

IFS=$'\n'


outputDir=$principaloutputDir

mkdir -p $outputDir
echo $outputDir

for f in $Map_Folders/*.bam; do
	bowtie_cmd="bamCoverage --bam $f -o $outputDir/`basename $f`.bed -of bedgraph -bs 10 -p 8  --minMappingQuality 30  -e  150"
	echo "Launching cmd : $bowtie_cmd"
	eval $bowtie_cmd
	d=$outputDir/`basename $f`.bed
	echo $d
	bowtie_cmd= "sort -k1,1 -k2,2n $d > $outputDir/sorted_`basename $d`"
	echo "Launching cmd : $bowtie_cmd"
	eval $bowtie_cmd
done

#bedtools unionbedg -i deeptools_clf_K27ac_1.bedgraph deeptools_col_K27ac_1.bedgraph deeptools_clf_K9ac_1.bedgraph  deeptools_Col_K9ac_1.bedgraph  >  ChIPseq_Arabi_4_combine
