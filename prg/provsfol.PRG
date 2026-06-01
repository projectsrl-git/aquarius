*************************************************************************************
*								SFOLTIMENTO ARCHIVIO PROVVIGIONI					*
*************************************************************************************

STORIDAL = RIBALTA2(STORIDAL)
STORIAL  = RIBALTA2(STORIAL)

CTRELAB=0

x_inca  = "ord_princa <> 0"
x_dt1   = STORIDAL
x_dt2   = STORIAL
x_data  = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
cSql    = "DELETE FROM PROVVI WHERE " + x_data + " and " + x_inca 
IF !ExecCommand(cSql,"PROVVI")
   RETURN (.f.)
ENDIF 

WAIT WINDOW "Operazione completata. BUON LAVORO..."

RETURN
