*!*	*****************************************
*!*	CONFIGURAZIONE BUILD AQUARIUS
*!*	*****************************************
*!*	Esempio:
*!*	
*!*	PATH_AQUARIUS=c:\aquarius
*!*	PATH_SC_SQL=c:\aquarius\SC_SQL
*!*	PATH_DA_ESEGUIRE=c:\aquarius\SC_SQL\DA_ESEGUIRE
*!*	PATH_LOG=C:\AQUARIUS\SC_SQL\LOG
*!*	PATH_BINN_SQL="C:\Program Files\Microsoft SQL Server\110\Tools\Binn"
*!*	
*!*	

PATH_AQUARIUS=D:\AS\aquarius
PATH_SC_SQL=D:\AS\aquarius\SC_SQL
PATH_DA_ESEGUIRE=D:\AS\aquarius\SC_SQL\DA_ESEGUIRE
PATH_LOG=D:\AS\AQUARIUS\SC_SQL\LOG
PATH_BINN_SQL="C:\Program Files\Microsoft SQL Server\110\Tools\Binn"


*!*	*****************************************
*!*	CONFIGURAZIONE INVIO MAIL
*!*	*****************************************

INVIA_MAIL_NOTIFICA=SI
MITTENTE=build-aquarius-da-pc-fabiano@projectsrl.net
SMTP=mail.project-online.it
AUTH_USER=assistenza@project-online.local
AUTH_PASS=Project2010
OGGETTO_SUCCESSO=Esecuzione script-sql dal PC di FABIANO AVVENUTA CON SUCCESSO
OGGETTO_ERRORE=ERRORE NELL'ESECUZIONE script-sql dal server AS
CORPO=Questa è una e-mail generata automaticamente.
DESTINATARI=fabiano.moda@gmail.com,fabiano.moda@projectsrl.net,sergio.piaggi@projectsrl.net

