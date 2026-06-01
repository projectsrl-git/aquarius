
/*
************************************************************************************************************
*** AGGIORNA NELLA TABELLA DEI MENU I LINK AI PROGRAMMI DI EVASIONE DA ORDINI CON IL LINK AL NUOVO PROGRAMMA
************************************************************************************************************
*/

UPDATE TBL_MENU SET COMANDO = 'DO FORM FORM\MENU_ORDTOBOL WITH 2,2 LINKED' where menu = 'gestioneordiniclienti1' and ordine = 1
UPDATE TBL_MENU SET COMANDO = 'DO FORM FORM\MENU_ORDTOBOL WITH 1,2 LINKED' where menu = 'gestioneordiniclienti1' and ordine = 2
UPDATE TBL_MENU SET COMANDO = 'DO FORM FORM\MENU_ORDTOBOL WITH 2,1 LINKED' where menu = 'gestioneordiniclienti1' and ordine = 3
UPDATE TBL_MENU SET COMANDO = 'DO FORM FORM\MENU_ORDTOBOL WITH 1,1 LINKED' where menu = 'gestioneordiniclienti1' and ordine = 4


SELECT * FROM TBL_MENU WHERE COMANDO LIKE '%MENU_ORDTOBOL%' order by ordine