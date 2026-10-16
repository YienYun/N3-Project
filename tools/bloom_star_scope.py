"""Reverse only reviewed Butterfly/Star insertions; never replace historical hashes."""
import re

LABELS = ('CONTROLLER', 'UI', 'TRANSIT OWNER', 'TRANSIT CLEANUP', 'TRANSIT CONTROL',
          'TRANSIT SELECTION', 'WISP PRIORITY', 'BANJO PRIORITY', 'MUTATE PRIORITY')
ORIGINAL_OWNER = '\t\tassert(owner == "wisp" or owner == "banjo", "Quest transport owner required")\n'


def strip_bloom_star(runtime):
    for label in LABELS:
        pattern = (r'^[\t ]*-- BEGIN BLOOM STAR ' + label + r'\n.*?'
                   r'^[\t ]*-- END BLOOM STAR ' + label + r'\n')
        if label == 'CONTROLLER':
            pattern += r'\n'
        replacement = ORIGINAL_OWNER if label == 'TRANSIT OWNER' else ''
        runtime, count = re.subn(pattern, lambda match: replacement, runtime, flags=re.M | re.S)
        assert count == 1, f'Expected exactly one reviewed Bloom/Star {label}, got {count}'
    return runtime
