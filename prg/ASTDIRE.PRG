ON ERROR DO errhand WITH ;      
	ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )

V_ORA = CURDIR()                && identificazione della directory attuale

CD\                             && posizionamento sulla root principale

*V_DIR = "\SCHEDE_TECNICHE_DOS\" && inizializzazione variabile con nuova directory
V_DIR = V_ORA + "SCHEDE_TECNICHE_DOS\" && inizializzazione variabile con nuova directory

CHDIR &V_DIR                    && posizionamento sulla directory copy file dos

IF x_errore = 202
   MKDIR &V_DIR                 && creazione della directory (se non esiste)
ENDIF

SET DEFA TO &V_ORA              && riposizionamento sulla directory di lavoro aquarius

ON ERROR                        && inizializzazione gestore errori

RETURN

*====================================================

PROCEDURE errhand
PARAMETER merror, mess, mess1, mprog, mlineno
*CLEAR
*? 'Numero di errore: ' + LTRIM(STR(merror))
*? 'Messaggio di errore: ' + mess
*? 'Riga di codice con errore: ' + mess1
*? 'Numero di riga errore: ' + LTRIM(STR(mlineno))
*? 'Programma con errore: ' + mprog
*WAIT

x_errore = merror
x_messag = mess

return

