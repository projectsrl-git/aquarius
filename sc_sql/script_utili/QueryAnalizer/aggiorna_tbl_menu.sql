SELECT * FROM TBL_MENU  order by menu 

SELECT * FROM TBL_MENU where menu = 'gestionecontrollomagazzino' order by menu 

SELECT * FROM TBL_MENU where autorizzazione= 0 order by menu 

UPDATE TBL_MENU SET autorizzazione = 1  WHERE autorizzazione = 0 
