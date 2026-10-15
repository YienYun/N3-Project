"""Reverse only the seven marked Wisp insertion sites to the delivered Nitro runtime."""
import re

LABELS = ('CONTROLLER', 'UI', 'CANDIDATE', 'FLAGS', 'SORT', 'FUSE WRAP', 'FUSE RETURN')

def strip_wisp(runtime):
    for label in LABELS:
        pattern = (r'^[\t ]*-- BEGIN WISP ' + label + r'\n.*?'
                   r'^[\t ]*-- END WISP ' + label + r'\n')
        if label == 'CONTROLLER':
            pattern += r'\n'
        runtime, count = re.subn(pattern, '', runtime, flags=re.M | re.S)
        assert count == 1, f'Expected exactly one Wisp {label}, got {count}'
    return runtime
