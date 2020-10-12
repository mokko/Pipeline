"""
Using lxml to validate xml files on the command line.
USAGE
    validate.py bla.xml

1. Locate schemalocation. It's an attribute. It could be in root. There could be multiple, I guess
2. Parse schemaLocation
3. Using lxml load xml and xsd to memory
4. validate
"""

import os
from lxml import etree

#one dict that associates labels with their location to rule em all
lib = os.path.realpath(os.path.join(__file__,'../../lvlup'))

global_conf = {
    'lido': 'http://www.lido-schema.org/schema/v1.0/lido-v1.0.xsd',
}

global_conf['mpx']=os.path.join (lib, 'mpx20.xsd')

nsmap = { #currently unused
    'lido' 'http://www.lido-schema.org'
    'mpx': 'http://www.mpx.org/mpx',
    'xsd': 'http://www.w3.org/2001/XMLSchema-instance',
}

def validate (conf, in_fn, label=None):
    label = os.path.splitext(in_fn)[1][1:]
    #print (f"schema label {label}")
    if label in global_conf:
        print ('***Looking for xsd at %s...' % global_conf[label])
        schema_doc = etree.parse(global_conf[label])
    else:
        raise Exception ('Unknown schema')
    schema = etree.XMLSchema(schema_doc)
    #print ('*About to load input document...')
    doc = etree.parse(in_fn)
    schema.assert_(doc)
    print ('***VALIDATES OK')


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input', required=True)
    #parser.add_argument('-s', '--schema_label', required=True)
    args = parser.parse_args()
    validate ({}, args.input)
