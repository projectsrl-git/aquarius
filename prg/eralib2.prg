********************************************************************************
**** AGGIUNTA ALL'APPLILIB.PRG - ERASMO 08/03/2005 *****************************
********************************************************************************

****************************************
FUNCTION CERCA_NUMERO_DATA_PRG
****************************************
PARAMETERS _VV_CODART

_XX_CODART = _VV_CODART
_XX_NUMPRG = SPACE(06)
_XX_DATPRG = SPACE(10)
_XX_AMGPRG = SPACE(10)
_XX_RIT    = SPACE(26)

SWWS = SELECT()

x_cint = "nud_codint = '" + _XX_CODART + "'"
x_cond = x_cint
cSql   = "SELECT TOP 1 * FROM U_PRG_RT WHERE " + x_cond + " order by sta_amgprg desc"
IF !ExecCommand(cSql,"U_PRG_RT")
   return(.f.)
ENDIF 
SELECT U_PRG_RT
GO TOP
IF EOF()
   x_cint = "nud_codint = '" + _XX_CODART + "'"
   x_cond = x_cint
   cSql   = "SELECT TOP 1 * FROM U_PRG_RR WHERE " + x_cond + " order by sta_amgprg desc"
   IF !ExecCommand(cSql,"U_PRG_RR")
      return(.f.)
   ENDIF 
   SELECT U_PRG_RR
   GO TOP
   IF EOF()
      x_cint = "nud_codint = '" + _XX_CODART + "'"
      x_cond = x_cint
      cSql   = "SELECT TOP 1 * FROM U_PRG_RA WHERE " + x_cond + " order by sta_amgprg desc"
      IF !ExecCommand(cSql,"U_PRG_RA")
         return(.f.)
      ENDIF 
      SELECT U_PRG_RA
      GO TOP
      IF EOF()
         x_cint = "nud_codint = '" + _XX_CODART + "'"
         x_cond = x_cint
         cSql   = "SELECT TOP 1 * FROM U_AVA_TG WHERE " + x_cond + " order by ava_datava desc"
         IF !ExecCommand(cSql,"U_AVA_TG")
            return(.f.)
         ENDIF 
         SELECT U_AVA_TG
         GO TOP
         IF EOF()      
            x_cint = "nud_codint = '" + _XX_CODART + "'"
            x_cond = x_cint
            cSql   = "SELECT TOP 1 * FROM U_AVA_RI WHERE " + x_cond + " order by ava_datava desc"
            IF !ExecCommand(cSql,"U_AVA_RI")
               return(.f.)
            ENDIF 
            SELECT U_AVA_RI
            GO TOP
            IF EOF()         
               x_cint = "nud_codint = '" + _XX_CODART + "'"
               x_cond = x_cint
               cSql   = "SELECT TOP 1 * FROM U_AVA_SP WHERE " + x_cond + " order by ava_datava desc"
               IF !ExecCommand(cSql,"U_AVA_SP")
                  return(.f.)
               ENDIF 
               SELECT U_AVA_SP
               GO TOP
               IF EOF()            
               ELSE
                  _XX_NUMPRG = STA_NUMPRG
                  _XX_DATPRG = STA_DATPRG
                  _XX_AMGPRG = STA_AMGPRG
               ENDIF
            ELSE
               _XX_NUMPRG = STA_NUMPRG
               _XX_DATPRG = STA_DATPRG
               _XX_AMGPRG = STA_AMGPRG
            ENDIF               
         ELSE
            _XX_NUMPRG = STA_NUMPRG
            _XX_DATPRG = STA_DATPRG
            _XX_AMGPRG = STA_AMGPRG
         ENDIF               
      ELSE
         _XX_NUMPRG = STA_NUMPRG
         _XX_DATPRG = STA_DATPRG
         _XX_AMGPRG = STA_AMGPRG
      ENDIF                           
   ELSE
      _XX_NUMPRG = STA_NUMPRG
      _XX_DATPRG = STA_DATPRG
      _XX_AMGPRG = STA_AMGPRG      
   ENDIF
ELSE
   _XX_NUMPRG = STA_NUMPRG
   _XX_DATPRG = STA_DATPRG
   _XX_AMGPRG = STA_AMGPRG      
ENDIF

IF EMPTY(ALLTRIM(_XX_NUMPRG))
   _XX_RIT = SPACE(26)
ELSE
   _XX_RIT = STA_NUMPRG + STA_DATPRG + STA_AMGPRG
ENDIF

SELECT (SWWS)

RETURN _XX_RIT
