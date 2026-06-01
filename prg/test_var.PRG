M.DESCRI = 'R.B. iva 30 gg.dfm + saldo rim.dir.123C145'
_lungh_var  = LEN(ALLTRIM(M.DESCRI))
_posizione_da_destra=RAT(find_str,M.DESCRI)
? _posizione_da_destra
M.DESCRI = SUBSTR(M.DESCRI,1,(_posizione_da_destra - 1)) + '  ' + SUBSTR(M.DESCRI,(_posizione_da_destra + 2),_lungh_var)
?  M.DESCRI
