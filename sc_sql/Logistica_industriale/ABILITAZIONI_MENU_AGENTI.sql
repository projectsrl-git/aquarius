SELECT RTRIM(SUBSTRING(UTENTI,1,8000)) + 'P_AZZARO.P01_DELFRANCIA.A_BORGHI.A01_FELICI.' AS NEW_UTENTI,* FROM TBL_MENU --WHERE UTENTI LIKE '%AGEA01%'
SELECT * FROM TBL_MENU WHERE RTRIM(MENU)+RTRIM(LABEL) IN (
'gestioneordiniclientiAggiornamento',
'gestioneordiniclienti4Portafoglio ordini clienti',
'gestionemovimentimagazzinoSituazione giacenze di magazzino',  
'gestioneordiniclientiPortafoglio ordini clienti'
)

/*
UPDATE TBL_MENU SET UTENTI = RTRIM(SUBSTRING(UTENTI,1,8000)) + 'P_AZZARO.P01_DELFRANCIA.A_BORGHI.A01_FELICI.'
WHERE
	RTRIM(SUBSTRING(UTENTI,1,8000)) NOT LIKE '%P_AZZARO.P01_DELFRANCIA.A_BORGHI.A01_FELICI.%' AND 
	RTRIM(MENU)+RTRIM(LABEL) IN (
'gestioneordiniclientiAggiornamento',
'gestioneordiniclienti4Portafoglio ordini clienti',
'gestionemovimentimagazzinoSituazione giacenze di magazzino',  
'gestioneordiniclientiPortafoglio ordini clienti'
)
*/