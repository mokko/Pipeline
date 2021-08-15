""" A very thin wrapper around Saxon that uses Python's subprocess

USAGE 
    s = Saxon(saxon_path) 
    s.transform (input, xsl, output)     # plain transform, creates output dir if necessary
    s.join (source, stylesheet, output)  # copies xsl temporarily to target dir 
                                         # before applying it
SAXON VERSION
    On Windows easiest way seems to be to use built for NET platform. Alternatively, this class 
    can also use the original Saxon in java. 

SEE ALSO
    transform -s:source -xsl:stylesheet -o:output

    https://www.saxonica.com/documentation/index.html#!using-xsl/commandline
"""

import os
import shutil
import subprocess
from pathlib import Path
from subprocess import Popen, PIPE


class Saxon:
    def __init__(self, saxon_path):
        if Path(saxon_path).exists():
            self.lib = saxon_path
        else:
            raise FileNotFoundError(f"Saxon not found at '{saxon_path}'!")

        self.report_fn = None
        if self.lib.endswith("Transform.exe"):
            self.type = ".net"
        else:
            self.type = "java"

    def join(self, src_fn, xsl, out_fn):
        """ 
            Join all lvl1 files into one big join file.
            Old version assumed that xsl is in out_dir; new version puts it in src_dir
        """

        if os.path.isfile(out_fn):  # only join if target doesn't exist yet
            print(f"{out_fn} exists already, no overwrite")
        else:
            out_dir = os.path.dirname(out_fn)
            src_dir = os.path.dirname(src_fn)
            xsl_base = os.path.basename(xsl)
            xsl_new = os.path.join(src_dir, xsl_base)
            #print(f"out_fn: {out_fn}")
            #print(f"orig xsl: {xsl}")
            #print(f"new xsl: {xsl_new}")
            shutil.copy(xsl, xsl_new)  # cp join xsl in same dir as *.xml
            self.transform(src_fn, xsl_new, out_fn)
            os.remove(xsl_new)

    def transform(self, source, stylesheet, output):
        """Like normal transform plus
        a) it makes the output dir if it doesn't exist already
        """

        output = os.path.realpath(output)
        out_dir = os.path.dirname(output)
        # print (f"******* OUTPUT {output}")

        if os.path.isfile(output):
            print(f"{output} exists already, no overwrite")
        else:
            if not os.path.isdir(out_dir):
                os.makedirs(out_dir)  # no chmod
            self._transform(source, stylesheet, output, self.report_fn)

    #
    # private
    #

    def _escapePath(self, path):
        """escape path w/ spaces"""

        return f'"{path}"'

    def _transform(self, source, stylesheet, output, report_fn=None):
        # source = os.path.abspath(source)
        source = self._escapePath(source)
        stylesheet = self._escapePath(stylesheet)
        output = self._escapePath(output)

        cmd = f"{self.lib} -s:{source} -xsl:{stylesheet} -o:{output}"
        if self.type == "java":
            cmd = f"java -Xmx1200m -jar {cmd}"
        print(cmd)
        # check=True:dies on error
        # https://stackoverflow.com/questions/89228
        if self.report_fn is None:
            #print ("no log file written")
            subprocess.run(
                cmd, check=True, stderr=subprocess.STDOUT
            )  # overwrites output file without saying anything
        else:
            print(f"*writing log file to {self.report_fn}")
            log = open(self.report_fn, mode="wb")
            with Popen(cmd, stdout=PIPE, stderr=subprocess.STDOUT) as proc:
                line = proc.stdout.read()
                print(line)
                log.write(line)
            # result = subprocess.run(cmd, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            # print (result.stderr)
            # print (result.stdout)


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Simplistic Saxon Command Line Front End")
    parser.add_argument("-l", "--lib", help="Saxon location")
    parser.add_argument("-s", "--source", help="input file")
    parser.add_argument("-x", "--xsl", help="xsl file")
    parser.add_argument("-o", "--output", help="ouput file")
    args = parser.parse_args()
    s = Saxon(args.lib)
    s.transform(args.source, args.xsl, args.output)