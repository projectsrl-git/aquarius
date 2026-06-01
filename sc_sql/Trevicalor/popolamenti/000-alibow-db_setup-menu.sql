--  MENU
DELETE FROM MENU;
/*ALTER SEQUENCE MENU_id_menu_seq RESTART WITH 1;*/
-- NOTA IMPORTANTE: se la voce di menu corrisponde ad un link effettivo ad una function, usa come campo "alias" il nome stesso della function (es: InserimentoFeriePermessi)

-- MENU 0
INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES (null,0,'Home','astro?FUNCTIONID=Home','nav-icon bi bi-house');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Home'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Home');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Home'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Home');

-- MENU 1
--INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='Home'),08,'itersanificazione','#','fa-solid fa-pump-medical');
--INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='itersanificazione'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Iter sanificazione');
--INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='itersanificazione'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Iter sanitation');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='Home'),10,'Impianto','astro?FUNCTIONID=Impianto','bi bi-info-square size-24');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Impianto'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Impianto');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Impianto'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Impianto');


INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='Home'),12,'Intervento','astro?FUNCTIONID=Intervento','bi bi-info-square size-24');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Intervento'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Intervento');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Intervento'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Intervento');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='Home'),15,'Ricambi','astro?FUNCTIONID=Ricambi','bi bi-cart size-24');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Ricambi'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Ricambi');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Ricambi'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Ricambi');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='Home'),19,'Storico','astro?FUNCTIONID=Storico','bi bi-archive size-24');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Storico'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Storico');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Storico'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Storico');



/*
INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='Home'),25,'Tracking','astro?FUNCTIONID=Tracking','fa fa-columns');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Tracking'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Simulazione cliente');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Tracking'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Customer simulation');



INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='Home'),50,'utility','#','fa-solid fa-cloud-arrow-up');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='utility'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Utility');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='utility'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Utility');



INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='Home'),60,'configurazione','#','fa fa-cogs');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='configurazione'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Configurazione');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='configurazione'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Configuration');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='Home'),65,'manuale','#','fa fa-book');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='manuale'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Manuale');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='manuale'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Manual');




INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='Home'),70,'Assistenza','mailto:assistenza@arjoiris.com?Subject=ArjoSanitize:%20<#if USERNAME?exists>${USERNAME}</#if>','fa-solid fa-paper-plane');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Assistenza'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Assistenza');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Assistenza'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Assistance');

*/
INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='Home'),90,'Logout','astro?FUNCTIONID=Logout','bi bi-box-arrow-right size-24');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Logout'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Logout');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Logout'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Logout');

/*

-- MENU 08 Iter sanificazione
INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='itersanificazione'),10,'PresaInCarico','astro?FUNCTIONID=PresaInCarico','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='PresaInCarico'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Presa in carico');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='PresaInCarico'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Taking charge');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='itersanificazione'),20,'Sanificazione','astro?FUNCTIONID=Sanificazione','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Sanificazione'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Sanificazione');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Sanificazione'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Disinfection');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='itersanificazione'),30,'Controllo','astro?FUNCTIONID=Controllo','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Controllo'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Controllo');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Controllo'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Check');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='itersanificazione'),40,'Riparazione','astro?FUNCTIONID=Riparazione','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Riparazione'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Riparazione');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Riparazione'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Repair');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='itersanificazione'),50,'Conforme','astro?FUNCTIONID=Conforme','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Conforme'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Conforme');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='Conforme'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Compliant');



-- MENU 50 Utility

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='utility'),1,'UtilityVSE','astro?FUNCTIONID=UtilityVSE','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='UtilityVSE'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Upload VSE');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='UtilityVSE'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'VSE Upload');





-- MENU 60 Configurazione


INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='configurazione'),09,'configurazione_aziende','#','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='configurazione_aziende'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Service center');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='configurazione_aziende'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Service center');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='configurazione_aziende'),1,'InserimentoAziende','astro?FUNCTIONID=InserimentoAziende','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='InserimentoAziende'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Inserimento');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='InserimentoAziende'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Insert');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='configurazione_aziende'),2,'RicercaAziende','astro?FUNCTIONID=RicercaAziende','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaAziende'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Ricerca');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaAziende'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Search');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='configurazione'),10,'configurazione_utenti','#','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='configurazione_utenti'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Utenti');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='configurazione_utenti'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Users');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='configurazione_utenti'),1,'InserimentoUtenti','astro?FUNCTIONID=InserimentoUtenti','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='InserimentoUtenti'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Inserimento');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='InserimentoUtenti'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Insert');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='configurazione_utenti'),2,'RicercaUtenti','astro?FUNCTIONID=RicercaUtenti','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaUtenti'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Ricerca');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaUtenti'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Search');

-- domini
INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='configurazione'),19,'domini','#','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='domini'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Tabelle');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='domini'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Tables');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='domini'),1,'InserimentoDomini','astro?FUNCTIONID=InserimentoDomini','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='InserimentoDomini'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Inserimento');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='InserimentoDomini'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Insert');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='domini'),2,'RicercaDomini','astro?FUNCTIONID=RicercaDomini','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaDomini'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Ricerca');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaDomini'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Search');


-- Parametri (inizio)
INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='configurazione'),20,'parametri','#','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='parametri'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Parametri');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='parametri'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Parameters');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='parametri'),1,'InserimentoParametri','astro?FUNCTIONID=InserimentoParametri','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='InserimentoParametri'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Inserimento');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='InserimentoParametri'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Insert');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='parametri'),2,'RicercaParametri','astro?FUNCTIONID=RicercaParametri','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaParametri'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Ricerca');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaParametri'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Search');

-- Profili
INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='configurazione'),30,'profili','#','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='profili'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Profili');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='profili'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Profiles');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='profili'),1,'InserimentoProfili','astro?FUNCTIONID=InserimentoProfili','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='InserimentoProfili'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Inserimento');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='InserimentoProfili'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Insert');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='profili'),2,'RicercaProfili','astro?FUNCTIONID=RicercaProfili','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaProfili'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Ricerca');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaProfili'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Search');

-- Lingue iso (inizio)
delete from menu where alias in ('lingue_iso','InserimentoLingueIso','RicercaLingueIso');
delete from MENU_LINGUE where id_menu in (select id_menu from menu where alias in ('lingue_iso','InserimentoLingueIso','RicercaLingueIso'));

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='configurazione'),40,'lingue_iso','#','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='lingue_iso'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Lingue ISO');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='lingue_iso'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'ISO Languages');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='lingue_iso'),1,'InserimentoLingueIso','astro?FUNCTIONID=InserimentoLingueIso','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='InserimentoLingueIso'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Inserimento');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='InserimentoLingueIso'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Insert');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='lingue_iso'),2,'RicercaLingueIso','astro?FUNCTIONID=RicercaLingueIso','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaLingueIso'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Ricerca');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaLingueIso'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Search');
-- Lingue iso (fine)


INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='configurazione'),80,'RicercaLogEmail','astro?FUNCTIONID=RicercaLogEmail','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaLogEmail'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Log email');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='RicercaLogEmail'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Log email');



-- MENU 65 Manuale
INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='manuale'),10,'ManualeAdministrator','doc/ARJOSANITIZE-Manuale_administrator.pdf','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='ManualeAdministrator'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Administrator');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='ManualeAdministrator'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Administrator');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='manuale'),20,'ManualeOperatore','doc/ARJOSANITIZE-Manuale_operatore.pdf','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='ManualeOperatore'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Operatore');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='ManualeOperatore'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Operator');

INSERT INTO MENU (id_menu_sup,ordine,alias,link,icon) VALUES ((select id_menu from menu where alias ='manuale'),80,'IstruzioniStampante','doc/ARJOSANITIZE-Istruzioni_Honeywell.pdf','');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='IstruzioniStampante'),(select id_lingue_iso from lingue_iso where codice_iso='it'),'Setup Stampante');
INSERT INTO MENU_LINGUE (id_menu,id_lingue_iso,descrizione) VALUES ((select id_menu from menu where alias ='IstruzioniStampante'),(select id_lingue_iso from lingue_iso where codice_iso='en'),'Printer setup');

*/

delete from MENU_PROFILI where ID_PROFILO in (select id_profilo from profili where descrizione in ('Administrator','Tecnico'));
INSERT INTO MENU_PROFILI (ID_MENU,ID_PROFILO) SELECT ID_MENU,(SELECT ID_PROFILO FROM PROFILI WHERE CODICE='ADM') FROM MENU;
INSERT INTO MENU_PROFILI (ID_MENU,ID_PROFILO) SELECT ID_MENU,(SELECT ID_PROFILO FROM PROFILI WHERE CODICE='TEC') FROM MENU;
/*INSERT INTO MENU_PROFILI (ID_MENU,ID_PROFILO) SELECT ID_MENU,(SELECT ID_PROFILO FROM PROFILI WHERE CODICE='ADS') FROM MENU where id_menu in (select id_menu from menu where ALIAS in ('Home','RiepilogoSeriali','StatusSeriali','StampaSeriale','Logout','configurazione'));
INSERT INTO MENU_PROFILI (ID_MENU,ID_PROFILO) SELECT ID_MENU,(SELECT ID_PROFILO FROM PROFILI WHERE CODICE='CLI') FROM MENU where id_menu in (select id_menu from menu where ALIAS in ('Home','RiepilogoSeriali','StatusSeriali','Logout'));
INSERT INTO MENU_PROFILI (ID_MENU,ID_PROFILO) SELECT ID_MENU,(SELECT ID_PROFILO FROM PROFILI WHERE CODICE='OPS') FROM MENU where id_menu in (select id_menu from menu where ALIAS in ('Home','itersanificazione','RiepilogoSeriali','StatusSeriali','Logout'));
*/