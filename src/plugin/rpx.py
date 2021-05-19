from pathlib import Path
from Saxon import Saxon

xsl_dir = Path(__file__).joinpath("../../xsl").resolve(strict=True)
emptyMpx = xsl_dir.joinpath("leer.mpx")
joinColXsl = xsl_dir.joinpath("joinRpx.xsl")

def join(conf, in_dir, target):
    print("*Joining...")
    s = Saxon(conf["saxon"])
    s.join(emptyMpx, joinColXsl, target)
