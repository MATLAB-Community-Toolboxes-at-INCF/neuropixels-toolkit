import sys
import os
from ecephys_spike_sorting import scripts
sys.path.append(os.path.dirname(scripts.__file__))
from ecephys_spike_sorting.scripts.create_input_json import createInputJson

def pyversion():
    print(sys.version_info)


def call_create_input_json(*args, **kwargs):
    """
        Calling the ecephys_spike_sorting.scripts.create_input_json.creaetInputJson()
    """
    createInputJson(*args, **kwargs)


def call_helper():
    """
        Calling ecephys_spike_sorting.scripts.helpers.*
    """
    print("call_helper")