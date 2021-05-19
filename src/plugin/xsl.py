import os
from Saxon import Saxon

xsl_dir = os.path.realpath(os.path.join(__file__, "../../xsl"))


def xsl(conf, in_fn, xsl, out_fn):
    print("*XSL Transform...")
    #    print (f"conf:{conf} in_fn:{in_fn}, xsl:{xsl}, out_fn:{out_fn}")
    s = Saxon(conf["saxon"])
    new_xsl = os.path.join(xsl_dir, xsl)
    s.transform(in_fn, new_xsl, out_fn)
