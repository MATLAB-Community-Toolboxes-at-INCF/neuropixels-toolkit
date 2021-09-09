import sys
from ecephys_spike_sorting.scripts import create_input_json

def pyversion():
    print(sys.version_info)


def call_create_input_json():
    """
        Calling the ecephys_spike_sorting.scripts.create_input_json.creaetInputJson()
    """
    print("call_create_input_json")
    create_input_json.createInputJson()


def call_helper():
    """
        Calling ecephys_spike_sorting.scripts.helpers.*
    """
    print("call_helper")