
LPARAMETERS MYSTRING

*
* Initialize running total with value of start character, then scan the 
* string and add character value times position
*
SUBTOT = 104
FOR I = 1 TO LEN(MYSTRING)
    C = SUBSTR(MYSTRING, I, 1)
    X = VAL(C) - 32
    SUBTOT = SUBTOT + (X * I)
NEXT I
*
* Calculate Modulo 103.  This is the checksum
*
CHKDIG = MOD(SUBTOT, 103)
*
* Now convert numeric checksum to a character.  This conversion takes
* into account the particular mapping of the font being used (this 
* example is for the font published by Azalea Software).
*
DO CASE
    CASE CHKDIG = 0
        CHKCHR = CHR(174)
    CASE CHKDIG < 94
        CHKCHR = CHR(CHKDIG + 32)
    OTHERWISE
        CHKCHR = CHR(CHKDIG + 71)
ENDCASE
*
* Now format the final output string: start character,
* data, check character, and stop character.
*
OUTSTRING = CHR(162) + MYSTRING + CHKCHR + CHR(164)

?OUTSTRING