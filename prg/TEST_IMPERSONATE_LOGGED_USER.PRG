*!*	#define LOGON32_PROVIDER_DEFAULT 0
*!*	#define LOGON32_LOGON_INTERACTIVE       2
*!*	#define LOGON32_LOGON_NETWORK           3
*!*	#define LOGON32_LOGON_BATCH             4
*!*	#define LOGON32_LOGON_SERVICE           5
*!*	#define LOGON32_LOGON_UNLOCK            7

*!*	DECLARE integer LogonUser IN AdvApi32.DLL;
*!*	 string szUsername,;
*!*	 string lpszDomain,;
*!*	   string lpszPassword,;
*!*	 integer dwLogonType,;
*!*	 integer dwLogonProvider,;
*!*	 integer @phToken

*!*	DECLARE integer ImpersonateLoggedOnUser IN AdvApi32.DLL integer hToken
*!*	DECLARE integer RevertToSelf IN AdvApi32.DLL

*!*	local nToken
*!*	nToken = 0
*!*	? LogonUser("project","ETMED05","Cardioline2021!",LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT, @nToken)
*!*	? nToken

*!*	? ImpersonateLoggedOnUser(nToken)

*!*	_V_DIRECTORY_FILE_PDF = "\\192.168.30.44\Azienda\Funzione Aziendale\Produzione\Safety tests\Report\PDF"
*!*	_V_RUN = "/N Explorer /e," + ALLTRIM(_V_DIRECTORY_FILE_PDF)
*!*	RUN &_V_RUN

*!*	* Access will be granted, you are accessing the dbf as domain\user
*!*	*USE "\\server\share\secret file.dbf"

*!*	? RevertToSelf()

*!*	*  Now access will be denied, you are accessing the dbf as the currently user logged on at the computer's console.
*!*	*MODIFY FILE "\\server\share\secret file.dbf"






SET STEP ON

#define LOGON32_PROVIDER_DEFAULT        0
#define LOGON32_LOGON_INTERACTIVE       2
#define LOGON32_LOGON_NETWORK           3
#define LOGON32_LOGON_BATCH             4
#define LOGON32_LOGON_SERVICE           5
#define LOGON32_LOGON_UNLOCK            7

DECLARE integer LogonUser IN AdvApi32.DLL;
	string szUsername,;
	string lpszDomain,;
 	string lpszPassword,;
	integer dwLogonType,;
	integer dwLogonProvider,;
	integer @phToken

DECLARE integer ImpersonateLoggedOnUser IN AdvApi32.DLL integer hToken
DECLARE integer RevertToSelf IN AdvApi32.DLL

local nToken
nToken = 0

* you must substitute your special username / password here.
IF LogonUser("Administrator","ETMED05","CmGsET1964",LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT, @nToken) = 0
	MESSAGEBOX("Failed to authenticate. Unable to continue",16,"Error",0)
	RETURN
ENDIF
IF ImpersonateLoggedOnUser(nToken) = 0
	MESSAGEBOX("Failed to authenticate. Unable to continue",16,"Error",0)
	RETURN
ENDIF