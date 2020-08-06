"""
Use google translate for the German to English translation for certain
fields: sachbegriff, titel, beschreibung, possibly others.

Let's write the translation into the excel file, so we can manually overwrite 
it. 

1. Let's write configuration information in existing conf:
        data2/generalvindex.conf
    specifically which sheets to act on -> 

    no -> let's just translate all sheets, but only empty English cells of course.

2. Let's write translations in translate.xlsx files
    scope/translate.xslx
    
    Let's not include this in the normal chain. Let's just think of this as script
    we execute when we need automatic translations
    
USAGE
    gtrans ..\translate.xslx
"""

from openpyxl import Workbook, load_workbook
from google.cloud import translate_v2 
from titlecase import titlecase
#import html no unescape necessary when using v2 format_ = text

class Gtrans:
    def __init__ (self, xls_fn):

        self.case = {
            "sachbegriffnot(@artSachb...": "lower",
            "titelnot(@artÜbersetzungengl.)": "title",
            "geogrBezug": "exclude"
        }
        self.xls_fn=xls_fn
        self.wb = load_workbook (filename = xls_fn)
        for sheet in self.wb.worksheets:
            print (f"*Working on {sheet.title}")
            self.translate(sheet)
            #self.wb.save(xls_fn)

    def translate (self, sheet):
        """Translate sheet

        Column A is DE, column B is EN
        Only fill in translation if there is none yet
        Save after every sheet.
        """
        
        if sheet.title in self.case.keys(): 
            if self.case[sheet.title] == "exclude":
                print (f"   exclude sheet '{sheet.title}' from google translation ")
                return
            elif self.case[sheet.title] == "lower":
                print ("   forcing lowercase")
            elif self.case[sheet.title] == "title":
                print ("   forcing Title Case")
        #tried V3 client (advanced), but then it gets complicated
        c=1 # 1-based line counter 
        for de in sheet['A']:
            if c != 1 and de.value is not None:
                en=sheet[f"B{c}"]
                if en.value is None:
                    en=self._translate_v2(de.value.strip())
                    if sheet.title in self.case.keys():
                        if self.case[sheet.title] == "lower":
                            en=en.lower()
                        elif self.case[sheet.title] == "title":
                            en=titlecase(en)
                    print(f"   {de.value} -> {en}")
                    sheet[f"B{c}"]=en
                    #without saving after every translation i get 403 User 
                    #Rate Limit Exceeded from Google occasionally
                    self.wb.save(self.xls_fn) 
            c+=1

    def _translate_v2 (self, de):
        if not hasattr(self, "client"):
            self.client = translate_v2.Client()

        result = self.client.translate (de, 
            source_language = "de", 
            target_language = "en",
            format_ = "text")
        return result['translatedText']

    def _translate_v3 (self, de):
        if not hasattr(self, "client"):
            from google.cloud import translate 
            self.client = translate.TranslationServiceClient()
        parent = client.location_path("96564610537", "global")

        response = client.translate_text(
            parent=parent,
            contents=de,
            mime_type="text/plain",
            source_language_code="de-DE",
            target_language_code="en-GB")
        # Display the translation for each input text provided
        for translation in response.translations:
            en=format(translation.translated_text)
            print(f"Translated text: {en}")
        return en

if __name__ == "__main__":
    import sys
    Gtrans (sys.argv[1])
