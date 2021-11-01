import sys
import os
import subprocess

# pipeline modules are using relative importing
# so using sys.path hack here
from ecephys_spike_sorting import scripts
sys.path.append(os.path.dirname(scripts.__file__))

# import createInputJson for pipeline config
# this way users can see function args by py.help in matlab
from ecephys_spike_sorting.scripts.create_input_json import createInputJson

## uncomment if needs to run legacy_launch.m
# from ecephys_spike_sorting.scripts.helpers.SpikeGLX_utils import ParseProbeStr, ParseTrigStr
# from ecephys_spike_sorting.scripts.helpers.run_one_probe import runOne
# from ecephys_spike_sorting.scripts.helpers.log_from_json import writeHeader

def call_python(params):
    command = sys.executable + ' ' + params
    subprocess.check_call(command.split(' '))

