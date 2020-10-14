import os
import argparse
import re
from Pipeline import Pipeline
from lvlup.ExcelTool import ExcelTool
from lvlup.vok2vok import vok2vok

"""
COMMAND LINE USAGE

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

badger.py -c write      writes mpxvoc and vfix for all project for all projects
                        in the current working directory (overwriting vfix and
                        mpxvoc).
                        2-MPX/vfix.mpx (per project)
                        ../../mpxvoc.xml (one file for all projects)

badger.py -c pipe -p datenblatt 
                        executes pipeline command "datenblatt" for each 
                        current data dir. Will look for pide file in the same
                        dir as Pipeline.py. Internally changes directory.

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
    current data directories: only the newest of the project's data directories
        e.g. "AKu/Stu-Sam/20200910"
"""

#quick and dirty conf
vindexconf = "generalvindex.json" #expect it in cwd and its parent
in_vindex = os.path.join("2-MPX","levelup-sort.mpx")
in_trans = os.path.join("2-MPX","vfix.mpx")

class Badger:
    def __init__(self): pass

    def list (self):
        """
            Returns a dictionary that associates each project with the current 
            data directory.
        """
        current_projects = dict()
        projects = set() # use set for unique
        for root, dirs, files in os.walk(u"."):
            for each in dirs:
                if re.match("^\d{8}$", each):
                    projects.add (root)
        
        for project in projects:
            data_dirs=set()
            dirs = os.scandir(path=project)
            for item in dirs:
                if item.is_dir and re.match("^\d{8}$", item.name) :
                    data_dirs.add(item.path)
            current_projects[project] = max(data_dirs)
        return current_projects

    def pipe (self, job):
        adir=os.path.realpath(os.path.join(__file__,'..'))
        pide_fn = os.path.join(adir, 'jobs.pide')
        if not os.path.isfile (pide_fn):
            raise FileNotFoundError ("Pide file not found")
        cdd = self.list()
        savedPath = os.getcwd()
        for project in cdd:
            print (f"*PIPE {job} for project {project}")
            os.chdir(os.path.abspath(cdd[project]))
            print (f"*NEW DIR {os.getcwd()}")
            Pipeline(pide_fn, job)
            os.chdir(savedPath) # return to original path
            print (f"*NEW DIR {os.getcwd()}")

    def update_xlsx (self, types):
        """
            Create/update the two Excel files for all projects' current data 
            directories.
            
            We look for vindexconf in cwd and its parent.

            Let's not automatically update vindex.xlsx and translate.xlsx at 
            the same time, since our workflow necessitates to work on vindex
            manually before we do the translation. 
        """
        path2 = os.path.join('..', vindexconf)
        if os.path.isfile(vindexconf): 
            conf_fn = vindexconf
            out_dir ="." 
        elif os.path.isfile(path2):
            conf_fn = path2
            out_dir = ".."
        else: 
            raise ValueError ("Error: vindexconf not found!")

        cdd = self.list()

        #todo: set freq column to zero and save

        for project in cdd:
            if types == 'vindex':
                print (f'*UPDATING VINDEX for {cdd[project]}...')
                in_fn=os.path.join (cdd[project], in_vindex)
                ExcelTool.from_conf (conf_fn, in_fn, out_dir) 
            elif types == 'translation':
                print (f"*UPDATING TRANSLATION LIST from '{in_fn}'")
                in_fn=os.path.join (cdd[project], in_trans)
                ExcelTool.translate_from_conf (conf_fn, in_fn, out_dir)
            else:
                raise TypeError ("Unknown type")

    def write_to_XML (self): 
        print ("write")

#
#
#

if __name__ == '__main__': 
    parser = argparse.ArgumentParser(description='Manage vindex.xlsx and translate.xlsx in multiple projects')
    parser.add_argument('-c', '--cmd', help="Pick your command: list|upvindex|uptrans|toxml|pipe", required=True)
    parser.add_argument('-p', '--param', help="For pipe you need parameter.")
    args = parser.parse_args()

    def list_for_humans():
        """
            Human readable representation of projects and their current data 
            directories.
        """
        cdd = b.list()
        print ("PROJECT:CURRENT DATA DIRECTORY (as seen from current working directory)")
        for project in cdd:
            print (f"{project}: {cdd[project]}")

    b = Badger()
    if args.cmd.lower() == 'list': list_for_humans()
    elif args.cmd.lower() == 'pipe': b.pipe(args.param)
    elif args.cmd.lower() == 'upvindex': b.update_xlsx('vindex')
    elif args.cmd.lower() == 'uptrans': b.update_xlsx('translate')
    elif args.cmd.lower() == 'toxml': b.write_to_XML()
    else:
        raise TypeError("Error: Unknown command!")

