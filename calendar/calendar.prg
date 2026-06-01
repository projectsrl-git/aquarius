SET DATE BRITISH
m.INHIBITDAYS	= "SAT,SUN,"
m.LASTCLICKT	= INT(SECONDS()*10)
m.date			= DATE()

SET PATH TO C:\DEV\CALENDAR
DO FORM DATEBASEDFORM

QUIT

FUNCTION TOGGLE
	PARAMETERS m.DATE
	PRIVATE m.DATE
	** this is a function you can use to set up something in a table
	** using the right click on the calendar
	RETURN(.T.)

FUNCTION FIRST_DAY
	PARAMETERS m.FDATE
	PRIVATE m.FDATE
	m.FDATE = CTOD("01/"+STR(MONTH(m.FDATE),2,0)+"/"+STR(YEAR(m.FDATE),4,0))
	RETURN(m.FDATE)

FUNCTION DBLCLICK
	** this function uses the public variable m.LastClickT to return whether
	** or not a double click has been done on an object without a DblClick method
	PRIVATE m.FLG
	m.FLG = .F.
	IF INT(SECONDS()*10) < m.LASTCLICKT+5
		m.FLG = .T.
	ENDIF
	m.LASTCLICKT = INT(SECONDS()*10)
	RETURN(m.FLG)
