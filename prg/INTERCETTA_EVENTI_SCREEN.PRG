
RELEASE oMainHandler
PUBLIC oMainHandler
oMainHandler=NEWOBJECT("mymainhandler")

Local oObjRif
oObjRif = _screen
BINDEVENT(oObjRif,"Paint",oMainHandler,"myPaint",1)
BINDEVENT(oObjRif,"Deactivate",oMainHandler,"myDeactivate",1)
BINDEVENT(oObjRif,"Resize",oMainHandler,"myResize",1)

DEFINE CLASS mymainhandler AS Custom
	
	PROCEDURE myPaint
		
		LOCAL SWSX
		SWSX=SELECT()
		
		DO SET_SCREEN_CAPTION
		
		SELECT(SWSX)
		
		RETURN
		
	ENDPROC
	
	PROCEDURE myDeactivate
		
		LOCAL SWSX
		SWSX=SELECT()
		
		DO SET_SCREEN_CAPTION
		
		SELECT(SWSX)
		
		RETURN
		
	ENDPROC
	
	PROCEDURE myResize
		
		LOCAL SWSX
		SWSX=SELECT()
		
		DO SET_SCREEN_CAPTION
		
		SELECT(SWSX)
		
		RETURN
		
	ENDPROC
	
ENDDEFINE

