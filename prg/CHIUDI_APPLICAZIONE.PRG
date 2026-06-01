
***_RISP = MESSAGEBOX("Chiudere l'applicazione Aquarius?",4+32+256,"Attenzione")

***IF _RISP <> 6
***RETURN
***ENDIF

***CLEAR EVENTS

*!*	ON READERROR
*!*	ON ERROR
