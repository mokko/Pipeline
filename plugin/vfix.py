import os
from glob import glob
from shutil import copyfile
from lvlup.ExcelTool import ExcelTool
from lvlup.vok2vok import vok2vok

try:
    from Gtrans import Gtrans
except:
    pass


def vfix(conf, in_fn, conf_fn, out_dir, out_fn):
    if not os.path.isfile(conf_fn):
        raise ValueError(f"Error: vindexconf not found! {conf_fn}")

    update_xlsx(in_fn, conf_fn, out_dir)
    update_vfix(in_fn, conf_fn, out_dir, out_fn)
    # update translation list only after apply
    update_translations(conf_fn, in_fn, out_dir)


def gtrans(conf, inp):
    try:
        Gtrans("../translate.xlsx")  # translate sheets in translate
    except:
        print("Google translate not installed; omitting this step")


def vokvok(conf, input, src_dir, out):
    vok2vok(src_dir, out)  # work on new data2 dir


def cpData2(conf, imput):
    print(f"*Copying data for GITHUB")
    files = glob("../**/*.xlsx", recursive=True)
    for src in files:
        src = os.path.realpath(src)
        dst = src.replace("data", "data2", 1)
        if "bak\\" not in src.lower():
            # print (f"   {src} ")
            try:
                copyfile(src, dst)
            except Exception as e:
                print(e)

#
# private?
#
def update_xlsx(in_fn, conf_fn, out_dir):
    print("*Updating VINDEX...")
    t = ExcelTool(conf_fn, in_fn, out_dir)
    t.vindex_from_conf()


def update_vfix(in_fn, conf_fn, out_dir, out_fn):
    """ Use Vocabulary Index (aka the LIST) to fix mpx data"""

    if not os.path.exists(out_fn):
        print("*APPLYING FIX")
        t = ExcelTool(conf_fn, in_fn, out_dir)
        t.apply_fix(out_fn)


def update_translations(conf_fn, in_fn, out_dir):
    print(f"*Updating TRANSATION LIST from '{in_fn}'")
    t = ExcelTool(conf_fn, in_fn, out_dir)
    t.translate_from_conf(conf_fn, in_fn, out_dir)
