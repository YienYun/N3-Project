"""Remove only the four marked Lab stock insertion sites for baseline checks."""
import re


def strip_lab_stock(runtime):
    for label in ('CONTROLLER', 'HOLDBACK', 'TARGET', 'UI'):
        pattern = (r'^[\t ]*-- BEGIN LAB STOCK ' + label + r'\n.*?'
                   r'^[\t ]*-- END LAB STOCK ' + label + r'\n')
        if label == 'CONTROLLER':
            pattern += r'\n'
        runtime, count = re.subn(pattern, '', runtime, flags=re.M | re.S)
        assert count == 1, f'Expected one Lab stock {label} insertion, got {count}'
    return runtime
