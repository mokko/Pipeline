from lvlup.Npx2csv import Npx2csv
import lvlup.test_shf
import lvlup.mdl

def npx2csv (conf, in_fn, out_dir): 
    Npx2csv (in_fn, out_dir)

def mdl (conf, in_fn, out_fn):
    m = Mdl (in_fn, out_fn)

def testShf (conf, in_fn, prev):
    test_shf.main(prev, in_fn)
    
