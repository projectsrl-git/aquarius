DEFINE CLASS MapiSendMail As Custom 
#DEFINE SUCCESS_SUCCESS  0 
    MsgSubject="" 
    MsgBody="" 
    snd=.F. 
    rcp=.F. 
    att=.F. 

PROCEDURE Init 
    THIS.snd = CreateObject("TRecipients") 
    THIS.rcp = CreateObject("TRecipients") 
    THIS.att = CreateObject("TAttachments") 

PROCEDURE SndMessage 
    IF Not THIS.ValidMessage() 
        RETURN .F. 
    ENDIF 
     
    LOCAL lcMapiMessage, loSubject, loBody, ii, lnResult, lcStoredPath 
    loSubject = CreateObject("PChar", THIS.MsgSubject) 
    loBody = CreateObject("PChar", THIS.MsgBody) 
    lcStoredPath = SYS(5) + SYS(2003) 

    * assembling MapiMessage structure 
    lcMapiMessage = num2dword(0) +; 
        num2dword(loSubject.getAddr()) + num2dword(loBody.getAddr()) +; 
        num2dword(0) + num2dword(0) + num2dword(0) + num2dword(0) +; 
        num2dword(THIS.snd.getAddr()) +; 
        num2dword(THIS.rcp.ItemCount) + num2dword(THIS.rcp.GetAddr()) +; 
        num2dword(THIS.att.ItemCount) +; 
        num2dword(Iif(THIS.att.ItemCount=0, 0,THIS.att.GetAddr())) 

    DECLARE INTEGER MAPISendMail IN mapi32; 
        INTEGER lhSession, INTEGER ulUIParam, STRING @lpMessage,; 
        INTEGER flFlags, INTEGER ulReserved 

    lnResult = MAPISendMail(0, 0, @lcMapiMessage, 0, 0) 
    SET DEFAULT TO (lcStoredPath) 
RETURN (lnResult=0) && sendmessage 

FUNCTION ValidMessage 
    LOCAL lValid 
    lValid = THIS.rcp.ItemCount > 0 And; 
        Not (EMPTY(THIS.MsgSubject) And EMPTY(THIS.MsgBody); 
        And THIS.att.ItemCount=0) 

    IF Not m.lValid 
        IF THIS.rcp.ItemCount = 0 
            = MessageB ("The outgoing message is invalid." + Chr(13) +; 
                "Recipients not defined.", 48, " Ivalid message data") 
        ELSE 
            = MessageB ("The outgoing message is invalid." + Chr(13) +; 
                "At least one has to be valid: subj, body, attachments.",; 
                48, " Invalid message data") 
        ENDIF 
    ENDIF 
RETURN m.lValid 

PROCEDURE ClearMessage 
    THIS.ClearRecipients 
    THIS.ClearAttachments 
    THIS.MsgBody="" 
    THIS.MsgSubject="" 

PROCEDURE AddSender (lcSndName, lcSndAddr) 
#DEFINE MAPI_ORIG  0 
    IF TYPE("lcSndAddr") <> "C" 
        lcSndAddr = lcSndName 
    ENDIF 
    THIS.snd.AppendItem (MAPI_ORIG, lcSndName, lcSndAddr) 

PROCEDURE AddRecipient(lcRcpName, lcRcpAddr) 
#DEFINE MAPI_TO  1 
#DEFINE MAPI_CC  2 
    IF TYPE("lcRcpAddr") <> "C" 
        lcRcpAddr = lcRcpName 
    ENDIF 
    LOCAL lnClass 
    WITH THIS.rcp 
        lnClass = Iif(.ItemCount=0, MAPI_TO, MAPI_CC) 
        .AppendItem (lnClass, lcRcpName, lcRcpAddr) 
    ENDWITH 

PROCEDURE ClearRecipients 
    THIS.rcp.ClearItems 

PROCEDURE AddAttachment (lcFilename) 
RETURN THIS.att.AppendItem(lcFilename) 

PROCEDURE ClearAttachments 
    THIS.att.ClearItems 
ENDDEFINE  && mapisendmail 

DEFINE CLASS TRecipients As Custom  && array of recipients 
    ItemCount=0 
    DIMEN arrRecip[1] 
    RcpsBuffer=.F. 

PROCEDURE Destroy 
    THIS.UnlockData 
    THIS.ClearItems 

PROCEDURE GetAddr 
    THIS.LockData 
RETURN THIS.RcpsBuffer.GetAddr() 

PROCEDURE LockData 
    THIS.UnlockData 

    LOCAL lcBuffer, ii 
    lcBuffer = "" 
    FOR ii=1 TO THIS.ItemCount 
        lcBuffer = lcBuffer + THIS.arrRecip[ii].GetValue() 
    ENDFOR 
    THIS.RcpsBuffer = CreateObject("PChar", lcBuffer) 

PROCEDURE UnlockData 
    IF TYPE("THIS.RcpsBuffer") = "O" 
        THIS.RcpsBuffer.ReleaseString 
        THIS.RcpsBuffer=.F. 
    ENDIF 

PROCEDURE AppendItem (lnClass, lcName, lcAddress) 
    THIS.ItemCount = THIS.ItemCount + 1 
    DIMEN THIS.arrRecip[THIS.ItemCount] 
    THIS.arrRecip[THIS.ItemCount] = CreateObject("TRecipient", lnClass, lcName, lcAddress) 

PROCEDURE ClearItems 
    LOCAL ii 
    FOR ii=1 TO THIS.ItemCount 
        THIS.arrRecip[ii].ReleaseRecipient 
        THIS.arrRecip[ii]=.F. 
    ENDFOR 
    THIS.ItemCount = 0 
    DIMEN THIS.arrRecip[1] 
ENDDEFINE  && trecipients 

DEFINE CLASS TRecipient As Custom 
    RcpClass=0  && 0-sender, 1-primary rec., 2-copy rec., 3-blind copy rec. 
    RcpName=.F. 
    RcpAddress=.F. 
    RcpBuffer="" 

PROCEDURE Init (lnClass, lcName, lcAddress) 
    THIS.InitRecipient(lnClass, lcName, lcAddress) 

PROCEDURE Destroy 
    THIS.ReleaseRecipient 

PROCEDURE ReleaseRecipient 
    IF TYPE("THIS.RcpAddress")="O" 
        THIS.RcpAddress.ReleaseString 
        THIS.RcpAddress=.F. 
    ENDIF 
    IF TYPE("THIS.RcpName")="O" 
        THIS.RcpName.ReleaseString 
        THIS.RcpName=.F. 
    ENDIF 

PROCEDURE InitRecipient (lnClass, lcName, lcAddress) 
    THIS.ReleaseRecipient 
    THIS.RcpName = CreateObject("PChar", lcName) 
    THIS.RcpAddress = CreateObject("PChar", lcAddress) 

    THIS.RcpBuffer = num2dword(0) +; 
        num2dword(lnClass) +; 
        num2dword(THIS.RcpName.getAddr()) +; 
        num2dword(THIS.RcpAddress.getAddr()) +; 
        num2dword(0) + num2dword(0) 

FUNCTION GetValue 
RETURN THIS.RcpBuffer 
ENDDEFINE  && trecipient 

DEFINE CLASS TAttachments As Custom 
    ItemCount=0 
    DIMEN arrAttach[1] 
    AttsBuffer=.F. 

PROCEDURE Destroy 
    THIS.UnlockData 
    THIS.ClearItems 

PROCEDURE GetAddr 
    THIS.LockData 
RETURN THIS.AttsBuffer.GetAddr() 

PROCEDURE LockData 
    THIS.UnlockData 

    LOCAL lcBuffer, ii 
    lcBuffer = "" 
    FOR ii=1 TO THIS.ItemCount 
        lcBuffer = lcBuffer + THIS.arrAttach[ii].GetValue() 
    ENDFOR 
    THIS.AttsBuffer = CreateObject("PChar", lcBuffer) 

PROCEDURE UnlockData 
    IF TYPE("THIS.AttsBuffer") = "O" 
        THIS.AttsBuffer.ReleaseString 
        THIS.AttsBuffer=.F. 
    ENDIF 

PROCEDURE AppendItem (lcFilename) 
    IF FILE(lcFilename) 
        THIS.ItemCount = THIS.ItemCount + 1 
        DIMEN THIS.arrAttach[THIS.ItemCount] 
        THIS.arrAttach[THIS.ItemCount] = CreateObj("TAttachment", lcFilename) 
        RETURN TYPE("THIS.arrAttach[THIS.ItemCount]") = "O" 
    ELSE 
        RETURN .F. 
    ENDIF 

PROCEDURE ClearItems 
    LOCAL ii 
    FOR ii=1 TO THIS.ItemCount 
        THIS.arrAttach[ii].ReleaseAttachment 
        THIS.arrAttach[ii]=.F. 
    ENDFOR 
    THIS.ItemCount= 0 
    DIMEN THIS.arrAttach[1] 
ENDDEFINE  && tattachments 

DEFINE CLASS TAttachment As Custom 
    AttBuffer="" 
    AttFilename=.F. 

PROCEDURE Init (lcFilename) 
    THIS.InitAttachment(lcFilename) 

PROCEDURE Destroy 
    THIS.ReleaseAttachment 

PROCEDURE InitAttachment (lcFilename) 
    THIS.ReleaseAttachment 
    THIS.AttFilename = CreateObject("PChar", lcFilename) 

    THIS.AttBuffer = num2dword(0) +; 
        num2dword(0) +; 
        num2dword(0) +; 
        num2dword(THIS.AttFilename.GetAddr()) +; 
        num2dword(0) + num2dword(0) 

PROCEDURE ReleaseAttachment 
    IF TYPE("THIS.AttFilename")="O" 
        THIS.AttFilename.ReleaseString 
        THIS.AttFilename=.F. 
    ENDIF 

FUNCTION GetValue 
RETURN THIS.AttBuffer 
ENDDEFINE  && tattachment 

DEFINE CLASS PChar As Custom 
    PROTECTED hMem 

PROCEDURE  Init (lcString) 
    THIS.hMem = 0 
    THIS.setValue (lcString) 

PROCEDURE Destroy 
    THIS.ReleaseString 

FUNCTION GetAddr  && returns a pointer to the string 
RETURN THIS.hMem 

FUNCTION GetValue && returns string value 
    LOCAL lnSize, lcBuffer 
    lnSize = THIS.getAllocSize() 
    lcBuffer = SPACE(lnSize) 

    IF THIS.hMem <> 0 
        DECLARE RtlMoveMemory IN kernel32 As Heap2Str; 
            STRING @, INTEGER, INTEGER 
        = Heap2Str (@lcBuffer, THIS.hMem, lnSize) 
    ENDIF 
RETURN lcBuffer 

FUNCTION GetAllocSize  && returns allocated memory size (string length) 
    DECLARE INTEGER GlobalSize IN kernel32 INTEGER hMem 
RETURN Iif(THIS.hMem=0, 0, GlobalSize(THIS.hMem)) 

PROCEDURE SetValue (lcString) && assigns new string value 
#DEFINE GMEM_FIXED   0 
    THIS.ReleaseString 

    DECLARE INTEGER GlobalAlloc IN kernel32 INTEGER, INTEGER 
    DECLARE RtlMoveMemory IN kernel32 As Str2Heap; 
        INTEGER, STRING @, INTEGER 

    LOCAL lnSize 
    lcString = lcString + Chr(0) 
    lnSize = Len(lcString) 
    THIS.hMem = GlobalAlloc (GMEM_FIXED, lnSize) 
    IF THIS.hMem <> 0 
        = Str2Heap (THIS.hMem, @lcString, lnSize) 
    ENDIF 
         
PROCEDURE ReleaseString  && releases allocated memory 
    IF THIS.hMem <> 0 
        DECLARE INTEGER GlobalFree IN kernel32 INTEGER 
        = GlobalFree (THIS.hMem) 
        THIS.hMem = 0 
    ENDIF 
ENDDEFINE  && pchar 

FUNCTION  num2dword (lnValue) 
#DEFINE m0       256 
#DEFINE m1     65536 
#DEFINE m2  16777216 
    LOCAL b0, b1, b2, b3 
    b3 = Int(lnValue/m2) 
    b2 = Int((lnValue - b3*m2)/m1) 
    b1 = Int((lnValue - b3*m2 - b2*m1)/m0) 
    b0 = Mod(lnValue, m0) 
RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3) 

