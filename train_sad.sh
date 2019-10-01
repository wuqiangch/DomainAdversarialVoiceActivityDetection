#!/bin/bash
#$ -cwd
#$ -V
#$ -l 'gpu=1,mem_free=32g,ram_free=32g,hostname=b1[12345678]*|c*'
#$ -q *.q


if [ $# -ne 2 ]; then
    echo "Usage :"
    echo "./train.sh <experiment_dir> <protocol_name>"
    echo "Example : "
    echo "export EXPERIMENT_DIR=babytrain/multilabel"
    echo "sbatch train.sh ${EXPERIMENT_DIR} BabyTrain.SpeakerRole.JSALT"
    exit
fi

experiment_dir=$1
protocol=$2

echo "Began at $(date)"
export CUDA_VISIBLE_DEVICES=`free-gpu`
echo "Found GPU : $CUDA_VISIBLE_DEVICES"

export EXPERIMENT_DIR=$experiment_dir

# activate conda environment
source activate pyannote

# copy database.yml in experiment folder to keep log of everything
mkdir -p $EXPERIMENT_DIR/train/${protocol}.train
cp -r $HOME/.pyannote/database.yml $EXPERIMENT_DIR/train/${protocol}.train
pyannote-speech-detection train --gpu --to=200 ${EXPERIMENT_DIR} $protocol
echo "Done at $(date)"
