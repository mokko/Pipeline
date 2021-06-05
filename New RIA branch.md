Also was müssen wir mit MpApi jetzt tun?

Projektverzeichnis: C:\m3\MpApi\sdata\HFObjekte <-- vorgegeben
dann finde das neueste Projektverzeichnis
					C:\m3\MpApi\sdata\HFObjekte\20210519 <!-- neuestes Datum. 
Quelldateien:		C:\m3\MpApi\sdata\HFObjekte\20210519\*-clean-*.xml
SHF Ziel: 			...\20210519\2-SHF\M39-clean.npx.xml
					...\20210519\2-SHF\M39-clean-so.csv
					...\20210519\2-SHF\M39-clean-mm.csv
		
Wir könnten einfach Programm in diesem Verzeichnis starten. Dann brauchen wir es nicht 
programmatisch zu finden. Also gehe zu
	C:\m3\MpApi\sdata\HFObjekte\20210519

new programm is called ford 
1. finds
 C:\m3\MpApi\sdata\HFObjekte\20210519\*-clean-*.xml
2. applies zpx2npx.xsl to each and writes output to 2-SHF\M39-clean.npx.xml etc.
 Afrika-Ausstellung-clean-exhibit20226.xml
