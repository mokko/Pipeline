from lvlup.Npx2csv import Npx2csv
from lvlup.test_shf import main
from lvlup.mdl import Mdl


def npx2csv(conf, in_fn, out_dir):
    Npx2csv(in_fn, out_dir)


def mdl(conf, in_fn, out_fn):
    m = Mdl(in_fn, out_fn)


def testShf(conf, in_fn, source):
    main(in_fn, source)
