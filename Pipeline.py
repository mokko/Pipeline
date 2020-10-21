"""
Pipeline - a basic Python pipeline system with XSLT

A pipeline is a series of commands executed one after the other. This pipeline
system writes the result of each step to disk and reads it again for the next
step. This process is slow, but transparent and good for debugging. 

A series of commands is either called pipeline or a job. Jobs can have names to
separate different jobs. Several jobs can be described in a single pipeline 
description file (pide) using a simple DSL, which emphasizes readability and 
should be fun to use.

See bin/pipe.py for command line frontend, this is the main class.

USAGE:
    p = Pipeline (config_fn, 'namedPipe')
    p.execute ('namedPipe')     # execute named pipe
    p.list ()                   # list all pipe names from config_fn

EXAMPLE PIPELINE DESCRIPTION
#output of previous step functions are input for next step by default
#this is a comment
#reserved keywords are input, import, conf 
#importlib                      #specify directory with custom plugins, todo
import mpx                      #import is not allowed as pipe name

mpx:                            #pipeline name (aka job name)
    input *.xlsx                #provide input
    mv2zero 0-IN                #1 mv all input files to zero (python / extension) 
    transform 1-XML/*.xlsx      #2 transform all xlsx input files to xml (python / extension)
    join 1-XML/join.xml         #3 alternative syntax 
"""

import importlib

# import errno
import os
import sys
from pprint import pprint

sys.path.append(os.path.realpath(os.path.join(__file__, "../../plugin")))
# can we import pipeline.plugin.mpx instead?


class Pipeline:
    def __init__(self, pide_fn, job, flag=None):
        self.parse_pide(pide_fn)
        # self.show()
        self.execute(job)

    def execute(self, job):
        """First import Python modules, then execute the pipe job by name."""

        for m in self.pide["import"]:
            # mod = importlib.import_module(m)
            importlib.import_module("plugin." + m)

        print(f"*EXECUTING JOB {job}")

        for cmd in self.pide[job]:
            if cmd[0].lower() == "input":  # implements keyword 'input'

                # print (f"**input {cmd[1]}")
                self.current = cmd[1]
                # if not os.path.isfile(cmd[1]):
                #    raise FileNotFoundError(errno.ENOENT,
                #        os.strerror(errno.ENOENT), cmd[1])
            else:  # regular command
                if "." in cmd[0]:
                    pkg, com = cmd[0].split(".")
                else:
                    pkg = job
                    com = cmd[0]
                # print(
                #   f"**pkg:{pkg} cmd:{com} conf:{self.pide['conf']} in:{self.current} args:{cmd[1:]}"
                # )
                # pkg.cmd (conf, input, output [, arg1, argN])
                pkg = f"plugin.{pkg}"
                getattr(sys.modules[pkg], com)(
                    self.pide["conf"], self.current, *cmd[1:]
                )
                self.current = cmd[-1]  # last arg (output) becomes input for next step

    def parse_pide(self, pide_fn):
        """Parse pide file.

        Hand-written python parser. Not worth it to deal with parsers, lexers
        and grammars."""

        print(f"*LOADING PIPELINE DESCRIPTION: {pide_fn}")
        self.pide = {"import": []}
        current_job = None
        with open(pide_fn, mode="r") as file:
            c = 0  # line counter
            error = 0
            for line in file:
                c += 1
                uncomment = line.split("#", 1)[0].strip()
                if not uncomment:
                    continue
                parts = uncomment.split()
                if parts[0] == "import":
                    if len(parts) > 2:
                        print(f"Import syntax error in line {c}")
                        error += 1
                    self.pide["import"].append(parts[1])

                elif parts[0] == "conf":
                    self.pide[parts[0]] = {parts[1]: " ".join(parts[2:])}

                elif parts[0].endswith(":"):  # named pipe = job label = job name
                    current_job = parts[0][:-1]
                    if not current_job in self.pide:
                        self.pide[current_job] = []
                    else:
                        raise ValueError("Job name not unique.")
                else:
                    if current_job is None:
                        print("Syntax Error")
                        error += 1
                    else:
                        # print (f"*{current_pipe}**{parts}")
                        self.pide[current_job].append(parts)
        if error > 0:
            raise SyntaxError

    def show(self):
        pprint(self.pide)


if __name__ == "__main__":
    import argparse

    """ 
    Pipeline - A Simple Python Pipeline Utility
    
    USAGE 
        pipe.py -p pipe.pide -j mpx -f flag
    
    A pipeline consists of a series of commands, much like a shell script. You
    can supply a simple and readable script to program your pipelines. 
    
    This pipeline comes with some xml and xslt via Saxon related commands. You 
    can easily supply your own commands as plugins.
    
    EXAMPLE PIPELINE DESCRIPTION (aka PIDE)
    import plugin
    conf saxon path/to/transform.exe
    
    mpx:
        input in.xml
        xsl bla.xsl out.xml
        xsl new.xsl out2.xml
    """
    parser = argparse.ArgumentParser(description="Pipeline plugin system with XSLT")
    parser.add_argument("-f", "--flag", help="Flag handed to pipeline parser")
    parser.add_argument("-j", "--job", help="Execute job by name", required=True)
    parser.add_argument(
        "-p", "--pipe", nargs="?", required=True, help="Location for pipeline file"
    )
    args = parser.parse_args()

    p = Pipeline(args.pipe, args.job, args.flag)
