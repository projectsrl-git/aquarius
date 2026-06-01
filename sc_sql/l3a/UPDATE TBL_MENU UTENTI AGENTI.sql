
SELECT REPLACE(REPLACE(REPLACE(RTRIM(SUBSTRING(UTENTI,1,8000)),'BUFIS.',''),'MAURI.',''),'PALUMBO.','')+'BUFIS.MAURI.PALUMBO.',* FROM TBL_MENU WHERE UTENTI LIKE '%.BUFIS.%'

UPDATE TBL_MENU SET UTENTI = REPLACE(REPLACE(REPLACE(RTRIM(SUBSTRING(UTENTI,1,8000)),'BUFIS.',''),'MAURI.',''),'PALUMBO.','')+'BUFIS.MAURI.PALUMBO.' WHERE RTRIM(MENU)+RTRIM(LABEL) IN (
'gestioneclientiAggiornamento',
'gestionelistiniGestione listini',
'gestionestatistiche2Scheda clienti',
'gestionestatistiche22Venduto con confronto anno precedente',
'gestionelistini9Gestione listino cliente/articolo',
'gestionestatistiche2Statistiche varie per periodo',
'gestioneordiniclienti4Portafoglio ordini clienti',
'gestioneordiniclientiPortafoglio ordini clienti',
'gestionelistini2Stampa listini clienti/articoli')

