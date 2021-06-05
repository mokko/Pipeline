import sys
from pathlib import Path
adir = Path(__file__).parent
sys.path.append(str(adir))  # what the heck?
from Saxon import Saxon

saxon_path = "C:\m3\SaxonHE10-5J\saxon-he-10.5.jar"

adate = str(Path.cwd().name)
label = str(Path.cwd().parent.name)

s = Saxon(saxon_path)
out_fn = f"{label}{adate}.zpx"

s.join (list(Path(".").glob("*-clean-*.xml"))[0], "C:/m3/Pipeline/src/xsl/join-zpx.xsl", out_fn)
