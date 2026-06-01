lcCurDrive = JUSTDRIVE(FULLPATH(CURDIR()))
lcCurDir = CURDIR()

Recurse('n:\path')
CHDIR &lcCurDrive.&lcCurDir.


FUNCTION Recurse
LPARAMETERS pcDir
LOCAL lnPtr, lnFileCount, laFileList, lcDir, lcFile

CHDIR (pcDir)
? 'Dir -> ' + FULLPATH(CURDIR())

DIMENSION laFileList[1]

*--- Read the chosen directory.
lnFileCount = ADIR(laFileList, '*.*', 'D')
FOR lnPtr = 1 TO lnFileCount

  IF 'D' $ laFileList[lnPtr, 5]

    *--- Get directory name.
    lcDir = laFileList[lnPtr, 1]

    *--- Ignore current and parent directory pointers.
    IF lcDir != '.' AND lcDir != '..'
      *--- Call this routine again.
      Recurse(lcDir)
    ENDIF

  ELSE

    *--- Get the file name.
    lcFile = LOWER(laFileList[lnPtr, 1])
    IF [Condition is True]
      ? lcFile 
    ENDIF

  ENDIF

ENDFOR

*--- Move back to parent directory.
CHDIR ..