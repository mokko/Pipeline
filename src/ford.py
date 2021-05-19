import argparse
import os
import re
import sys
from pathlib import Path
adir = Path(__file__).parent
sys.path.append(str(adir))  # what the heck?
from Saxon import Saxon
from lvlup.Npx2csv import Npx2csv

saxon_path = "C:\m3\SaxonHE10-5J\saxon-he-10.5.jar"
zpx2mpx = "C:\m3\zpx2npx\zpx2npx.xsl"
class Ford:
    def __init__(self):
        #e.g. Afrika-Ausstellung-clean-exhibit20226.xml
        for file in Path().glob('*-clean-*.xml'):
            label = re.match("(.*)-clean-",str(file)).group(1)
            s = Saxon(saxon_path)
            out_fn = f"2-SHF/{label}-clean.npx.xml"
            s.transform(file, zpx2mpx, out_fn)
            #print ("About to write csv...")
            Npx2csv (file, label)
            
        
if __name__ == "__main__":
    Ford()
