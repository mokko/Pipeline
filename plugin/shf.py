from Npx2csv import Npx2csv
import test_shf

def npx2csv (conf, in_fn, out_dir): 
    Npx2csv (in_fn, out_dir)

def testShf (conf, in_fn, prev):
    test_shf.main(prev, in_fn)