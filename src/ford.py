"""
Automation for npx.

This little script is supposed to grow with time.
"""

import argparse
import os
import re
import sys
from pathlib import Path
from lxml import etree
adir = Path(__file__).parent
sys.path.append(str(adir))  # what the heck?
from Saxon import Saxon
from lvlup.Npx2csv import Npx2csv

saxon_path = "C:\m3\SaxonHE10-5J\saxon-he-10.5.jar"
zpx2mpx = "C:\m3\zpx2npx\zpx2npx.xsl"
ETparser = etree.XMLParser(remove_blank_text=True)

NSMAP = {"n":"http://www.mpx.org/npx"}

class Ford:
    def __init__(self):
        #e.g. Afrika-Ausstellung-clean-exhibit20226.xml
        npxL = list()
        for file in Path().glob('*-clean-*.xml'):
            label = re.match("(.*)-clean-",str(file)).group(1)
            s = Saxon(saxon_path)
            npx_fn = f"2-SHF/{label}-clean.npx.xml"
            s.transform(file, zpx2mpx, npx_fn)
            npxL.append(npx_fn)
        ET = self.join(inL=npxL)

        label = str(Path(".").resolve().parent.name)
        date = str(Path(".").resolve().name)
        package_npx = Path(f"2-SHF/{label}{date}.npx.xml")
        print(f"About to write join to {package_npx}")
        self.ETtoFile(ET=ET, path=package_npx) # overwrites existing file

        print ("About to write csv...")
        Npx2csv (package_npx, f"2-SHF/{label}{date}")

    def join(self, *, inL):
        firstET = None
        for file in inL:
            print(f"joining {file}")
            ET = etree.parse(str(file), ETparser)
            if firstET is None:
                firstET = ET
            else:
                rootN = firstET.xpath("/n:npx",namespaces=NSMAP)[0]
                itemsL = ET.xpath("/n:npx/n:*", namespaces=NSMAP)
                if len(itemsL) > 0:
                    for newItemN in itemsL:
                        rootN.append(newItemN)
                        print(newItemN)
        return firstET
        
    def ETtoFile(self, *, ET, path):
        #tree = etree.ElementTree(ET)
        ET.write(
            str(path), pretty_print=True, encoding="UTF-8"
        ) 

if __name__ == "__main__":
    Ford()
