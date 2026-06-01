*******************************************************************
* PROCEDURA - WRITE_LOGERROR     Data: 27.06.2024   Autore: Project
*******************************************************************

LPARAMETERS merror, mess, mess1, mprog, mlineno

ASTACKINFO(ArrayStackInfo)
_nStackLevels = ALEN(ArrayStackInfo, 1)
_nCallingLevel = _nStackLevels - 1
_cCurrentProgramFilename = ALLTRIM(ArrayStackInfo(_nCallingLevel,2))

_X_MOTIVO="Errore durante l'esecuzione del programma "+mprog+CHR(13)+;
          "Nome Programma chiamante: "+_cCurrentProgramFilename+CHR(13)+CHR(10)+;
          "Errore nr.: "+LTRIM(STR(merror))+CHR(13)+CHR(10)+;
          "Messaggio: "+mess+CHR(13)+CHR(10)+;
          "Linea codice: "+mess1+CHR(13)+CHR(10)+;
          "Linea numero: "+LTRIM(STR(mlineno))+CHR(13)+CHR(10)+;
          "Tabella in uso: "+alias(select())+CHR(13)+CHR(10)+;
          "Rec-number: "+ALLTRIM(str(recno()))

_mes_err_sele=select()
if !file("LOGERROR.DBF")
  create dbf logerror free(data t(8),;
  						   wrk c(60),;
  						   utente c(10),;
  						   msg m(4))
  select logerror
  use
endif
select(_mes_err_sele)

=opendb("logerror")
append blank
replace data	with datetime();
        wrk		with sys(0);
        utente  with pub_codope;
        msg		with _x_motivo
SELECT logerror
USE

select(_mes_err_sele)

RETURN(.T.)


**************************************************************************
* Procedura - OPENDB                    Data: 10.11.95   Autore: Project
**************************************************************************
* Procedura da utilizzare per aprire un DB
*
PROCEDURE OPENDB
PARA V1
IF !USED(V1)
   USE &V1 IN 0 AGAIN
ENDIF
SELECT &V1
SET FILTER TO
SET ORDER TO
GO TOP
RETURN
*EOF Procedure: OPENDB
