RIT = MESSAGEBOX("Procedo con la creazione"+CHR(13)+"dell'archivio PARA.TXT con condizioni di pagamento ? ",292,"ATTENZIONE")

IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

cSql = "select * from para"
IF !ExecCommand(cSql,"CUR_PARA")
   RETURN .F.
ENDIF
SELECT CUR_PARA
GO TOP   

COPY TO PARA.TXT SDF FOR "CPA" $ CODICE

RIT = MESSAGEBOX("Archivio PARA.TXT "+CHR(13)+"creato correttamente",16,"ATTENZIONE")