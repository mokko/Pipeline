"""
Usage:
    xpath.py -i source.xml -x //some/xpath/expression
    xpath.py -i source.xml -x "//some/xpath/expression"
"""

import argparse
from lxml import etree

class xpath:
    def __init__ (self, in_fn, xpath): 
        NSMAP = {
            'mpx': 'http://www.mpx.org/mpx'
        }

        tree = etree.parse(in_fn)
        r = tree.xpath(xpath, nsmap=NSMAP)
        print (f"# results: {len(r)}") 
        for each in r:
            print (each)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Apply an xpath 1 expression to xml from commandline"
    )
    parser.add_argument(
        "-i",
        "--input",
        help="Path to input xml file",
        required=True,
    )

    parser.add_argument(
        "-x",
        "--xpath",
        help="xpath expression",
        required=True,
    )
    args = parser.parse_args()

    xpath(args.input, args.xpath)