import os
from lvlup.Xls2xml import Xls2xml
from cpResources import cpResources
from Saxon import Saxon
import lvlup.test_mpx

xsl_dir = os.path.realpath (os.path.join (__file__,'../../xsl'))
emptympx = os.path.join (xsl_dir, 'leer.mpx')
joinColxsl = os.path.join (xsl_dir, 'joinCol.xsl')
lvlupxsl = os.path.join (xsl_dir, 'lupmpx2.xsl')

def cpRes (conf, in_fn, out_dir):
    rc = cpResources (in_fn)
    rc.freigegebene(out_dir, 'mulId.dateiname')

def join (conf, in_dir, target):
    print ('*Joining...')
    s = Saxon (conf['saxon'])
    if os.path.isdir (in_dir): 
        s.join (emptympx, joinColxsl, target)
    else:
        print (f"input dir '{in_dir}' does not exist")

def lvlup (conf, in_fn, output):
    """TODO: Replace with generic xsl plugin"""
    print ('*Levelling up...') #Syd says with 2l
    s = Saxon (conf['saxon'])
    if os.path.isfile(in_fn): 
        s.transform(in_fn, lvlupxsl, output)
    else:
        print (f"Input file missing {in_fn}") 

def mv2zero (conf, in_fn, dest_dir):
    #input is always first arg, but not needed here because Xls2xml 
    o = Xls2xml () # always expects input at *.xls 
    o.mv2zero(dest_dir)
    # logging? return message?
    
def testMpx (conf, in_fn):
    lvlup.test_mpx.main(in_fn)

def xls2xml (conf, in_dir, dest_dir): 
    o = Xls2xml ()
    o.transformAll (in_dir, dest_dir)

