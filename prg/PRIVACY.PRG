
WAIT WINDOWS "Apertura documento in corso..." NOWAIT  

_NOME_FILE= "3. gestione della Privacy per dati aziendali.pdf"
_PTH_HELP = ALLTRIM(PUB_DIR)+"\" 
_LETTERA_BASE=SYS(5)+ALLTRIM(_PTH_HELP)+"\"+ALLTRIM(_NOME_FILE)



DO Open_with_default_windows_program WITH _LETTERA_BASE
