CLEAR ALL
CLOSE DATABASES ALL
DO SETLIB

USE C:\CEDOLINI\SISPAC\2010\maggio2010sispac
BROWSE NORMAL
GO TOP


CONTA_CEDOLINI = 0

DO WHILE .NOT. EOF()

	IF EOF()
		EXIT
	ENDIF
	
*!*		___WORD___ = '   Dipendente'
	___WORD___ = '!  44  !'
	
	IF ___WORD___ $  RIGA
		CONTA_CEDOLINI = CONTA_CEDOLINI + 1
	ENDIF

	SKIP +1
	
ENDDO

WAIT WINDOWS STR(CONTA_CEDOLINI,5,0)


*!*	USE c:\progetti\nebbiolo\analisi\cedolini\cedoliniu
*!*	BROWSE NORMAL
*!*	GO TOP


*!*	CONTA_CEDOLINI = 0

*!*	DO WHILE .NOT. EOF()

*!*		IF EOF()
*!*			EXIT
*!*		ENDIF
*!*		
*!*		___WORD___ = '   PROJEC0101Project S.r.l. '

*!*		
*!*		IF ___WORD___ $  RIGA
*!*			CONTA_CEDOLINI = CONTA_CEDOLINI + 1
*!*		ENDIF

*!*		SKIP +1
*!*		
*!*	ENDDO

*!*	WAIT WINDOWS STR(CONTA_CEDOLINI,5,0)


