import os
import argparse
import re
from Pipeline import Pipeline
from lvlup.ExcelTool import ExcelTool
from lvlup.vocvoc import vocvoc

"""
COMMAND LINE USAGE

badger.py -c del -p 3\vfix.lido in all current data directories, delete this file

badger.py -c fixmpx     writes new vfix for each current project data directory 
                        (overwriting previous vfix.mpx files).

badger.py -c list       list all projects

badger.py -c upvindex   Creates/updates vindex.xlsx  for all projects in the
                        current working directory.
                        Input comes from 2-MPX/levelup-sort.mpx. Output is one
                        vindex.xlsx in same dir as generalvindex.json.
                        
badger.py -c uptrans    Creates/updates translate.xlsx for all projects in the
                        current working directory.
                        Expect info in 2-MPX/vfix.mpx and writes to
                        one common translate.xlsx (located in same dir as
                        generalvindex.json) 

badger.py -c vocvoc     from translation.xslx write new ../../mpxvoc.xml (one 
                        file for all projects)

badger.py -c pipe -p datenblatt 
                        executes pipeline command "datenblatt" for each 
                        current data dir. Will look for pide file in the same
                        dir as Pipeline.py. Internally changes directory.

badger.py -c writeback  series of the following commands, which updates everything:
                        - del 3/vfix.lido 
                        - del 3/vfix.lido-datenblatt.html 
                        - vovvoc
                        - fixmpx
                        - pipe lido

Note: badger.py looks for the projects' data directories relative to the 
current working directory.

Example directories
    AKu/Stu-Sam/20200909
    AKu/Stu-Sam/20200910
    EM/SM-Afrika/20200909

Terms
    project or project directory
        e.g. "AKu/Stu-Sam": a project describes a fairly consistent object group 
        (one which remains fairly consistent over multiple exports)
    data directory: all directories named with a 8-digit date
        e.g. "AKu/Stu-Sam/20200910". They contain the data from one export. 
    current data directory: only the newest of the project's data directories
        e.g. "AKu/Stu-Sam/20200910"
"""

# quick and dirty conf
vindexconf = "generalvindex.json"  # expect it in cwd and its parent
in_vindex = os.path.join("2-MPX", "levelup-sort.mpx")
in_vfix = os.path.join("2-MPX", "vfix.mpx")
in_trans = "translate.xlsx"


class Badger:
    def __init__(self):
        path2 = os.path.join("..", vindexconf)
        if os.path.isfile(vindexconf):
            self.conf_fn = vindexconf
            self.out_dir = "."
        elif os.path.isfile(path2):
            self.conf_fn = path2
            self.out_dir = ".."
        else:
            raise ValueError("Error: vindexconf not found!")
        # built-in paths are bad, bad, bad...
        self.trans_fn = os.path.join(self.out_dir, "translate.xslx")
        self.mpxvoc_fn = os.path.join(__file__, "..", "data", "mpxvoc.xml")

    def delete(self, file):
        cdd = self.list()
        for project in cdd:
            path = os.path.realpath(os.path.join(cdd[project], file))
            print(f"*Delete {path}")
            try:
                os.remove(path)
            except:
                print(f"WARNING: File not found!")

    def fix_mpx(self):
        cdd = self.list()
        for project in cdd:
            print(f"*FIXING MPX FOR {project}")
            in_fn = os.path.join(cdd[project], in_vindex)
            vfix_fn = os.path.join(cdd[project], in_vfix)
            t = ExcelTool(self.conf_fn, in_fn, self.out_dir)
            t.apply_fix(vfix_fn)

    def list(self):
        """
        Returns a dictionary that associates each project with the current
        data directory. Directories with the name "IGNORE" are processed.
        """
        current_projects = dict()
        projects = set()  # use set for unique
        for root, dirs, files in os.walk("."):
            if "IGNORE" in root.split(os.sep):
                # print (f"***ignored: {root}")
                continue  # not next()
            for adir in dirs:
                if re.match("^\d{8}$", adir):
                    projects.add(root)

        for project in projects:
            data_dirs = set()
            dirs = os.scandir(path=project)
            for item in dirs:
                if item.is_dir and re.match("^\d{8}$", item.name):
                    data_dirs.add(item.path)
            current_projects[project] = max(data_dirs)
        return current_projects

    def pipe(self, job):
        adir = os.path.realpath(os.path.join(__file__, ".."))
        pide_fn = os.path.join(adir, "jobs.pide")
        if not os.path.isfile(pide_fn):
            raise FileNotFoundError("Pide file not found")
        cdd = self.list()
        savedPath = os.getcwd()
        for project in cdd:
            print(f"*PIPE {job} for project {project}")
            os.chdir(os.path.abspath(cdd[project]))
            # print(f"*NEW DIR {os.getcwd()}")
            Pipeline(pide_fn, job)
            os.chdir(savedPath)  # return to original path
            # print(f"*NEW DIR {os.getcwd()}")

    def update_xlsx(self, types):
        """
        Create/update the two Excel files for all projects' current data
        directories.

        We look for vindexconf in cwd and its parent.

        Let's not automatically update vindex.xlsx and translate.xlsx at
        the same time, since our workflow necessitates to work on vindex
        manually before we do the translation.
        """

        reset_freq = True
        cdd = self.list()
        for project in cdd:
            if types == "vindex":
                print(f"*UPDATING VINDEX for {cdd[project]}...")
                in_fn = os.path.join(cdd[project], in_vindex)
                t = ExcelTool(self.conf_fn, in_fn, self.out_dir)
                if reset_freq:
                    t.reset_freq("vindex")
                    reset_freq = False
                t.vindex_from_conf()
            elif types == "translate":
                in_fn = os.path.join(cdd[project], in_vfix)
                print(f"*UPDATING TRANSLATION LIST from '{in_fn}'")
                t = ExcelTool(self.conf_fn, in_fn, self.out_dir)
                if reset_freq:
                    t.reset_freq("translate")
                    reset_freq = False
                t.translate_from_conf()
            else:
                raise TypeError("Unknown type")

    def vocvoc(self):
        print(f"*Writing new mpxvoc.xml from translation.xlsx directly to data dir")
        t = vocvoc(in_trans)
        t.single(self.mpxvoc_fn)

    def writeback(self):
        self.delete("3/vfix.lido")
        self.delete("3/vfix.lido-datenblatt.html")
        self.vocvoc()
        self.fix_mpx()
        self.pipe("lido")


#
#

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Manage vindex.xlsx and translate.xlsx in multiple projects"
    )
    parser.add_argument(
        "-c",
        "--cmd",
        help="Pick your command: del|fixmpx|list|pipe|upvindex|uptrans|vocvoc",
        required=True,
    )
    parser.add_argument("-p", "--param", help="For pipe you need parameter.")
    args = parser.parse_args()

    def list_for_humans():
        """
        Human readable representation of projects and their current data
        directories.
        """
        cdd = b.list()
        print("PROJECT:CURRENT DATA DIRECTORY (as seen from current working directory)")
        for project in cdd:
            print(f"{project}: {cdd[project]}")

    b = Badger()
    if args.cmd.lower() == "del":
        b.delete(args.param)
    elif args.cmd.lower() == "fixmpx":
        b.fix_mpx()
    elif args.cmd.lower() == "list":
        list_for_humans()
    elif args.cmd.lower() == "pipe":
        b.pipe(args.param)
    elif args.cmd.lower() == "upvindex":
        b.update_xlsx("vindex")
    elif args.cmd.lower() == "uptrans":
        b.update_xlsx("translate")
    elif args.cmd.lower() == "vocvoc":
        b.vocvoc()
    elif args.cmd.lower() == "writeback":
        b.writeback()
    else:
        raise TypeError("Error: Unknown command!")
