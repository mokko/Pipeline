from lxml import etree
import argparse

def main (source_fn, dest_fn):
    test_identNr(dest_fn)
    test_hersteller(source_fn, dest_fn)
    test_künstler(source_fn, dest_fn)


'''Es soll keine DS ohne identNr geben'''
def test_identNr(xml_fn):
    tree = etree.parse(xml_fn)
    r = tree.xpath('/n:shf/n:sammlungsobjekt[not(n:identNr)]',namespaces={'n': 'http://www.mpx.org/npx'})
    #r should be empty
    if r:
        raise ValueError ('Es soll keine DS ohne identNr geben')
    #else:
    #    print ('all good')


def test_hersteller (source_xml, dest_xml):
    #Anzahl der Hersteller soll in mpx und npx gleich sein
    stree = etree.parse(source_xml)
    dtree = etree.parse(dest_xml)
    
    s = stree.xpath("/m:museumPlusExport/m:sammlungsobjekt/m:personenKörperschaften[@funktion = 'Hersteller']",namespaces={'m': 'http://www.mpx.org/mpx'})
    d = dtree.xpath('/n:shf/n:sammlungsobjekt/n:hersteller',namespaces={'n': 'http://www.mpx.org/npx'})
    if not len(s) == len(d):
        raise ValueError ('Unerwartete Anzahl von Herstellern')
    else:
        print ('Anzahl Hersteller %i' % len(s))


def test_künstler (source_xml, dest_xml):
    stree = etree.parse(source_xml)
    dtree = etree.parse(dest_xml)
    
    s = stree.xpath("/m:museumPlusExport/m:sammlungsobjekt/m:personenKörperschaften[@funktion = 'Künstler' or @funktion = 'Objektkünstler']"
        ,namespaces={'m': 'http://www.mpx.org/mpx'})
    d = dtree.xpath('/n:shf/n:sammlungsobjekt/n:künstler',namespaces={'n': 'http://www.mpx.org/npx'})
    #Anzahl der Künstler soll in mpx und npx gleich sein
    if not len(s) == len(d):
        raise ValueError ('Unerwartete Anzahl von Künstler %i %i' % (len(s), len(d)))
    else:
        print ('Anzahl Künstler %i' % len(s))



if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--source_fn', required=False)
    parser.add_argument('-d', '--dest_fn', required=True)
    args = parser.parse_args()

    main (args.source_fn, args.dest_fn)

    print ('Alles OK')

