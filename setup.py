from setuptools import setup, find_packages

setup(
    name='spike_sort',
    version='0.0.1',
    packages=find_packages(include=['spike_sort']),
    install_requires=[
        'numpy',
        'scipy',
        'matplotlib',
        'ipython',
        'jupyter',
        'pandas',
        'datalad',
        'networkx[default]',
        'MEArec',
        'scikit-learn',
        'spikeinterface==0.96.1'
    ]
)
