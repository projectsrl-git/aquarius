
/*
POPOLAMENTO UTENTI AUTORIZZATI ALL'ACCESSO ALLE VOCI DI MENU RIORGANIZZATE DA MENU PRINCIPALE CLIENTI => DDT
*/

UPDATE TBL_MENU SET UTENTI = (SELECT UTENTI FROM TBL_MENU WHERE MENU = 'gestioneddt11' AND LABEL = 'Aggiornamento') WHERE menu = 'gestioneddt' AND LABEL = 'Consegna a clienti'

UPDATE TBL_MENU SET UTENTI = (SELECT UTENTI FROM TBL_MENU WHERE MENU = 'gestioneddt11' AND LABEL = 'Aggiornamento') WHERE menu = 'gestioneddt11' AND LABEL = 'Elenchi'

UPDATE TBL_MENU SET UTENTI = (SELECT UTENTI FROM TBL_MENU WHERE MENU = 'gestioneddt1' AND LABEL = 'Consegna a fornitore') WHERE menu = 'gestioneddt' AND LABEL = 'Consegna a fornitori'
UPDATE TBL_MENU SET UTENTI = (SELECT UTENTI FROM TBL_MENU WHERE MENU = 'gestioneddt1' AND LABEL = 'Consegna a fornitore') WHERE menu = 'gestioneddt010' AND LABEL = 'Aggiornamento'
UPDATE TBL_MENU SET UTENTI = (SELECT UTENTI FROM TBL_MENU WHERE MENU = 'gestioneddt1' AND LABEL = 'Consegna a fornitore') WHERE menu = 'gestioneddt010' AND LABEL = 'Annullo con selezione'

