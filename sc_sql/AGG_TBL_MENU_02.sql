/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[TBL_MENU] ADD 
	 ICONA varchar(200) COLLATE Latin1_General_CI_AS NULL,
 	 LIVELLO_MENU NUMERIC(1,0) NULL,
	 VISIBILE_SE varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[TBL_MENU] WITH NOCHECK ADD 
	CONSTRAINT [DF_TBL_MENU_ICONA] DEFAULT ('') FOR [ICONA],
	CONSTRAINT [DF_TBL_MENU_LIVELLO_MENU] DEFAULT (0) FOR [LIVELLO_MENU],
	CONSTRAINT [DF_TBL_MENU_VISIBILE_SE] DEFAULT ('') FOR [VISIBILE_SE]
go


UPDATE TBL_MENU SET ICONA 	= ''
UPDATE TBL_MENU SET LIVELLO_MENU = 0
UPDATE TBL_MENU SET VISIBILE_SE = ''


-- cancella le voci della winmain

delete from tbl_menu where menu in ('clienti','fornitori','consulenza','magazzino','produzione','contabilit','statistich','parametri','opzioni','help')

-- cancella le voci della winmain

INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,LIVELLO_MENU) VALUES (1 ,RTRIM('clienti   '),RTRIM('Clienti    '),'','','',1,1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,LIVELLO_MENU) VALUES (2 ,RTRIM('fornitori '),RTRIM('Fornitori  '),'','','',1,1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,LIVELLO_MENU) VALUES (3 ,RTRIM('consulenza'),RTRIM('Consulenza '),'','','',1,1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,LIVELLO_MENU) VALUES (4 ,RTRIM('magazzino '),RTRIM('Magazzino  '),'','','',1,1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,LIVELLO_MENU) VALUES (5 ,RTRIM('produzione'),RTRIM('Produzione '),'','','',1,1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,LIVELLO_MENU) VALUES (6 ,RTRIM('contabilit'),RTRIM('Contabilità'),'','','',1,1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,LIVELLO_MENU) VALUES (7 ,RTRIM('statistich'),RTRIM('Statistiche'),'','','',1,1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,LIVELLO_MENU) VALUES (8 ,RTRIM('parametri '),RTRIM('Parametri  '),'','','',1,1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,LIVELLO_MENU) VALUES (9 ,RTRIM('opzioni   '),RTRIM('Opzioni    '),'','','',1,1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,LIVELLO_MENU) VALUES (10,RTRIM('help      '),RTRIM('?          '),'','','',1,1)

--- SECONDO LIVELLO
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (1 ,'clienti','Anagrafica'			,RTRIM('do form form\submenu with ''gestioneclienti'',''Gestione anagrafe clienti'' linked        ')		,'','',1,'bmp\mission.jpg')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (2 ,'clienti','\-'					,RTRIM('                                                                                          ')		,'','',1,'')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (3 ,'clienti','Ristampa documenti' 	,RTRIM('do form form\submenu with  ''gestioneristampadocumenti'',''Gestione ristampa documenti'' linked')	,'','',1,'bmp\ambiente\aqtoolbar\_ristampa_documenti.bmp')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (4 ,'clienti','Preventivi clienti' 	,RTRIM('do form form\submenu with  ''gestioneofferte'',''Gestione preventivi clienti'' linked          ')	,'','',1,'bmp\icone\clients.bmp')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (5 ,'clienti','Ordini clienti' 		,RTRIM('do form form\submenu with  ''gestioneordiniclienti'',''Gestione ordini clienti'' linked        ')	,'','',1,'ico\documenti0048.gif')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (6 ,'clienti','Documenti di trasporto',RTRIM('do form form\submenu with ''gestioneddt'',''Gestione documenti di trasporto'' linked         ')	,'','',1,'bmp\flag.bmp')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (7 ,'clienti','Fatture proforma' 	,RTRIM('do form form\submenu with  ''gestionefattureproforma'',''Gestione fatture proforma'' linked    ')	,'','',1,'ico\documenti0051.gif')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (8 ,'clienti','Fatture clienti' 		,RTRIM('do form form\submenu with  ''gestionefatture'',''Gestione fatture clienti'' linked             ')	,'','',1,'ico\euro_costi.gif')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (9 ,'clienti','\-'					,RTRIM('                                                                                          ')		,'','',1,'')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (10,'clienti','Cambi' 				,RTRIM('do form form\submenu with ''gestionecambi'',''Gestione cambi'' linked                         ')	,'','',1,'ico\10.gif')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (11,'clienti','Comuni' 				,RTRIM('do form form\submenu with ''gestionecomuni'',''Gestione comuni'' linked                       ')	,'','',1,'bmp\frx2rtf.bmp')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (12,'clienti','Località di consegna' ,RTRIM('do form form\submenu with ''gestionelocalita'',''Gestione località di consegna'' linked       ')	,'','',1,'bmp\fiore4.jpg')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (13,'clienti','Banche' 				,RTRIM('do form form\submenu with ''gestionebanche'',''Gestione banche'' linked                       ')	,'','',1,'ico\i_bank.gif')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (14,'clienti','Business unit' 		,RTRIM('do form form\submenu with ''gestionebusinesunit'',''Gestione business Unit'' linked           ')	,'','',1,'ico\documenti1.gif')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (15,'clienti','Portafoglio effetti' 	,RTRIM('do form form\submenu with ''gestioneportafoglioeffetti'',''Gestione ricevute bancarie'' linked')	,'','',1,'ico\iconacontocorrente0.gif')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (16,'clienti','\-'					,RTRIM('                                                                                          ')		,'','',1,'')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (17,'clienti','Listini' 				,RTRIM('do form form\submenu with ''gestionelistini'',''Gestione listini'' linked                     ')	,'','',1,'ico\euro.jpg')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (18,'clienti','Sconti' 				,RTRIM('do form form\submenu with ''gestionesconticategoriamerceologica'',''Gestione sconti'' linked  ')	,'','',1,'bmp\icone\_cut.bmp')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (19,'clienti','Agenti' 				,RTRIM('do form form\submenu with ''gestioneagenti'',''Gestione agenti'' linked                       ')	,'','',1,'bmp\dito_ok.gif')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE,ICONA) VALUES (20,'clienti','Provvigioni' 			,RTRIM('do form form\submenu with ''gestioneprovvigioni'',''Gestione provvigioni'' linked             ')	,'','',1,'ico\soldi.gif')



INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 1  ,'fornitori','Anagrafica' 						, 'ico\mission.gif'								,  'do form form\submenu with ''gestionefornitori'',''Gestione anagrafe fornitori'' linked','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 2  ,'fornitori','\-'																			,'',   '','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 3  ,'fornitori','Ristampa documenti' 				, 'bmp\ambiente\aqtoolbar\_ristampa_documenti.bmp','do form form\submenu with ''gestioneristampadocumenti'',''Gestione ristampa documenti'' linked','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 4  ,'fornitori','\-'                                                                                 ,'','','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 5  ,'fornitori','Richieste di acquisto' 			, 'bmp\winmain\_notepad.png'                      ,'DO form form\submenu with ''gestionerichiesteacquisto'',''Gestione richieste di acquisto'' linked','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 6  ,'fornitori','Ordini di acquisto' 				, 'ico\crdfle11.ico'                              ,'DO form form\submenu with ''gestioneordinifornitori'',''Gestione ordini  di acquisto'' linked','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 7  ,'fornitori','Listini fornitori' 				, 'bmp\cs.png'                                    ,'DO form form\submenu NAME ORFO2 with ''gestionelistinifornitori'',''Gestione listini fornitori '' linked','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 8  ,'fornitori','Sconti su listini fornitori' 	, 'bmp\icone\_cut.bmp'                                ,'DO form form\submenu NAME ORFO3 with ''gestionescontifornitori'',''Gestione sconti su listini fornitori '' linked','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 9  ,'fornitori','\-'                                                                                 ,'','','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 10 ,'fornitori','Documenti da fornitori' 			, 'bmp\fornitori.gif'                             ,'DO form form\submenu NAME LIST1 with ''gestioneddt6'',''Documenti da fornitori'' linked','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 11 ,'fornitori','Documenti di reso a fornitori' 	, 'bmp\dito_ko.gif'                               ,'do form form\submenu NAME LIST1 with ''gestioneddt14'',''Documenti di reso a fornitori'' linked','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 12 ,'fornitori','\-'                                                                                 ,'','','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 13 ,'fornitori','Contratti fornitori' 			, 'bmp\icone\blocca_1.bmp'                            ,'do form form\submenu NAME LIST1 with ''gestionextracontabile5'',''Gestione contratti'' linked','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 14 ,'fornitori','Documenti di conto lavoro' 		, 'ico\crdfle07.ico'                              ,'do form form\submenu with ''gestioneordiniclavoro'',''Gestione documenti di conto lavoro'' linked','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 15 ,'fornitori','Proposte ordini a fornitore' 	, 'ico\ico_mail.gif'                                  ,'do form form\submenu with ''gestioneproposteordinifornitori'',''Gestione proposte ordini a fornitori'' linked','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 16 ,'fornitori','Trasporti' 						, 'bmp\winmain\trasporti.png'                     ,'do form form\submenu NAME LIST1 with ''gestionetrasporti'',''Gestione Trasporti'' linked','','',1)

INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 1 ,'consulenza','Gestione risorse' , 'bmp\winmain\risorse.gif'                     ,'do form form\submenu NAME LIST1 with ''gestionerisorse'',''Gestione risorse umane'' linked','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,DESCRIZION,UTENTI,AUTORIZZAZIONE) VALUES ( 2 ,'consulenza','Studi professionali' , 'bmp\winmain\ventiquattrore.jpg'                     ,'do form form\submenu NAME LIST1 with ''gestionestudi'',''Gestione Studi Professionali'' linked','','',1)


INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 1 ,'magazzino','Anagrafica articoli' , 'bmp\icone\articoli.bmp'       ,'do form form\submenu with ''gestionearticoli'',''Gestione anagrafe articoli'' linked                             ',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 2 ,'magazzino','Controllo e gestione del magazzino' , 'bmp\item2.bmp' ,'do form form\submenu with ''gestionecontrollomagazzino'',''Controllo e gestione del magazzino'' linked           ',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 3 ,'magazzino','Movimenti di magazzino' , 'bmp\muletto.gif'           ,'do form form\submenu with ''gestionemovimentimagazzino'',''Gestione movimenti di magazzino'' linked              ',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 4 ,'magazzino','Magazzino a locazioni' , 'ico\ico_integrati.gif'      ,'do form form\submenu with ''gestionemagazzinologistico'',''Gestione magazzino a locazioni'' linked               ',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 5 ,'magazzino','Magazzino documenti cartacei' , 'folder04.ico'        ,'do form form\submenu with ''gestionemagazzinodocumenticartacei'',''Gestione magazzino documenti cartacei'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 6 ,'magazzino','Magazzino cartelle sanitarie' , 'bmp\codfiscale.jpg'  ,'do form form\submenu with ''gestionemagazzinocartellesanitarie'',''Gestione magazzino cartelle sanitarie'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 7 ,'magazzino','Inventario di magazzino' , 'bmp\winmain\inventory.gif','do form form\submenu with ''gestioneinventariomagazzino'',''Gestione inventario di magazzino'' linked            ',1)

INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 1 ,'produzione','Distinte base' 	, 'ico\documento5.gif'                                                   ,'do form form\submenu with ''gestionediba'',''Gestione distinte basi'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 2 ,'produzione','Cicli di lavoro' , 'bmp\recycle.gif'                                                       ,'do form form\submenu with ''gestioneciclidilavoro'',''Gestione cicli di lavoro'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE,VISIBILE_SE) VALUES ( 3 ,'produzione','Produzione film protettivi con tappeto prod.' , 'bmp\film_2.gif'                  ,'do form form\submenu with ''gestioneproduzione'',''Gestione produzione'' linked',1,'PUB_PRDFILM')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE,VISIBILE_SE) VALUES ( 4 ,'produzione','Produzione pannelli truciolari' , 'bmp\winmain\truciolare_grezzo24bit.bmp'        ,'do form form\submenu with ''gestioneproduzionepannellitruciolari'',''Gestione produzione pannelli truciolari'' linked',1,'PUB_PRGPLET ')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE,VISIBILE_SE) VALUES ( 5 ,'produzione','Produzione dadi pressati' , 'bmp\icone\dadi_pressati_24bit.bmp'                   ,'do form form\submenu with ''gestioneproduzionedadi'',''Gestione produzione dadi pressati'' linked',1,'PUB_PRGDADI ')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE,VISIBILE_SE) VALUES ( 6 ,'produzione','Produzione standard' , 'bmp\winmain\lavorazione24bit.bmp'                         ,'do form form\submenu with ''Gestioneproduzionestandard'',''Gestione produzione standard'' linked',1,'PUB_PRSSTD ')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE,VISIBILE_SE) VALUES ( 7 ,'produzione','Produzione dispositivi medicali' , 'bmp\icone\device16x16.bmp'                    ,'do form form\submenu with ''Gestioneproduzionedispositivi'',''Gestione produzione dispositivi medicali'' linked',1,'PUB_PRDISP ')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE,VISIBILE_SE) VALUES ( 8 ,'produzione','Produzione macchine industriali' , 'bmp\icone\factory16x16.bmp'                   ,'do form form\submenu with ''Gestioneproduzionemacchine'',''Gestione produzione macchine industriali'' linked',1,'PUB_PRMMOL ')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE,VISIBILE_SE) VALUES ( 9 ,'produzione','Produzione film protettivi con pianificazione' , 'bmp\icone\bobine_film_16x16.bmp','do form form\submenu with ''gestioneproduzionefilmprotettivo'',''Gestione produzione film protettivo'' linked',1,'PUB_PRDFPR ')
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 10 ,'produzione','Controllo qualità' 	, 'ico\zoom_ico.jpg'                                                 ,'do form form\submenu with ''gestionecontrollocq'',''Gestione controllo qualita'' linked',1)

INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 1  ,'contabilit','Prima nota' , 'bmp\ambiente\aqtoolbar\_preferiti.bmp'                            ,'do form form\submenu with ''gestioneprimanota'',''Gestione prima nota'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 2  ,'contabilit','Piano dei conti' , 'bmp\mission.jpg'                                             ,'do form form\submenu with ''gestioneconti'',''Gestione piano dei conti'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 3  ,'contabilit','Centri di costo' , 'bmp\forbice.gif'                                             ,'do form form\submenu with ''gestioneccosto'',''Gestione centri di costo'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 4  ,'contabilit','Partitari' , 'ico\clienti4.gif'                                                  ,'do form form\submenu with ''gestionepartitari'',''Gestione partitari'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 5  ,'contabilit','Bilanci' , 'bmp\icone\balance-32.png'                                            ,'do form form\submenu with ''gestionebilanci'',''Gestione bilanci'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 6  ,'contabilit','Situazioni contabili' , 'bmp\winmain\contabili.gif'                              ,'do form form\submenu with ''gestionecontabili'',''Gestione situazioni contabili'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 7  ,'contabilit','Controllo di gestione' , 'bmp\winmain\controllo_gestione.png'                    ,'do form form\submenu with ''gestionecontrollogestione'',''Controllo di gestione su dati contabili'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 8  ,'contabilit','Bollati' , 'bmp\img28.jpg'                                                       ,'do form form\submenu with ''gestionebollati'',''Gestione bollati'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 9  ,'contabilit','Tesoreria' , 'bmp\winmain\386px-euro_symbol_gold.svg.png'                        ,'do form form\submenu with ''gestionetesoreria'',''Gestione tesoreria'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 10 ,'contabilit','Budget' , 'bmp\ico_integrati_192.gif'                                            ,'do form form\submenu with ''gestionebudget'',''Gestione budget'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 11 ,'contabilit','Acquisti/cessioni intracomunitarie' , 'bmp\winmain\cessioni_intracomunitarie.jpg','do form form\submenu with ''gestionecessioniinta'',''Gestione cessioni intracomunitarie'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 12 ,'contabilit','Ritenute acconto professionisti' , 'bmp\frx2rtf.bmp'                             ,'do form form\submenu with ''gestioneritacconto'',''Gestione ritenute acconto professionisti'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 13 ,'contabilit','Compensi amministratore' , 'bmp\winmain\denaro.gif'                              ,'do form form\submenu with ''gestionecompensiamm'',''Gestione compensi amministratore'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 14 ,'contabilit','Cespiti' , 'bmp\icone\beni durevoli.bmp'                                         ,'do form form\submenu with ''gestionecespiti'',''Gestione cespiti'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 15 ,'contabilit','Anni contabili' , 'bmp\ambiente\aqtoolbar\year.bmp'                              ,'do form form\submenu with ''gestioneannicontabili'',''Gestione anni contabili'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 16 ,'contabilit','Procedure extracontabili' , 'bmp\winmain\cessioni_intracomunitarie.jpg'          ,'do form form\submenu with ''gestionextracontabile'',''Gestione procedure extracontabili'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 17 ,'contabilit','Compensazioni clienti/fornitori' , 'ico\clienti4.gif'                            ,'do form form\submenu with ''gestionecompensazioniclientifornitori'',''Gestione delle compensazioni clienti/fornitori'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 18 ,'contabilit','Business unit' , 'ico\documenti1.gif'                                            ,'do form form\submenu with ''gestionepdvcontabile'',''Gestione Business Unit'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 19 ,'contabilit','Gestione del personale' , 'ico\ico_mappa_clienti.gif'                            ,'do form form\submenu with ''gestionepersonale'',''Gestione personale'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 20 ,'contabilit','\-','','',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 21 ,'contabilit','Trasferimenti contabili' , 'ico\scadenze.gif','do form form\submenu with ''gestionetrasfcontabili'',''Gestione trasferimenti contabili'' linked',1)

INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 1  ,'statistich','Creazione archivio statistico' , 'ico\graph07.ico','do form form\menu_creasta linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 2  ,'statistich','Statistiche varie' , 'bmp\winmain\statistiche.gif','do form form\submenu with ''gestionestatistiche2'',''Statistiche varie'' linked',1)

INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 1  ,'parametri','Gestione parametri' , 'bmp\ambiente\aqtoolbar\_parametri_sistema.bmp','do form form\submenu with ''gestioneparametri'',''Gestione parametri Aquarius'' linked',1)

INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 1  ,'help','Help' , 'bmp\winmain\help_aquarius.bmp','DO PRG\AQUADOC',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 2  ,'help','Informazioni su Aquarius' , 'bmp\winmain\info_aquarius.bmp','DO FORM FORM\INFOVER LINKED',1)


INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 1 ,'opzioni','Documenti' , 'bmp\winmain\documenti.jpg'               ,'do form form\submenu with ''gestionedocumenti'',''Gestione documenti'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 2 ,'opzioni','Utenti' , 'bmp\winmain\utenti.jpg'                     ,'do form form\submenu with ''gestioneutenti'',''Gestione utenti Aquarius'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 3 ,'opzioni','Menù/Procedure' , 'bmp\winmain\accordo_programma.gif'  ,'do form form\submenu with ''gestionemenuprocedure'',''Gestione menù e procedure'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 4 ,'opzioni','Utilità' , 'bmp\winmain\utilita.jpg'                   ,'do form form\submenu with ''gestioneutilità'',''Gestione utilità del sistema'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 5 ,'opzioni','Agenda telefonica' , 'bmp\winmain\rubrica.jpg'         ,'do form form\submenu with ''gestioneagenda'',''Gestione Agenda telefonica'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 6 ,'opzioni','Configurazione' , 'bmp\winmain\configurazione.jpg'     ,'do form form\submenu with ''gestioneconfigurazioni'',''Configurazioni generali'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 7 ,'opzioni','Conversioni' , 'bmp\winmain\conversione.gif'           ,'do form form\submenu with ''gestioneconversioni'',''Conversioni / startup archivi'' linked',1)
INSERT INTO TBL_MENU (ORDINE,MENU,LABEL,ICONA,COMANDO,AUTORIZZAZIONE) VALUES ( 8 ,'opzioni','Gestione carica/scarica tabelle' , 'bmp\winmain\cs.png','do form form\menu_utilarc linked',1)

UPDATE tbl_menu SET LIVELLO_MENU=2 WHERE LIVELLO_MENU=0 AND menu in ('clienti','fornitori','consulenza','magazzino','produzione','contabilit','statistich','parametri','opzioni','help')


