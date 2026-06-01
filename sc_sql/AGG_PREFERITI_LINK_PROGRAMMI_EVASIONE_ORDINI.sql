
/*
**********************************************************************************************************************
*** AGGIORNA NELLA TABELLA DEL MENU PREFERITI I LINK AI PROGRAMMI DI EVASIONE DA ORDINI CON IL LINK AL NUOVO PROGRAMMA
**********************************************************************************************************************
*/

UPDATE PREFERITI SET TAG = 'DO FORM FORM\MENU_ORDTOBOL WITH 2,2 LINKED' WHERE TAG = 'do form form\menu_otob000 linked'
UPDATE PREFERITI SET TAG = 'DO FORM FORM\MENU_ORDTOBOL WITH 1,2 LINKED' WHERE TAG = 'do form form\menu_otob001 linked'
UPDATE PREFERITI SET TAG = 'DO FORM FORM\MENU_ORDTOBOL WITH 2,1 LINKED' WHERE TAG = 'do form form\menu_otob002 linked'
UPDATE PREFERITI SET TAG = 'DO FORM FORM\MENU_ORDTOBOL WITH 1,1 LINKED' WHERE TAG = 'do form form\menu_otob003 linked'

SELECT * FROM PREFERITI WHERE TAG LIKE '%MENU_ORDTOBOL%'