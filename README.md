## Pipeline
pipeline for xslt and python plugins

For us a pipleline is a combination of several consecutive steps in a 
controlled way, much like a shell script. Each step has an input, 
parameters, output 

Default behavior is to take output from previous step as input for the next 
step.

You can write your own python plugins 

The pipeline is described in a pide file (pipeline description) which is 
equivalent to a shell script.

Our requirements were
- named pipelines
- easy linking of output to next input
- good readability
- transparency: explicit is better than implicit
- xsl and python plugins/steps

#PIDE FORMAT DEFINITION
reserved keywords: import, input, conf
commands can be qualified or unqualified
- unqualified: command assumes that job name functions as package
- qualified: package.command, e.g. xsl.transform 
Commands cannot have periods  

conf key value; N.B. the value preserves spaces (except at the end of the line)
