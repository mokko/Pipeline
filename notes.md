Wer ist/sind die Nutzer des ExcelTools?
Also beim ersten Mal habe ich ExcelTool für Kurator*innen geschrieben. Wenn 
aber schon Nicole Kling das Excel-Tool nicht benutzen kann, können das die
Kurator*innen erst Recht nicht.

Also ist ein Spezialist der Benutzer des ExcelTools. Der Spezialist hat ein
Interesse nicht für jeden Export ein neue Datei anzufangen, sondern so wenig
Dateien wie möglich zu pflegen. Da ist auch die Wahrscheinlichkeit größer, dass
Ersetzungen und Übersetzungen wiederverwendet werden können. Die Notwendigkeit
über unterschiedliche Sammlungen zu vereinheitlichen mag auch helfen.

Damit rücken die beiden Dateien (vindex.xlsx und translate.xslx) jetzt eine
Ebene höher und es gibt sie pro Haus nur noch einmal.

Dann brauchen wir aber ein neues Tool, jenseits der jetzigen Pipeline.
Pipeline setzt voraus, dass man beim Start in richtigen Folder ist: der 
Datumsfolder und auch, dass man nur an einem Export arbeiten will.

Wenn ich die vindex.xlsx und translate.xslx update, will ich aber nun Ver-
änderungen über alle Projekte einpflegen. Nach dem Editieren der Excel-Files
will ich wiederum die Korrekturen in alle vfix.mpx Dateien schreiben und nicht
in eins. 

Man kann das natürlich individuell (manuell für jedes Projekt) machen, das 
dürfte aber fehleranfällig sein, weil ich dann leicht einen Export vergessen 
kann.

-------------------------------------------------------------------------------
BADGER
---------------------------------------------------------------------
1. Projekte "rekursiv" finden.
Ich will also erstmal alle aktuellen Exporte finden, aber nur diese. Das dürfte 
gar nicht so einfach sein. Es ist pro Export immer nur der neueste Datumsfolder.

2. Update der Listen
Dann will ich vfix-update über alle Projekte laufen lassen.
Am Anfang dieses Laufs könnte ich den Zähler zurücksetzen, dann würde die 
Frequenspalte wieder stimmen. D.h. ich bin auf dem richtigen Weg.

3. Manuelle Arbeit in Excel
Dann will ich manuell die beiden Excel-Tabellen verändern.

4. Write vfix and mpxvoc
Danach will ich die Änderungen wieder in xml schreiben. Das sind eigentlich 
zwei Schritte. 
4.a vindex.xlsx landen in 2/MPX/vfix.mpx und zwar bitte schon für alle Projekte
wobei im Unterschied zu Pipeline alte vfix.mpx ruhig überschrieben werden 
können.
4.b translate.xlsx wird durch vocvoc in mpxvoc umgeschrieben.

Bei der Erzeugung von lido wird auf mpxvoc zurückgegriffen. Serpent kann auch 
gerne die LIDO-Files rekursiv erzeugen. Oder nicht. Das funktioniert ja 
schon in pipeline. Also lieber nicht.

Wenn ich die xslx Dateien in der Cloud freigebe, kann sie der Spezialist
dort ändern. Ein Team könnte das auch.
-------------------------------------------------------------------------------


