
** programma per creare la struttura dei parametri di sistema

USE form\test_paraall.SCX
SET FILTER TO CLASS = 'optiongroup'
BROWSE normal
GO top
conta=0
SCAN

*!*		SCATTER MEMVAR memo 
*!*		= cerca_caption_in_property(m.property)
	conta=conta+1
ENDSCAN

RETURN 
?conta


FUNCTION cerca_caption_in_property

b = AT('sergiox',a)

RETURN 