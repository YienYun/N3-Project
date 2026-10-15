"""Remove only the reviewed Auto Mutate controller and its UI call."""
import re


def strip_auto_mutate(runtime):
    for label in ('CONTROLLER', 'UI'):
        pattern = (r'^[\t ]*-- BEGIN AUTO MUTATE ' + label + r'\n.*?'
                   r'^[\t ]*-- END AUTO MUTATE ' + label + r'\n')
        if label == 'CONTROLLER':
            pattern += r'\n'
        runtime, count = re.subn(pattern, '', runtime, flags=re.M | re.S)
        assert count == 1, f'Expected one Auto Mutate {label} insertion, got {count}'
    return runtime
