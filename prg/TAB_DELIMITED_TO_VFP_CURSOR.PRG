
LPARAMETERS _par_nomecur_out,_par_NomeFileText

cInputFile = FileToStr(_par_NomeFileText)
cElabFileName = SYS(5)+SYS(2003)+"\"+SYS(2015)+".txt"
IF SUBSTR(cfile,1,3) = 'ÿþ"'
	cInputFile = SUBSTR(cInputFile,3)
	StrToFile(Strconv(cInputFile,10),cElabFileName)
ELSE
	StrToFile(cInputFile,cElabFileName)
ENDIF

*** LEGGO IL NUMERO DI COLONNE DEL CSV
gnFileHandle = FOPEN(_par_NomeFileText)
*lcLine = FGETS(gnFileHandle)
lcLine = FGETS(gnFileHandle,8192)  && ERASMO - 30/11/2018
nCols = OCCURS(CHR(9),lcLine) + 1
FCLOSE(gnFileHandle)

*** CREO IL CURSORE NEL QUALE IMPORTERO' I DATI
_cCommand = "CREATE CURSOR " + _par_nomecur_out + "("
_cColumns = ""
FOR I=1 TO nCols
	_cColDef = ALLTRIM(n2c(I)) + " C(254)"
	_cColumns = ALLTRIM(_cColumns) + IIF(EMPTY(_cColumns),"",", ") + _cColDef
NEXT
_cCommand = _cCommand + _cColumns + ")"
&_cCommand

SELECT &_par_nomecur_out
_cCommand = "APPEND FROM '" + cElabFileName + "' DELIMITED WITH TAB"
&_cCommand

_cCommand = "ERASE '" + cElabFileName + "'"
&_cCommand

SELECT &_par_nomecur_out
GO TOP

RETURN


***************************
* Function N2C
***************************
FUNCTION N2C
LPARAMETERS	nNumero
			
LOCAL cStringa
cStringa= ""

nNumero = ABS(INT(nNumero))
pNumero = nNumero

DO WHILE .T.
	IF pNumero = 0
		EXIT
	ENDIF
	
	_nChr = MOD(pNumero,26) + 64
	IF _nChr = 64
		_nChr = 90
		pNumero = INT(pNumero/26) - 1
	ELSE
		pNumero = INT(pNumero/26)
	ENDIF
	_cChr = CHR(_nChr)
	
	cStringa = _cChr + cStringa
ENDDO

RETURN cStringa
ENDFUNC