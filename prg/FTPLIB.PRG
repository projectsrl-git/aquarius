*!*	##############################################################################################################

					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA DELLE FUNZIONI DI CONNESSIONE FTP                       ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################

*!*	*!* ------------------------------------------------------------------------------------------------------------------------------------
*!*	*!* -->> Come utilizzare le procedure di connessione ftp e quali funzioni sono disponibili
*!*	*!* -->> nell'oggetto FTP creato, il loro significato e il loro utilizzo
*!*	*!* ------------------------------------------------------------------------------------------------------------------------------------
*!*	*!* 
*!*	*!*	dell'oggetto 'objFtp' si possono testare le seguenti variabili:
*!*	*!*	    .LastErr 		-->>	codice ultimo messaggio di errore
*!*	*!*	    .ErrMsg 		-->>	messaggio di errore
*!*	*!*	    .host 			-->>	url del sito FTP (ftp.microsoft.com)
*!*	*!*	    .usr 			-->>	user-id
*!*	*!*	    .pswd 			-->>	password
*!*	*!*	    .IsConnected	-->>	flag di connessione al sito FTP  (.F. = non connesso - .T. = connesso)
*!*	*!*	    .hInternet	 	-->>	flag di connessione a internet (1 = connesso - 0 = disconnesso)
*!*	*!*	    .hConn			-->>	numero del canale aperto per la connessione FTP (0 = nessun canale aperto)
*!*	*!* ------------------------------------------------------------------------------------------------------------------------------------
*!*	*!*	dell'oggetto 'objFtp' si possono utilizzare le seguenti funzioni:
*!*	*!*		.FtpConnect("sito","user-id","password")		-->>	effettua la connessione al sito FTP
*!*	*!*		.SetCurrentDir("/dir1/dir2/dir3") 				-->>	setta una directory sul sito FTP
*!*	*!*		.GetCurrentDir() 								-->>	legge in quale directory siamo sul sito FTP
*!*	*!*		.DirExists("/dir1/dir2/dir3")					-->>	verifica l'esistenza di una directory sul sito FTP
*!*	*!*		.CreateDir("/dir1/dir2/dir3")					-->>	crea una directory sul sito FTP
*!*	*!*		.RemoveDir("/dir1/dir2/dir3") 					-->>	elimina una directory sul sito FTP
*!*	*!*		.DirToCursor("nome-cursore")					-->>	inserisce in un cursore il contenuto della directory del sito FTP
*!*	*!*		.GetFromFtp("file.est","c:\dir\file.est")		-->>	scarica dal sito ftp il file DA e lo salva in locale nel file A
*!*	*!*		.PutToFtp("c:\dir\file.est","file.est")			-->>	invia al sito ftp il file DA e lo salva in remoto nel file A
*!*	*!*		.DeleteFile("file.est")							-->>	cancella un file sul sito FTP remoto
*!*	*!*		.RenameFile("file.est","newFile.est")			-->>	rinomina un file sul sito FTP remoto
*!*	*!*
*!*	*!* ------------------------------------------------------------------------------------------------------------------------------------


*!*	PRIVATE objFtp 
*!*	objFtp = CreateObject("Tftp") 

*!*	*objFtp.FtpConnect("ftp.mokasirs.com", "user-id", "password") 

*!*	objFtp.FtpConnect("192.168.10.1", "project", "pippo10") 

*!*	IF Not objFtp.IsConnected 
*!*	    WAIT WINDOW NOWAIT "Connessione rifiutata" 
*!*	    RETURN 
*!*	ENDIF 

*!*	WITH objFtp 
*!*	    .SetCurrentDir("/moka/aquarius") 
*!*	    ? .GetCurrentDir() 
*!*	    .DirToCursor("cs") 
*!*	     
*!*	    * check if you have c:\temp directory 
*!*	    IF .GetFromFtp("rar.exe", "c:\temp\rar.exe") 
*!*	*        MODI FILE "c:\temp\pippo2.prg" NOWAIT 
*!*	    ENDIF 
*!*	ENDWITH 

*!*	return

*!*	*!* ------------------------------------------------------------------------------------------------
*!*	*!* -->> Viene definita la classe TFTP partendo dalla classe originaria CLSFTP.
*!*	*!* -->> Nel definire la nuova classe, posso modificare alcune procedure e funzioni che sono definite
*!*	*!* -->> in modo virtuale nella classe originaria.
*!*	*!* -->> Di seguito le procedure e le funzioni modificabili durante la ridefinizione della classe
*!*	*!* -->> originaria ed il loro utilizzo.
*!*	*!*
*!*	*!* -->> TUTTE LE PROCEDURE/FUNZIONI ELENCATE, SONO RICHIAMATE DIRETTAMENTE DALLA CLASSE ORIGINARIA
*!*	*!* 
*!*	*!*	 Funzioni:
*!*	*!*		BeforePutFile(lcLocalFile, lcRemoteFile)				-->>	funzione eseguita prima di iniziare un invio di un file
*!*	*!*		BeforeGetFile(lcRemoteFile, lcLocalFile)				-->>	funzione eseguita prima di iniziare la ricezione di un file
*!*	*!*		
*!*	*!*	 Procedure:
*!*	*!*		AfterPutFile(lcLocalFile, lcRemoteFile, lResult)		-->>	funzione eseguita al termine di un invio file
*!*	*!*		AfterGetFile(lcRemoteFile, lcLocalFile, lResult)		-->>	funzione eseguita al termine di una ricezione file
*!*	*!*	 	
*!*	*!* ------------------------------------------------------------------------------------------------
*!*	DEFINE CLASS Tftp As clsFtp 

*!*	FUNCTION BeforePutFile(lcLocalFile, lcRemoteFile) 
*!*	* return .F. to cancel file transfer 
*!*	    ? DATETIME(), " - Da locale a remoto: ", lcLocalFile, "--->>>", lcRemoteFile, "..." 
*!*	RETURN .T. 

*!*	PROCEDURE AfterPutFile(lcLocalFile, lcRemoteFile, lResult) 
*!*	    ? DATETIME(), " - Da locale a remoto: ", lcLocalFile, "--->>>", lcRemoteFile, " OK" 

*!*	FUNCTION BeforeGetFile(lcRemoteFile, lcLocalFile) 
*!*	* return .F. to cancel file transfer 
*!*	    ? DATETIME(), " - Da remoto a locale: ", lcRemoteFile, "--->>>", lcLocalFile, "..." 
*!*	RETURN .T. 

*!*	PROCEDURE AfterGetFile(lcRemoteFile, lcLocalFile, lResult) 
*!*	    ? DATETIME(), " - Da remoto a locale: ", lcRemoteFile, "--->>>", lcLocalFile, " OK" 

*!*	ENDDEFINE 

DEFINE CLASS clsFtp As Custom 

#DEFINE INTERNET_OPEN_TYPE_DIRECT       1 
#DEFINE INTERNET_INVALID_PORT_NUMBER    0 
#DEFINE INTERNET_SERVICE_FTP            1 
#DEFINE INTERNET_FLAG_NEED_FILE         16 
#DEFINE FTP_TRANSFER_TYPE_ASCII         1 
#DEFINE FTP_TRANSFER_TYPE_BINARY        2 
#DEFINE FILE_ATTRIBUTE_READONLY         1 
#DEFINE FILE_ATTRIBUTE_HIDDEN           2 
#DEFINE FILE_ATTRIBUTE_SYSTEM           4 
#DEFINE FILE_ATTRIBUTE_DIRECTORY        16 
#DEFINE FILE_ATTRIBUTE_ARCHIVE          32 
#DEFINE FILE_ATTRIBUTE_NORMAL           128 
#DEFINE FILE_ATTRIBUTE_TEMPORARY        512 
#DEFINE FILE_ATTRIBUTE_COMPRESSED       2048 
#DEFINE FORMAT_MESSAGE_ALLOCATE_BUFFER  256 
#DEFINE FORMAT_MESSAGE_FROM_SYSTEM      4096 
#DEFINE FORMAT_MESSAGE_IGNORE_INSERTS   512 
#DEFINE GENERIC_READ                    2147483648   && 0x80000000 
#DEFINE GENERIC_WRITE                   1073741824   && 0x40000000 

    LastErr=0 
    ErrMsg="" 
    host="" 
    usr="" 
    pswd="" 
    IsConnected=.F. 
    hInternet=0 
    hConn=0 

PROCEDURE  Init 
    DECLARE INTEGER InternetOpen IN wininet.dll; 
        STRING sAgent, INTEGER lAccessType, STRING sProxyName,; 
        STRING sProxyBypass, STRING lFlags   

    THIS.hInternet = InternetOpen ("VfpFtp 1.0", INTERNET_OPEN_TYPE_DIRECT, 0,0,0) 
    IF THIS.hInternet = 0 
        RETURN .F. 
    ENDIF 
    THIS.decl 

PROCEDURE Destroy 
    THIS.FtpDisconnect 
    = InternetCloseHandle(THIS.hInternet) 

PROCEDURE ClearError 
    THIS.LastErr = 0 
    THIS.ErrMsg = "" 

PROCEDURE SetError() 
    DECLARE INTEGER GetLastError IN kernel32 
    DECLARE INTEGER FormatMessage IN kernel32; 
        INTEGER dwFlags, INTEGER lpSource, INTEGER dwMsgId,; 
        INTEGER dwLangId, INTEGER @lpBuf, INTEGER nSz, INTEGER Args 

    THIS.LastErr = GetLastError() 

    LOCAL dwFlags, lpBuffer, lnLength 
    * specifying format parameters 
    dwFlags = FORMAT_MESSAGE_ALLOCATE_BUFFER +; 
        FORMAT_MESSAGE_FROM_SYSTEM + FORMAT_MESSAGE_IGNORE_INSERTS 

    lpBuffer = 0 
    lnLength = FormatMessage (dwFlags, 0, THIS.LastErr, 0, @lpBuffer, 0, 0) 
    IF lnLength <> 0 
        lpResult = REPLI (Chr(0), 500) 
        = CopyMemory (@lpResult, lpBuffer, lnLength) 
        THIS.ErrMsg = STRTRAN(LEFT(lpResult, lnLength), Chr(13)+Chr(10), "") 
    ELSE 
        THIS.ErrMsg = "#undefined#" 
    ENDIF 

FUNCTION FtpConnect(lcHost, lcUsr, lcPswd) 
    THIS.FtpDisconnect 

    DECLARE INTEGER InternetConnect IN wininet.dll; 
        INTEGER hInetSession, STRING sSrvName, INTEGER nSrvPort,;   
        STRING sUsrname, STRING sPwd, INTEGER lService,;   
        INTEGER lFlags, INTEGER lContext   

    THIS.hConn = InternetConnect (THIS.hInternet, lcHost,; 
        INTERNET_INVALID_PORT_NUMBER, lcUsr, lcPswd,; 
        INTERNET_SERVICE_FTP, 0, 0)   

    IF THIS.hConn <> 0 
        THIS.host = lcHost 
        THIS.usr = lcUsr 
        THIS.pswd = lcPswd 
        THIS.IsConnected = .T. 
    ELSE 
        THIS.SetError() 
    ENDIF 

PROCEDURE FtpDisconnect 
    IF THIS.IsConnected 
        = InternetCloseHandle(THIS.hConn) 
        STORE "" TO THIS.host, THIS.usr, THIS.pswd 
        THIS.IsConnected = .F. 
    ENDIF 

FUNCTION GetCurrentDir 
    if Not THIS.IsConnected 
        THIS.SetError() 
        RETURN "#not connected#" 
    ELSE 
        LOCAL lcDirectory, lnLen, lnResult 
        lcDirectory = SPACE(250)    
        lnLen = Len(lcDirectory) 
        lnResult = FtpGetCurrentDirectory (THIS.hConn, @lcDirectory, @lnLen) 
        RETURN Iif (lnResult=1, LEFT(lcDirectory, lnLen), "#error#") 
    ENDIF 

FUNCTION SetCurrentDir(lcDir) 
    if Not THIS.IsConnected 
        RETURN .F. 
    ELSE 
        IF (FtpSetCurrentDirectory (THIS.hConn, @lcDir) = 1) 
            RETURN .T. 
        ELSE 
            THIS.SetError() 
            RETURN .F. 
        ENDIF 
    ENDIF 

FUNCTION RemoveDir(lcDir) 
    IF Not DirExists(lcDir) 
        RETURN .T. 
    ENDIF 
    DECLARE INTEGER FtpRemoveDirectory IN wininet; 
        INTEGER hConnect, STRING lpszDirectory 
RETURN (FtpRemoveDirectory(THIS.hConn, lcDir) = 1) 

FUNCTION CreateDir(lcDir) 
*!*	    IF DirExists(lcDir) 
*!*	        RETURN .F. 
*!*	    ENDIF 
    DECLARE INTEGER FtpCreateDirectory IN wininet; 
        INTEGER hFtpSession, STRING lpszDirectory 
RETURN (FtpCreateDirectory(THIS.hConn, lcDir) = 1) 


FUNCTION RenameFile(lcRemoteExistingFile, lcRemoteNewFile) 
DECLARE INTEGER FtpRenameFile IN wininet; 
    INTEGER hConnect,; 
    STRING  lpszExisting,; 
    STRING  lpszNew
RETURN (FtpRenameFile(THIS.hConn, lcRemoteExistingFile, lcRemoteNewFile) = 1) 



FUNCTION DeleteFile(lcRemoteFile) 
    DECLARE INTEGER FtpDeleteFile IN wininet; 
        INTEGER hFtpSession,;
        STRING lpszFileName 
RETURN (FtpDeleteFile(THIS.hConn, lcRemoteFile) = 1) 

 
FUNCTION DirExists(lcDir) 
    IF Not THIS.IsConnected 
        RETURN .F. 
    ELSE 
        LOCAL lcCurrentDir 
        lcCurrentDir = THIS.GetCurrentDir() 

        IF THIS.SetCurrentDir(lcDir) 
            THIS.SetCurrentDir(lcCurrentDir) 
            RETURN .T. 
        ELSE 
            RETURN .F. 
        ENDIF 
    ENDIF 

FUNCTION  DirToCursor(lcCursor) 
    LOCAL lcFullPath, lcFullName, W32struct, lpFndFile, hFind, lnResult 
    lcFullPath = THIS.GetCurrentDir() 

    * create the cursor 
    IF TYPE("lcCursor") <> "C" 
        lcCursor = "ftpquery" 
    ENDIF 

    CREATE CURSOR (lcCursor) (; 
        filename   C(250),; 
        filesize   N(12),; 
        created    T,; 
        accessed   T,; 
        modified   T,; 
        fileattrib N(12),; 
        rdonlyfile L,; 
        hiddenfile L,; 
        sysfile    L,; 
        folder     L,; 
        archfile   L,; 
        normalfile L,; 
        tempfile   L,; 
        compressed L,; 
        rootpath   M; 
    ) 

    * object simulating the WIN32_FIND_DATA structure 
    W32struct = CreateObject("struct_WIN32_FIND_DATA") 

    * starting from the first file found 
    lpFndFile = Repli(Chr(0), 320) 
    hFind = FtpFindFirstFile (THIS.hConn, "*.*",; 
        @lpFndFile, INTERNET_FLAG_NEED_FILE, 0) 

    IF hFind = 0   
        lnResult = -1 
    ELSE 
        DO WHILE .T.   
            W32struct.setValue (lpFndFile) 
            DO CASE 
            CASE W32struct.filename == ".." 
                lcFullName = SUBSTR (lcFullPath, 1, RAT("/", lcFullPath)-1) 
            CASE W32struct.filename == "." 
                lcFullName = lcFullPath 
            OTHER 
                lcFullName = lcFullPath + "/" + W32struct.filename 
            ENDCASE 
            lcFullName = STRTRAN(lcFullName, "//","/") 

            WITH W32struct 
                INSERT INTO (lcCursor) VALUES (; 
                    .filename, .filesizelo, .creationtime, .lastaccesstime,; 
                    .lastwritetime, .fileattributes, .IsRdOnly(), .IsHidden(),; 
                    .IsSystem(), .IsDirectory(), .IsArchive(), .IsNormal(),; 
                    .IsTemporary(), .IsCompressed(), lcFullName; 
            ) 
            ENDWITH 
            IF InternetFindNextFile(hFind, @lpFndFile) <> 1   
                EXIT   
            ENDIF   
        ENDDO   
        lnResult = RECCOUNT(lcCursor) 
        GO TOP IN (lcCursor) 
        = InternetCloseHandle(hFind)   
    ENDIF   
    RELEASE W32struct   
RETURN lnResult 

FUNCTION BeforePutFile(lcLocalFile, lcRemoteFile) 
* virtual; return .F. to cancel file transfer 
RETURN .T. 

PROCEDURE AfterPutFile(lcLocalFile, lcRemoteFile, lResult) 
* virtual 

PROCEDURE OnPutChunk(lcLocalFile, lcRemoteFile, lnBytesWritten) 
* virtual 

FUNCTION PutToFtp(lcLocalFile, lcRemoteFile, lnChunkSize) 
    IF Not (THIS.IsConnected And FILE(lcLocalFile)) 
        RETURN .F. 
    ENDIF 

    IF TYPE("lcRemoteFile") <> "C" Or EMPTY(lcRemoteFile) 
        lcRemoteFile = SUBSTR(lcLocalFile, RAT("\",lcLocalFile)+1) 
    ENDIF 
         
    IF Not THIS.BeforePutFile(lcLocalFile, lcRemoteFile) 
        RETURN .F. 
    ENDIF 

    LOCAL lResult 
    IF TYPE("lnChunkSize") = "N" And lnChunkSize > 0 
        lResult = THIS.PutToFtp1(lcLocalFile, lcRemoteFile, lnChunkSize) 
    ELSE 
        lResult = (FtpPutFile(THIS.hConn, lcLocalFile, lcRemoteFile,; 
            FTP_TRANSFER_TYPE_BINARY, 0) = 1) 
    ENDIF 
    THIS.AfterPutFile(lcLocalFile, lcRemoteFile, lResult) 
RETURN lResult 

PROTECTED FUNCTION PutToFtp1(lcLocalFile, lcRemoteFile, lnChunkSize) 
* copying local file to the remote target by small portions 
    LOCAL hLocal, hRemote, lnBytesWritten, lcBuffer, lnLength 
    lnBytesWritten = 0 
    hLocal = FOPEN(lcLocalFile) 
    IF (hLocal = -1) 
        RETURN .F. 
    ENDIF 

    hRemote = FtpOpenFile(THIS.hConn, lcRemoteFile, GENERIC_WRITE,; 
        FTP_TRANSFER_TYPE_BINARY, 0) 

    IF hRemote = 0 
        = FCLOSE(hLocal) 
        RETURN .F. 
    ENDIF 

    DO WHILE Not FEOF(hLocal) 
        lcBuffer = FREAD(hLocal, lnChunkSize) 
        lnLength = Len(lcBuffer) 
        IF lnLength > 0 
            IF InternetWriteFile(hRemote, @lcBuffer, lnLength, @lnLength) = 1 
                lnBytesWritten = lnBytesWritten + lnLength 
                THIS.OnPutChunk(lcLocalFile, lcRemoteFile, lnBytesWritten) 
            ELSE 
                EXIT 
            ENDIF 
        ELSE 
            EXIT 
        ENDIF 
    ENDDO 
    = InternetCloseHandle(hRemote) 
    = FCLOSE(hLocal) 
RETURN .T. 

FUNCTION BeforeGetFile(lcRemoteFile, lcLocalFile) 
* virtual; return .F. to cancel file transfer 
RETURN .T. 

PROCEDURE AfterGetFile(lcRemoteFile, lcLocalFile, lResult) 
* virtual 

PROCEDURE OnGetChunk(lcRemoteFile, lcLocalFile, lnBytesWritten) 
* virtual 

FUNCTION GetFromFtp (lcRemoteFile, lcLocalFile, lnChunkSize) 
    IF Not THIS.IsConnected 
        RETURN .F. 
    ENDIF 

    IF TYPE("lcLocalFile") <> "C" Or EMPTY(lcLocalFile) 
        lcLocalFile = SUBSTR(lcRemoteFile, RAT("/",lcRemoteFile)+1) 
        lcLocalFile = FULLPATH(lcLocalFile) 
    ENDIF 

    IF Not THIS.BeforeGetFile(lcRemoteFile, lcLocalFile) 
        RETURN .F. 
    ENDIF 

    LOCAL lResult 
    IF TYPE("lnChunkSize") = "N" And lnChunkSize > 0 
        lResult = THIS.GetFromFtp1(lcRemoteFile, lcLocalFile, lnChunkSize) 
    ELSE 
        lResult = (FtpGetFile(THIS.hConn, lcRemoteFile, lcLocalFile,; 
            0, FILE_ATTRIBUTE_NORMAL, FTP_TRANSFER_TYPE_BINARY, 0) = 1) 
    ENDIF 
    THIS.AfterGetFile(lcRemoteFile, lcLocalFile, lResult) 
RETURN lResult 

PROTECTED FUNCTION GetFromFtp1(lcRemoteFile, lcLocalFile, lnChunkSize) 
    LOCAL hRemote, hLocal, lnBytesRead, lcBuffer, lnBufSize 
    hLocal = FCREATE (lcLocalFile) 
    IF hLocal = -1 
        RETURN .F. 
    ENDIF 
     
    hRemote = FtpOpenFile(THIS.hConn, lcRemoteFile, GENERIC_READ,; 
        FTP_TRANSFER_TYPE_BINARY, 0) 

    IF hRemote = 0 
        FCLOSE(hLocal) 
        RETURN .F. 
    ENDIF 
     
    lnBytesRead = 0 
    DO WHILE .T. 
        lcBuffer = Repli(Chr(0), lnChunkSize) 
        lnBufSize = lnChunkSize 
        IF InternetReadFile(hRemote, @lcBuffer, lnBufSize, @lnBufSize) = 1 
            IF lnBufSize <> 0 
                = FWRITE (hLocal, lcBuffer, lnBufSize) 
                lnBytesRead = lnBytesRead + lnBufSize 
                THIS.OnGetChunk(lcRemoteFile, lcLocalFile, lnBytesRead) 
            ELSE 
                EXIT 
            ENDIF 
        ELSE 
            EXIT 
        ENDIF 
    ENDDO 
    = InternetCloseHandle(hRemote) 
    = FCLOSE(hLocal) 
RETURN .T. 

PROCEDURE decl 
    DECLARE INTEGER InternetCloseHandle IN wininet.dll INTEGER hInet   

    DECLARE RtlMoveMemory IN kernel32 As CopyMemory; 
        STRING @Destination, INTEGER Source, INTEGER nLength 

    DECLARE INTEGER FtpGetCurrentDirectory IN wininet.dll; 
        INTEGER  hFtpSession, STRING @lpszDir, INTEGER @lpdwCurDir 

    DECLARE INTEGER FtpSetCurrentDirectory IN wininet.dll; 
        INTEGER  hFtpSession, STRING @lpszDir 

    DECLARE INTEGER FtpFindFirstFile IN wininet.dll;   
        INTEGER hFtpSession, STRING lpszSrchFile,;   
        STRING @lpFindFileData, INTEGER dwFlags, INTEGER dwContent   

    DECLARE INTEGER InternetFindNextFile IN wininet.dll;   
        INTEGER hFind, STRING @lpvFindData 

    DECLARE INTEGER FileTimeToSystemTime IN kernel32.dll; 
        STRING @lpFileTime, STRING @lpSystemTime 

    DECLARE INTEGER FtpOpenFile IN wininet; 
        INTEGER hFtpSession, STRING sFileName, INTEGER lAccess,; 
        INTEGER lFlags, INTEGER lContext 

    DECLARE INTEGER FtpPutFile IN wininet.dll;   
        INTEGER hConnect, STRING lpszLocalFile,;   
        STRING lpszNewRmtFile, INTEGER dwFlags, INTEGER dwContext 

    DECLARE INTEGER FtpGetFile IN wininet; 
        INTEGER hConnect, STRING lpszRemoteFile,; 
        STRING  lpszNewFile, INTEGER fFailIfExists,; 
        INTEGER dwFlagsAndAttr, INTEGER dwFlags, INTEGER dwContext 

    DECLARE INTEGER InternetWriteFile IN wininet; 
        INTEGER hFile, STRING @sBuffer,; 
        INTEGER lBytesToWrite, INTEGER @dwBytesWritten 

    DECLARE INTEGER InternetReadFile IN wininet.dll; 
        INTEGER hFile, STRING @lpBuffer,; 
        INTEGER dwNumberOfBytesToRead, INTEGER @dwBytesRead 

ENDDEFINE 

DEFINE CLASS struct_WIN32_FIND_DATA As Custom   
* this class emulates WIN32_FIND_DATA structure   
    value             = ""   
    fileAttributes   = 0   
    creationTimeLo   = 0   
    creationTimeHi   = 0   
    lastAccessTimeHi = 0   
    lastAccessTimeLo = 0   
    lastWriteTimeHi  = 0   
    lastWriteTimeLo  = 0   
    fileSizeLo         = 0 && fileSizeHi omitted 
    fileName         = ""   
    creationTime     = CTOT ("") 
    lastAccessTime   = CTOT ("") 
    lastWriteTime     = CTOT ("") 

PROCEDURE  setValue (lcValue)       
* translates the buffer"s content into the object"s properties 
    THIS.value              = lcValue   
    THIS.fileAttributes   = THIS.buf2num (THIS.value,  0, 4)   
    THIS.creationTimeLo   = THIS.buf2num (THIS.value,  4, 4)   
    THIS.creationTimeHi   = THIS.buf2num (THIS.value,  8, 4)   
    THIS.lastAccessTimeHi = THIS.buf2num (THIS.value, 12, 4)   
    THIS.lastAccessTimeLo = THIS.buf2num (THIS.value, 16, 4)   
    THIS.lastWriteTimeHi  = THIS.buf2num (THIS.value, 20, 4)   
    THIS.lastWriteTimeLo  = THIS.buf2num (THIS.value, 24, 4)   
    THIS.fileSizeLo          = THIS.buf2num (THIS.value, 32, 4)   
    THIS.creationTime      = THIS.ftime2dtime (SUBSTR(THIS.value,  5, 8)) 
    THIS.lastAccessTime   = THIS.ftime2dtime (SUBSTR(THIS.value, 13, 8)) 
    THIS.lastWriteTime      = THIS.ftime2dtime (SUBSTR(THIS.value, 21, 8)) 
    THIS.fileName          = ALLTRIM(SUBSTR(THIS.value, 45,250))   
    IF AT(Chr(0), THIS.fileName) <> 0   
        THIS.fileName = SUBSTR (THIS.fileName, 1, AT(Chr(0), THIS.fileName)-1)   
    ENDIF   

FUNCTION AttribSet (lnAttrib) 
RETURN BitAnd(THIS.fileAttributes, lnAttrib) = lnAttrib 

FUNCTION IsRdOnly 
RETURN THIS.AttribSet(FILE_ATTRIBUTE_READONLY) 

FUNCTION IsHidden 
RETURN THIS.AttribSet(FILE_ATTRIBUTE_HIDDEN) 

FUNCTION IsSystem 
RETURN THIS.AttribSet(FILE_ATTRIBUTE_SYSTEM) 

FUNCTION IsDirectory 
RETURN THIS.AttribSet(FILE_ATTRIBUTE_DIRECTORY) 

FUNCTION IsArchive 
RETURN THIS.AttribSet(FILE_ATTRIBUTE_ARCHIVE) 

FUNCTION IsNormal 
RETURN THIS.AttribSet(FILE_ATTRIBUTE_NORMAL) 

FUNCTION IsTemporary 
RETURN THIS.AttribSet(FILE_ATTRIBUTE_TEMPORARY) 

FUNCTION IsCompressed 
RETURN THIS.AttribSet(FILE_ATTRIBUTE_COMPRESSED) 

FUNCTION buf2num(lcBuffer, lnOffset, lnBytes) 
* converts N bytes from the buffer into a numeric value   
    lnResult = 0    
    FOR ii=1 TO lnBytes 
        lnResult = lnResult +;    
            BitLShift(Asc(SUBSTR(lcBuffer, lnOffset+ii, 1)), (ii-1)*8) 
    ENDFOR    
RETURN lnResult   

FUNCTION  ftime2dtime (lcFileTime) 
    LOCAL lcSystemTime, ltResult, lcStoredSet 
    IF lcFileTime = REPLI (Chr(0), 8) 
        ltResult = CTOT ("") 
    ELSE 
        lcSystemTime = REPLI (Chr(0), 16) 
        = FileTimeToSystemTime (@lcFileTime, @lcSystemTime) 
        wYear   = THIS.buf2num (lcSystemTime,  0, 2) 
        wMonth  = THIS.buf2num (lcSystemTime,  2, 2) 
        wDay    = THIS.buf2num (lcSystemTime,  6, 2) 
        wHour   = THIS.buf2num (lcSystemTime,  8, 2) 
        wMinute = THIS.buf2num (lcSystemTime, 10, 2) 
        wSecond = THIS.buf2num (lcSystemTime, 12, 2) 

        lcStoredSet = SET ("DATE") 
        SET DATE TO MDY 
        lcDate = STRTRAN (STR(wMonth,2) + "/" + STR(wDay,2) + "/" + STR(wYear,4), " ","0") 
        lcTime = STRTRAN (STR(wHour,2) + ":" + STR(wMinute,2) + ":" + STR(wSecond,2), " ","0") 
        ltResult = CTOT (lcDate + " " + lcTime) 
        SET DATE TO &lcStoredSet 
    ENDIF 
RETURN ltResult 
ENDDEFINE 
