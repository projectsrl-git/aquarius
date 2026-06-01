
select * from tbl_menu where label = 'aggiornamento listino cliente/linea/articolo'
select * from tbl_menu where menu = 'gestionelistini8' order by ordine
UPDATE TBL_MENU SET UTENTI = (SELECT TOP 1 UTENTI FROM TBL_MENU WHERE MENU = 'gestionelistini8' ORDER BY ORDINE) WHERE MENU = 'gestionelistini8'


select * from tbl_menu where label = 'aggiornamento clienti/articoli'
select * from tbl_menu where menu = 'gestionelistini2' order by ordine
UPDATE TBL_MENU SET UTENTI = (SELECT TOP 1 UTENTI FROM TBL_MENU WHERE MENU = 'gestionelistini2' ORDER BY ORDINE) WHERE MENU = 'gestionelistini2'

         
select * from tbl_menu where label = 'Gestione listino cliente/articolo/altezza/lungh.' 
select * from tbl_menu where menu = 'Gestionelistini10' order by ordine     
UPDATE TBL_MENU SET UTENTI = (SELECT TOP 1 UTENTI FROM TBL_MENU WHERE MENU = 'Gestionelistini10' ORDER BY ORDINE) WHERE MENU = 'Gestionelistini10'
                                     
select * from tbl_menu where label = 'Gestione listino zona/agente' 	
select * from tbl_menu where menu = 'Gestionelistini3' order by ordine   
UPDATE TBL_MENU SET UTENTI = (SELECT TOP 1 UTENTI FROM TBL_MENU WHERE MENU = 'Gestionelistini3' ORDER BY ORDINE) WHERE MENU = 'Gestionelistini3'
                                     
								 
select * from tbl_menu where label = 'Gestione listini per cliente tipo prod. spessore' 	
select * from tbl_menu where menu = 'gestionelistiniclientetipoprodottospessore' order by ordine  
UPDATE TBL_MENU SET UTENTI = (SELECT TOP 1 UTENTI FROM TBL_MENU WHERE MENU = 'gestionelistiniclientetipoprodottospessore' ORDER BY ORDINE) WHERE MENU = 'gestionelistiniclientetipoprodottospessore'
                  
				  
select * from tbl_menu where menu = 'gestionelistini8' order by ordine

select * from tbl_menu where menu = 'gestionelistini2' order by ordine

select * from tbl_menu where menu = 'Gestionelistini7' order by ordine     
	
select * from tbl_menu where menu = 'Gestionelistini3' order by ordine   
                                    
select * from tbl_menu where menu = 'gestionelistiniclientetipoprodottospessore' order by ordine  				  
				  
select * from tbl_menu where label = 'Abilita listini' 