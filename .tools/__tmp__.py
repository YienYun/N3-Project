from pathlib import Path
import sys
print('__file__:', __file__)
print('parents[1]:', Path(__file__).resolve().parents[1])
print('cwd:', Path('.').resolve())
