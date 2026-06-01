
_SCREEN.Visible = .F.

CLEAR ALL
CLOSE ALL

WAIT windows "Processo Aq_service attivato" TIMEOUT 1

SET MULTILOCKS ON 
PUBLIC pub_sqlhd,pub_datawh
pub_sqlhd  = 0
pub_datawh = ""


DO PRG\STARTSET

SET PROCEDURE TO PRG\SCHEDULERLIB			ADDITIVE


_SCREEN.AddObject("AqSchedulerTimer_01","AqScheduler_01_Timer")
*_SCREEN.AqSchedulerTimer_01.Interval = 3600000  && ATTIVO IL TIMER OGNI ORA (3600x1000)
*_SCREEN.AqSchedulerTimer_01.Interval = 30000  && ATTIVO IL TIMER OGNI 30 SECONDI (30x1000)
*_SCREEN.AqSchedulerTimer_01.Interval = 3000  && ATTIVO IL TIMER OGNI 3 SECONDI (50x1000)
_SCREEN.AqSchedulerTimer_01.Interval = 5000  && ATTIVO IL TIMER OGNI 5 SECONDI (50x1000)


_SCREEN.AddObject("AqSchedulerTimer_02","AqScheduler_02_Timer")
*_SCREEN.AqSchedulerTimer_02.Interval = 61000  && ATTIVO IL TIMER OGNI 61 SECONDI (61x1000)
*_SCREEN.AqSchedulerTimer_02.Interval = 7000  && ATTIVO IL TIMER OGNI 7 SECONDI (6x1000)
_SCREEN.AqSchedulerTimer_02.Interval = 5000  && ATTIVO IL TIMER OGNI 5 SECONDI (50x1000)

READ EVENTS
