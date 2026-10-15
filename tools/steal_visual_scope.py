"""Remove only reviewed presentation additions when checking protected gameplay."""
import re


def strip_builtin_visual(runtime):
    for label in ("STEAL VISUAL", "VISUAL DISGUISE GUARD", "VISUAL CONFIG", "VISUAL UI"):
        pattern = re.compile(
            r"^[\t ]*-- BEGIN BUILTIN " + label + r"\n.*?"
            r"^[\t ]*-- END BUILTIN " + label + r"\n",
            re.MULTILINE | re.DOTALL,
        )
        runtime = pattern.sub("", runtime)
    runtime = runtime.replace(
        " and not (Engine.IsSafeZoneVisual and Engine.IsSafeZoneVisual())", ""
    ).replace(
        " or (Engine.IsSafeZoneVisual and Engine.IsSafeZoneVisual())", ""
    )
    return runtime
