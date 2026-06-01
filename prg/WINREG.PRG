
FUNCTION CERCA_VALORE_REGISTRO

LPARAMETERS _TIPO,_PERCORSO,_NOME

IF TYPE("_TIPO") == 'C'
	IF _TIPO = "HCR" .OR. _TIPO = "HLM" .OR. _TIPO = "HCU"
	ELSE
		RETURN ""
	ENDIF
ELSE
	RETURN ""
ENDIF

IF TYPE("_PERCORSO") == 'C'
	IF EMPTY(ALLTRIM(_PERCORSO))
		RETURN ""
	ENDIF
ELSE
	RETURN ""
ENDIF

IF TYPE("_NOME") == 'C'
ELSE
	_NOME = ""
ENDIF

_VALORE = ""
PUBLIC goApp
goApp = CREATEOBJECT('capp')
_VALORE = goApp.ReadReg(_TIPO,_PERCORSO,_NOME)
RELEASE goApp

RETURN _VALORE

**************************************************
*
DEFINE CLASS capp AS container

    *-- Reads the windows Registry.
    PROCEDURE readreg
        * Start of Code
        LPARAMETERS tcKey,tcSubKey,tcValue
        IF PCOUNT() = 2
            tcValue = ""
        ENDIF

        * setup environment

        LOCAL nKey, cSubKey, cValue,  cValueRead

        #DEFINE HKEY_USERS                  -2147483645
        #DEFINE HKEY_LOCAL_MACHINE          -2147483646
        #DEFINE HKEY_CURRENT_USER           -2147483647
        #DEFINE HKEY_CLASSES_ROOT            -2147483648

        DO CASE
        CASE m.tcKey == "HCR"
            nKey = HKEY_CLASSES_ROOT
        CASE m.tcKey == "HLM"
            nKey = HKEY_LOCAL_MACHINE
        CASE m.tcKey = "HCU"
            nKey = HKEY_CURRENT_USER
        CASE m.tcKey = "HCR"
            nKey = HKEY_CLASSES_ROOT
        OTHERWISE
            nKey = m.tcKey
        ENDCASE

        cSubKey = m.tcSubKey
        cValue  = m.tcValue

        * example 1
        * nKey = HKEY_LOCAL_MACHINE
        * cSubKey = "Software\VfpRegTest"
        * cValue = "TestREG_SZ"

        * example 2
        * nKey = HKEY_CLASSES_ROOT
        * cSubKey = "Spin.SpinButton\CLSID"
        * cValue = ""


        * here is where we will actually read the registry
        cValueRead = THIS.ReadREG_SZ(nKey, cSubKey, cValue)

        IF (EMPTY(cValueRead)) THEN
            cValueRead = "REGISTRY KEY NOT FOUND"
           * MESSAGEBOX("Function Not Successful.")  && testing only
        ELSE
           * MESSAGEBOX("Function Successful.    " + cValueRead)  && testing only
        ENDIF

        RETURN cValueRead
    ENDPROC


    *-- API's used by the ReadReg method.
    PROCEDURE readreg_sz
        * This function reads a REG_SZ value from the registry. If successful,
        * it will return the value read. If not successful, it will return an empty string.

        PARAMETERS  nKey, cSubKey, cValue
        * nKey The root key to open. It can be any of the constants defined below.
        *  #DEFINE HKEY_CLASSES_ROOT           -2147483648
        *  #DEFINE HKEY_CURRENT_USER           -2147483647
        *  #DEFINE HKEY_LOCAL_MACHINE          -2147483646
        *  #DEFINE HKEY_USERS                  -2147483645
        * cSubKey The SubKey to open.
        * cValue The value that is going to be read.

        * Constants that are needed for Registry functions
        #DEFINE REG_SZ   1

        * WIN 32 API functions that are used
        DECLARE Integer RegOpenKey IN Win32API ;
            Integer nHKey, String @cSubKey, Integer @nResult
        DECLARE Integer RegQueryValueEx IN Win32API ;
            Integer nHKey, String lpszValueName, Integer dwReserved,;
            Integer @lpdwType, String @lpbData, Integer @lpcbData
        DECLARE Integer RegCloseKey IN Win32API Integer nHKey

        * Local variables used
        LOCAL nErrCode      && Error Code returned from Registry functions
        LOCAL nKeyHandle    && Handle to Key that is opened in the Registry
        LOCAL lpdwValueType && Type of Value that we are looking for
        LOCAL lpbValue      && The data stored in the value
        LOCAL lpcbValueSize && Size of the variable
        LOCAL lpdwReserved  && Reserved Must be 0

        * Initialize the variables
        nKeyHandle = 0
        lpdwReserved = 0           
        lpdwValueType = REG_SZ
        lpbValue = ""
           
        nErrCode = RegOpenKey(nKey, cSubKey, @nKeyHandle)
        * If the error code isn't 0, then the key doesn't exist or can't be opened.
        IF (nErrCode # 0) THEN
            RETURN ""
        ENDIF

        lpcbValueSize = 1
        * Get the size of the data in the value
        nErrCode=RegQueryValueEx(nKeyHandle, cValue, lpdwReserved, @lpdwValueType, @lpbValue, @lpcbValueSize)

        * Make the buffer big enough
        lpbValue = SPACE(lpcbValueSize)   
        nErrCode=RegQueryValueEx(nKeyHandle, cValue, lpdwReserved, @lpdwValueType, @lpbValue, @lpcbValueSize)
           
        =RegCloseKey(nKeyHandle)
        IF (nErrCode # 0) THEN
            RETURN ""
        ENDIF

        lpbValue = LEFT(lpbValue, lpcbValueSize - 1)
        RETURN lpbValue
    ENDPROC


ENDDEFINE
*
*-- EndDefine: capp
**************************************************