"""Remove only the reviewed Nitro refill insertions, including its race-shop gate."""
import re


SHOP_HOOK = (
    '\t\t-- BEGIN NITRO REFILL SHOP HOOK\n'
    '\t\tif name == "RF/RaceRally/AskBuy" and Tasks.InvokeRaceShopPurchase then\n'
    '\t\t\treturn Tasks.InvokeRaceShopPurchase("race", ...)\n'
    '\t\tend\n'
    '\t\t-- END NITRO REFILL SHOP HOOK\n'
)


def strip_nitro_shop_hook(runtime):
    assert runtime.count('-- BEGIN NITRO REFILL SHOP HOOK') == 1
    assert runtime.count('-- END NITRO REFILL SHOP HOOK') == 1
    assert runtime.count(SHOP_HOOK) == 1, 'Race shop gate differs from the exact reviewed hook'
    return runtime.replace(SHOP_HOOK, '', 1)


def strip_nitro_refill(runtime):
    runtime = strip_nitro_shop_hook(runtime)
    for label in ('CONTROLLER', 'UI', 'TICK'):
        pattern = (r'^[\t ]*-- BEGIN NITRO REFILL ' + label + r'\n.*?'
                   r'^[\t ]*-- END NITRO REFILL ' + label + r'\n')
        if label == 'CONTROLLER':
            pattern += r'\n'
        runtime, count = re.subn(pattern, '', runtime, flags=re.M | re.S)
        assert count == 1, f'Expected one Nitro {label} insertion, got {count}'
    return runtime
