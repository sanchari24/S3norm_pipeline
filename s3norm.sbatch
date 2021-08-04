#!/bin/bash
# Generic macs2
#
#SBATCH -J S3_norm_part1 # le nom de votre job
#SBATCH -p All # la partition
#SBATCH -n 8 # nombre de processeurs
#SBATCH -N 1 # nombre de noeuds, DO NOT CHANGE THIS SETTING
#SBATCH --mem 60000 # mémoire (en MB)

#SBATCH -o /K/CHROCYC/sanchari/Alice_project/slurm/chip_alice.%j.o # la sortie standard
#SBATCH -e /K/CHROCYC/sanchari/Alice_project/slurm/chip_alice.%j.e # la sortie erreur standard
#SBATCH --mail-type=END # notification par e-mail à la fin en cas de réussite ou erreur
#SBATCH --mail-user=sanchari.sircar@u-psud.fr # l’adresse e-mail

set -e

export NB_CORE=$SLURM_CPUS_ON_NODE # nb de processeurs alloués sur le noeud (spécifié par le parametre -n)
export OMP_NUM_THREADS=$NB_CORE  # limite du nombre thread à l'exécution
export OMP_THREAD_LIMIT=$NB_CORE # limite du nombre de thread pour l'ensemble du programme
script_directory='/ips2/users/ssircar/cluster/S3norm'
working_directory='/K/CHROCYC/sanchari/Alice_project/Mapping/s3norm_bigwig'
module load bedtools2/2.28.0
module load R/3.6.2
module load conda
conda activate s3norm
cmd="time python /ips2/users/ssircar/cluster/S3norm/src/s3norm_pipeline.py -s $script_directory'/src' -t file_list.txt"
echo $cmd
eval $cmd
