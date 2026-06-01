PARA CLIENTI

IF PARAMETERS()=0
   CLIENTI = .T.
ENDIF

PUBLIC CAMPI(1)
PUBLIC _NOMEFILE,_ARCHIVIO
PUBLIC OPERAZIONI(1000)
PUBLIC CAMPO1,CAMPO2,CAMPO3,CAMPO4

FOR I=1 TO 1000
   OPERAZIONI(I) = ""
NEXT  

IF CLIENTI
   _ARCHIVIO = "U_CLI_AN"
   _NOMEFILE = "MAILCLI.DOC"
   CAMPO1    = "CLI_CODCLI"
   CAMPO2    = "CLI_RAGSOC"
   CAMPO3    = "CLI_INDIR"
   CAMPO4    = "CLI_LOCALI" 
   IF !ExecCommand("select * from u_cli_an where 0=0 order by cli_codsoc,cli_codcli","U_CLI_AN")
      return(.f.)
   ENDIF   
ELSE
   _ARCHIVIO = "U_FOR_AN"
   _NOMEFILE = "MAILFOR.DOC"
   CAMPO1    = "FOR_CODCLI"
   CAMPO2    = "FOR_RAGSOC"
   CAMPO3    = "FOR_INDIR"
   CAMPO4    = "FOR_LOCALI"
   IF !ExecCommand("select * from u_for_an where 0=0 order by for_codsoc,for_codcli","U_FOR_AN")
      return(.f.)
   ENDIF   
ENDIF

SELECT &_ARCHIVIO
QUANTI=AFIELDS(CAMPI)

DO FORM FORM\MAILF LINKED