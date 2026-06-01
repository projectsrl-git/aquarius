*******************************************************************
* -->> libreria di funzioni API di Windows x Visual FoxPro 
*******************************************************************
* 

******************************************************************
FUNCTION PJENCODE
******************************************************************
PARA V1
V2=""
FOR X=1 TO LEN(V1)
   V2=V2+CHR(ASC(SUBSTR(V1,X,1))-3)
NEXT
RETURN(V2)
*:EOF - FUNCTION ENCODE

******************************************************************
FUNCTION PJDECODE
******************************************************************
PARA V1
V2=""
FOR X=1 TO LEN(V1)
   V2=V2+CHR(ASC(SUBSTR(V1,X,1))+3)
NEXT
RETURN(V2)
*:EOF - FUNCTION DECODE



FUNCTION  getSections (lcFileName) 
    DECLARE INTEGER GetPrivateProfileString IN kernel32; 
        INTEGER  lpAppName,; 
        INTEGER  lpKeyName,; 
        STRING   lpDefault,; 
        STRING @ lpReturnedString,; 
        INTEGER  nSize,; 
        STRING   lpFileName 

    LOCAL lnSize, lpReturnedString, lnResult 
    lnSize = 4096 
    lpReturnedString = Repli (Chr(0), lnSize) 
     
    lnResult = GetPrivateProfileString (0,0,; 
        "#empty#", @lpReturnedString, lnSize,; 
        lcFileName) 
RETURN  Left (lpReturnedString, lnResult) 

FUNCTION  getKeys (lcFileName, lcSection) 
    DECLARE INTEGER GetPrivateProfileString IN kernel32; 
        STRING   lpAppName,; 
        INTEGER  lpKeyName,; 
        STRING   lpDefault,; 
        STRING @ lpReturnedString,; 
        INTEGER  nSize,; 
        STRING   lpFileName 

    LOCAL lnSize, lpReturnedString, lnResult 
    lnSize = 16384 
    lpReturnedString = Repli (Chr(0), lnSize) 
     
    lnResult = GetPrivateProfileString (lcSection,0,; 
        "#empty#", @lpReturnedString, lnSize,; 
        lcFileName) 
RETURN  Left (lpReturnedString, lnResult) 

FUNCTION  GetPrivKeyValue (lcFileName, lcSection, lcKey) 
    DECLARE INTEGER GetPrivateProfileString IN kernel32; 
        STRING   lpAppName,; 
        STRING   lpKeyName,; 
        STRING   lpDefault,; 
        STRING @ lpReturnedString,; 
        INTEGER  nSize,; 
        STRING   lpFileName 

    LOCAL lnSize, lpReturnedString, lnResult 
    lnSize = 16384 
    lpReturnedString = Repli (Chr(0), lnSize) 
     
    lnResult = GetPrivateProfileString (lcSection, lcKey,; 
        "#empty#", @lpReturnedString, lnSize,; 
        lcFileName) 
RETURN  Left (lpReturnedString, lnResult) 

FUNCTION  getWindowsDir 
    DECLARE INTEGER GetWindowsDirectory IN kernel32; 
        STRING @lpBuffer, INTEGER nSize 

    lpBuffer = SPACE (250) 
    nSizeRet = GetWindowsDirectory (@lpBuffer, Len(lpBuffer)) 
RETURN  SUBSTR (lpBuffer, 1, nSizeRet) 

FUNCTION  getKeysString (lcSection) 
* returns all key names found in this section 
* delimited with zero character 

    * Notice that lpKeyName declared as INTEGER 
    * to emulate an empty key name 

    DECLARE INTEGER GetProfileString IN kernel32; 
        STRING   lpAppName,; 
        INTEGER  lpKeyName,; 
        STRING   lpDefault,; 
        STRING @ lpReturnedString,; 
        INTEGER  nSize 

    nSize = 1024 
    lpReturnedString = Repli (Chr(0), nSize) 

    lnResult = GetProfileString (lcSection, 0, "#empty#",; 
        @lpReturnedString, nSize) 
RETURN  Left(lpReturnedString, lnResult) 

FUNCTION  GetKeyValue (lcSection, lcKey) 

    * Notice that lpKeyName declared as STRING 
    * because here we have a string value 
    * supplied to this procedure 

    DECLARE INTEGER GetProfileString IN kernel32; 
        STRING   lpAppName,; 
        STRING   lpKeyName,; 
        STRING   lpDefault,; 
        STRING @ lpReturnedString,; 
        INTEGER  nSize 

    nSize = 4096 
    lpReturnedString = Repli (Chr(0), nSize) 

    lnResult = GetProfileString (lcSection, lcKey, "#empty#",; 
        @lpReturnedString, nSize) 
RETURN  Left(lpReturnedString, lnResult) 


PROCEDURE  declare_fun
    DECLARE WritePrivateProfileSection IN kernel32; 
        STRING lpAppName,; 
        STRING lpString,; 
        STRING lpFileName 

    DECLARE WritePrivateProfileString IN kernel32; 
        STRING lpAppName,; 
        STRING lpKeyName,; 
        STRING lpString,; 
        STRING lpFileName 
    
    declare integer GetCurrentProcessId in win32api integer  && ERASMO - 06/12/2022
