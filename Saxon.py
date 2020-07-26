""" A very thin wrapper around Saxon that uses Python's subprocess

USAGE 
    s=Saxon(saxon_path) 

    s.transform (input, xsl, output)     #plain transform, creates output dir if necessary
    s.join (source, stylesheet, output)  #apply joinCol.xsl to source and write result to output

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
#import sys
from subprocess import Popen, PIPE

class Saxon:
    def __init__ (self, saxon_path):
        self.lib = saxon_path 
        self.report_fn=None
        if self.lib.endswith('transform.exe'):
            self.type = '.net'
        else:
            self.type = 'java'

    def _transform (self, source, stylesheet, output, report_fn=None):
        source = self._escapePath(source)
        stylesheet = self._escapePath(stylesheet)
        output = self._escapePath(output)
        
        cmd = f"{self.lib} -s:{source} -xsl:{stylesheet} -o:{output}"
        if self.type == 'java':
            cmd = f"java -Xmx1024m -jar {cmd}"
        print (cmd)
        #check=True:dies on error
        #https://stackoverflow.com/questions/89228
        if self.report_fn is None:
            #print ("no log file written")
            subprocess.run (cmd, check=True, stderr=subprocess.STDOUT) # overwrites output file without saying anything
        else:
            print (f"*writing log file to {self.report_fn}")
            log = open(self.report_fn, mode='wb')
            with Popen(cmd, stdout=PIPE, stderr=subprocess.STDOUT) as proc:
                line = proc.stdout.read()
                print (line)
                log.write(line)
            #result = subprocess.run(cmd, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            #print (result.stderr)
            #print (result.stdout)

    def transform (self, source, stylesheet, output):
        """ Like normal transform plus 
         a) it makes the output dir if it doesn't exist already
        """

        output = os.path.realpath(output)
        out_dir = os.path.dirname (output) 

        if os.path.isfile(output):
            print ("%s exists already, no overwrite" % output)
        else:
            if not os.path.isdir(out_dir): 
                os.mkdir(out_dir) # no chmod
            self._transform (source, stylesheet, output, self.report_fn)

    def _escapePath (self, path): 
        """escape path w/ spaces"""

        return f'"{path}"'

    def join (self, source, stylesheet, output):
        """ Join all lvl1 files into one big join file"""

        if os.path.isfile(output): #only join if target doesn't exist yet
            print ("%s exists already, no overwrite" % output) 
        else:
            source=self._escapePath(self.lib+'/'+source)
            #if os.path.isfile(source):
            styleorig=self.lib+'/'+stylesheet
            targetdir=os.path.dirname(output)
            styletarget=targetdir+'/'+stylesheet
            print (f"orig: {styleorig}")
            print (f"target: {styletarget}")
            shutil.copy(styleorig, styletarget) # cp stylesheet in same dir as *.xml
            self.transform (source, self._escapePath(styletarget), self._escapePath(output))
            os.remove(styletarget)

if __name__ == "__main__": pass
