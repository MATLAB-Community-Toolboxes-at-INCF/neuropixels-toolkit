#!/bin/bash

# Create a new conda environment with Python 3.9.0
conda create --name mat-spike-sort python=3.9.0 -y

# Activate the newly created conda environment
source activate mat-spike-sort

# Install required Python packages
python -m pip install --user numpy scipy matplotlib ipython jupyter pandas

# Install specific versions of other required packages
conda install -c conda-forge datalad -y
pip install networkx[default]
pip install MEArec
pip install scikit-learn
pip install spikeinterface==0.96.1

# Install git-annex using apt-get
sudo apt-get update
sudo apt-get install git-annex -y
