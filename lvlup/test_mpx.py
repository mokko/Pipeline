from lxml import etree
import argparse

def main (mpx_fn):
    test_identNr(mpx_fn)
    test_mume_pfad(mpx_fn)
    test_kein_sachbegriff (mpx_fn)
    #standardbild_veröffentlichen (mpx_fn)
    anzahl_definitiver_STO (mpx_fn)
    
    #sto_inkongruenz (mpx_fn) sample data doesn't have definitive sto. Why?

def test_identNr(xml_fn):
    """Es soll keine DS ohne identNr geben"""
    tree = etree.parse(xml_fn)
    r = tree.xpath('/m:museumPlusExport/m:sammlungsobjekt[not(m:identNr)]',
        namespaces={'m': 'http://www.mpx.org/mpx'})
    #r should be empty
    if r:
        print  (F"Fehler: DS ohne identNr {r}")
    #else:
    #    print ('all good')

def test_kein_sachbegriff (xml_fn):
    """Schreibe Fehler, wenn DS keinen Sachbegriff hat"""
    tree = etree.parse(xml_fn)
    r = tree.xpath('/m:museumPlusExport/m:sammlungsobjekt[not(m:sachbegriff)]/@objId',
        namespaces={'m': 'http://www.mpx.org/mpx'})
    for fehler in r:
        print (f"Fehler: DS ohne sachbegriff {fehler}")

def test_mume_pfad (mpx_fn):
    """Fehler wenn Pfadangaben ausgefüllt ist, aber Dateiname oder Erweiterung 
    fehlt.
    """

    mpx = etree.parse(mpx_fn)
    s = mpx.xpath("/m:museumPlusExport/m:multimediaobjekt[m:pfadangabe]",
        namespaces={'m': 'http://www.mpx.org/mpx'})
    for mume in s:
        r1=mume.xpath ("m:dateiname",namespaces={'m': 'http://www.mpx.org/mpx'})
        r2=mume.xpath ("m:erweiterung",namespaces={'m': 'http://www.mpx.org/mpx'})
        e=[]
        if len(r1) <1 or len(r2) < 1:
            mulId=mume.xpath("@mulId")[0]
            e.append(mulId)
        if len(e) > 0:
            #raise ValueError (f"MM path incomplete: mulId {e}")
            print (f"WARNUNG: MM Pfad ist unvollständig: mulId {e}")


def standardbild_veröffentlichen (mpx_fn):
    """Warnung wenn Standardbild veröffentlichen nein hat. 
    
    Das kann gewollt sein, also nur Warnung kein Fehler. Standardbild ist 
    intern zu sehen, soll aber nicht exportiert werden. Dann fehlt allerdings
    ein Bild, also durchaus Grund zu meckern.
    """

    mpx = etree.parse(mpx_fn)
    s = mpx.xpath("/m:museumPlusExport/m:multimediaobjekt[m:standardbild]",
        namespaces={'m': 'http://www.mpx.org/mpx'})
    e=[]
    for mume in s:
        # since i can't do xpath 2.0 lower-case, use python instead
        veröff=mume.xpath ('m:veröffentlichen', 
            namespaces={'m': 'http://www.mpx.org/mpx'})
        if len(veröff)> 0:
            if veröff[0].text.lower() == "nein":
                mulId=mume.xpath ("@mulId")[0]
                e.append(mulId)
    if len(e) > 0:
        print (f"WARNUNG: Standardbild nicht freigegeben: mulId {e}")

def anzahl_definitiver_STO (mpx_fn):
    """Es soll nur je einen aktuellen und ständigen definitiven Standort geben. 
    """

    mpx = etree.parse(mpx_fn)
    r = mpx.xpath("/m:museumPlusExport/m:sammlungsobjekt[m:standort]",
        namespaces={'m': 'http://www.mpx.org/mpx'})
    e=[]
    for so in r:
        objId=so.xpath ("@objId")[0]
        sto_s=so.xpath ("m:standort[@status = 'Definitiv' and @art = 'Ständiger Standort']",
            namespaces={'m': 'http://www.mpx.org/mpx'})
        sto_a=so.xpath ("m:standort[@status = 'Definitiv' and @art = 'Aktueller Standort']",
            namespaces={'m': 'http://www.mpx.org/mpx'})
        if len(sto_a) > 1 or len(sto_s) > 1:
            e.append(objId)
    if len(e) > 0:
        raise ValueError (f"Mehr als ein ständiger oder aktueller Standort {q}")

def sto_inkongruenz (mpx_fn):
    """Aktueller STO soll mit dem definitiven aktuellen STO aus 
    Standortgeschichte übereinstimmen; analog für ständiger STO.
    
    TODO
    """

    mpx = etree.parse(mpx_fn)
    r = mpx.xpath("/m:museumPlusExport/m:sammlungsobjekt",
        namespaces={'m': 'http://www.mpx.org/mpx'})
    e=[]
    for so in r:
        objId=so.xpath ("@objId")[0]
        print(objId)
        #aktueller Standort
        nodes=so.xpath('m:aktuellerStandort',
            namespaces={'m': 'http://www.mpx.org/mpx'})
        for n in nodes:
            aktSto=n.text
            print (f"\taktuellerStandort: {aktSto}")

        nodes=so.xpath ("m:standort[@status = 'Definitiv' and @art = 'Aktueller Standort']",
            namespaces={'m': 'http://www.mpx.org/mpx'})
        for n in nodes:
            stoge_akt=f"{n.text} / {n.xpath ('@detail')[0]}"
            print (f"\tSTOGE AKTUELLER :  {stoge_akt}")

        #Ständiger Standort
        nodes=so.xpath('m:ständigerStandort',
            namespaces={'m': 'http://www.mpx.org/mpx'})
        for n in nodes:
            stoge_st=n.text
            print (f"\tständigerStandort: {stoge_st}")
             
        nodes=so.xpath ("m:standort[@status = 'Definitiv' and @art = 'Ständiger Standort']",
            namespaces={'m': 'http://www.mpx.org/mpx'})
        for n in nodes:
            stoge_akt=f"{n.text} / {n.xpath ('@detail')[0]}"
            print (f"\tSTOGE STÄNDIGER :  {stoge_akt}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-m', '--mpx_fn', required=True)
    args = parser.parse_args()

    main (args.mpx_fn)

    print ('mpx OK')

