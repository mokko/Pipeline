""" class that copies resources listed in xml to a destination directory

- expects sourceXml to be mpx
- writes a log with encountered problems into outdir/YYMMDD.report.log 

USAGE
 rc = ResourceCp (mpx)
 #loop thru mume implicitly
 #factor1: outdir
 #factor2: out_fn
 #factor3: selection of mume records to be exported
 
 rc.standardbilder ('pix', 'mulId.dateiname')
 rc.freigegebene ('pix', 'mulId.dateiname')
 rc.freigegebene ('pix_ln', 'mulId', 'link')
 rc.tifs (outdir, 'muilId.origname')
 

Sloppy Update:
    ResourceCp used to copy files only when outdir didn't exist; now it copies
    resources as long as target file doesn't exist. There is no overwriting
    of old file in case resource has changed. 
    Also files deleted from sourceXML are not deleted from cache directory.
    Currently, you need to manually delete the respective cache directories 
    to trigger the creation of an up-to-date cache.
"""

import xml.etree.ElementTree as ET
import os
import sys
import shutil
import datetime
import logging

_verbose = 1


def verbose(msg):
    if _verbose:
        print(msg)


class cpResources:
    def __init__(self, sourceXml):
        # load XML
        self.tree = ET.parse(sourceXml)
        # verbose ('FOUND ' + sourceXml)

        self.ns = {
            "mpx": "http://www.mpx.org/mpx",
        }

    def freigegebene(self, outdir, pattern):
        """Copy approved resources to outdir/pattern.ext.

        freigegeben are only those photos that are both a) not Standardbilder
        and b) have mpx:veröffentlichen = ja"""

        self._init_log(outdir)
        logging.debug("RUN freigegebene")

        for mume in self.tree.findall("./mpx:multimediaobjekt", self.ns):
            fg = mume.find("mpx:veröffentlichen", self.ns)

            if fg is not None:
                if fg.text.lower() == "ja":
                    old_path, new_path = self._out_fn(mume, outdir, pattern)
                    # print (f"***{old_path}")
                    try:
                        self._cpFile(old_path, new_path)
                    except:
                        logging.debug(f"File not found: {old_path}")
            else: pass
                # print("record has no mpx:veröffentlichen!")

    def tifs(self, outdir, pattern):
        """Copy tifs based on identNr to outdir/pattern.ext.

        Not sure if I should put this is ResourceCp. Right now it's in
        TIFFinder.py"""

        pass

    def boris_test(self, outdir):
        """Test all resources with a path for dead links.

        Only jpg, tif, tiff, jpeg extensions are treated."""

        if os.path.isdir(outdir):  # anything to do at all?
            print(
                outdir + " exists already, nothing tested"
            )  # this message is not important enough for logger
            return
        os.makedirs(outdir)
        self._init_log(outdir)

        needles = ["jpg", "jpeg", "tif", "tiff"]
        for mume in self.tree.findall("./mpx:multimediaobjekt", self.ns):
            try:
                erw = mume.find("mpx:erweiterung", self.ns).text
            except:
                pass  # really nothing to do
            else:
                mulId = mume.get(
                    "mulId", self.ns
                )  # might be ok to assume it always exists
                # print ('Testing mulId %s %s' % (mulId, erw))
                for each in needles:
                    if each == erw.lower():
                        path = self._fullpath(mume)  # will log incomplete path
                        if path is not None:
                            if not os.path.isfile(path):
                                logging.debug(f"{mulId}: {path}: Datei nicht am Ort")

    ###############
    #PRIVATE STUFF#
    ###############

    def _cpFile(self, in_path, out_path):
        """cp file to out_path while reporting missing files

        If out_path exists already, overwrite only if source is newer than target."""

        # print (f"Working on {in_path}")
        if not os.path.exists(in_path):
            logging.debug(f"Source file not found: {in_path}")
            return
        if os.path.exists(out_path):
            # overwrite ONLY if source is newer
            # print (f"outfile exists already {out_path}")
            if os.path.getmtime(out_path) > os.path.getmtime(out_path):
                self._cpFile2(in_path, out_path)
        else:
            self._cpFile2(in_path, out_path)

    def _cpFile2(self, in_path, out_path):
        # print (in_path +'->'+out_path)
        # shutil.copy doesn't seem to raise exception if source file not found
        # print (f"cpFile2: {in_path} -> {out_path}")
        try:
            # copy2 preserves file info
            shutil.copy2(in_path, out_path)
        except:
            print(f"Unexpected error: {sys.exc_info()[0]}")

    def _fullpath(self, mume):
        """Expects multimediaobjekt node and returns full mume path.

        If path has no pfadangabe or dateiname it writes an error message to
        logfile and returns None"""

        error = 0
        mulId = mume.get("mulId", self.ns)  # might be ok to assume it always exists
        try:
            pfad = mume.find("mpx:pfadangabe", self.ns).text
        except:
            logging.error (f"mulId-{mulId}: No mpx:pfadangabe")
            error += 1
        try:
            erw = mume.find("mpx:erweiterung", self.ns).text
        except:
            logging.error (f"mulId-{mulId}: No mpx:erweiterung")
            error += 1
        try:
            datei = mume.find("mpx:dateiname", self.ns).text
        except:
            logging.error (f"mulId-{mulId}: No mpx:dateiname")
            error += 1

        if error > 0:
            return None
        return f"{pfad}\{datei}.{erw}"

    def _init_log(self, outdir):
        if not os.path.isdir(outdir):
            os.makedirs(outdir)
        # line buffer so everything gets written when it's written
        # so CTRL+C ends the program
        today = datetime.date.today()
        log_fn = os.path.join(outdir, today.strftime("%Y%m%d.report.log"))
        logging.basicConfig(
            datefmt="%I:%M:%S %p",
            filename=log_fn,
            filemode="w",
            level=logging.DEBUG,
            format="%(asctime)s: %(message)s",
        )


    def _out_fn(self, mume, outdir, pattern):
        old = self._fullpath(mume)
        if old is not None:
            print (f"{old}")
            ls = pattern.split(".")
            out = []
            for each in ls:
                if each == "mulId":
                    out.append(mume.get("mulId", self.ns))
                if each == "objId":
                    out.append(mume.find("mpx:verknüpftesObjekt", self.ns).text)
                if each == "dateiname":
                    out.append(mume.find("mpx:dateiname", self.ns).text)
            # always implicitly add lower-cased file extension.
            out.append(mume.find("mpx:erweiterung", self.ns).text.lower())
            fn = ".".join(out)
            new = os.path.join(outdir, fn)
            # print (f"{pattern}:::::{old} ->{new}")
            return old, new
        else:
            return None, None


if __name__ == "__main__":
    c = cpResources("2-MPX/levelup.mpx")
    c.freigegebene("../pix", "mulId.dateiname")
