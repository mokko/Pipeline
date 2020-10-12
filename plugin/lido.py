import os
import glob
from Saxon import Saxon

def mk_html (conf, indir, outdir):
    """
    current problems: 
    - this step is in string order, not numeric objId
    objId/12345789
    - it's pretty slow to transform individual lido files like this, since
    I fire up separate a saxon process for every lido file
    """
    s = Saxon (conf['saxon'])
    xsl_fn = os.path.realpath(os.path.join(__file__,'../../xsl', 'lido2html.xsl'))
    for path in glob.iglob(indir + '/*.lido', recursive=True):
        base = os.path.basename(path)
        new = os.path.join(outdir,f"{base}.html")
        if not os.path.exists(new) is True:
            s.dirTransform(path, xsl_fn, new) 
