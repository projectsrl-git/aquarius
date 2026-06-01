delete from MENU
where flag='S'

-- MENU

INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO) 
values('DASHBOARD','Dashboard','S','AUP','astro?FUNCTIONID=Home','0','','','fa fa-dashboard fa-fw','')


INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO) 
values('NUOVO_PREVENTIVO','Intervento','S','AU','astro?FUNCTIONID=Interventi','1','','','fa fa-edit fa-fw','')


INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO) 
values('NUOVO_ORDINE','Nuovo ordine cliente','S','AU','astro?FUNCTIONID=Ordini','2','','','fa fa-edit fa-fw','')

INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO) 
values('NUOVO_ORDINE_INTERNO','Nuovo ordine laboratorio','S','AP','astro?FUNCTIONID=OrdiniInterni','3','','','fa fa-edit fa-fw','')

INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('SPOSTAMENTO','Da Laboratorio a Negozio','S','AP','astro?FUNCTIONID=Spostamento','4','','','fa fa-shopping-cart fa-fw','')

INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('CALENDARIO','Calendario','S','AUP','astro?FUNCTIONID=Calendario','5','','','fa fa-table fa-fw','')

INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('AVANZAMENTO_PRODUZIONE','Avanzamento produzione','S','','astro?FUNCTIONID=AvanzamentoProduzione','6','','','fa fa-wrench fa-fw','')

INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('PROD_DETTAGLIATO','Avanzamento produzione','S','AUP','astro?FUNCTIONID=AvanzamentoProduzioneDettagliato','7','','','fa fa-wrench fa-fw','')


INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('RIEPILOGO_ORDINI','Riepilogo ordini','S','AUP','astro?FUNCTIONID=RiepilogoOrdini','8','','','fa fa-map-o fa-fw','')

INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('RIEP_ORD_PEZ','Riepilogo ordini per prodotto/pezzatura','S','AUP','astro?FUNCTIONID=RiepilogoOrdiniProdottoPezzatura','9','','','fa fa-file-text fa-fw','')


INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('ARCHIVIO','Archivio','S','AUP','astro?FUNCTIONID=Archivio','A','','','fa fa-archive fa-fw','')


INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('CONFIGURAZIONE','Configurazione','S','AUP','#','B','','','fa fa-cogs fa-fw','')

INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('CAMBIO_PASSWORD','Cambio password','S','AUP','astro?FUNCTIONID=CambioPassword','B0','','','fa fa-key fa-fw','')

INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('UTENTI','Utenti','S','A','astro?FUNCTIONID=Utenti','B1','','','fa fa-user fa-fw','')


INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('AZIENDA','Azienda','S','A','astro?FUNCTIONID=Azienda','B2','','','fa fa-industry fa-fw','')

INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('CLASSIFICAZIONI','Classificazioni','S','A','astro?FUNCTIONID=Classificazioni','B3','','','fa fa-eye fa-fw','')

INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('RUOLI','Ruoli','S','A','astro?FUNCTIONID=Parametri','B4','','','fa fa-shield fa-fw','')


INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('MENU','Menu','S','A','astro?FUNCTIONID=ConfigurazioneMenu','B5','','','fa fa-list-ul fa-fw','')


INSERT INTO MENU (CODICE,DESCRIZIONE,FLAG,RUOLI,LINK,ORDINE,COLORE,DIMENSIONE,IMMAGINE,TESTO)
values('LOGOUT','Logout','S','AUP','astro?FUNCTIONID=Logout','C','','','fa fa-sign-out fa-fw','')







select * from MENU 
where flag='S'
and len(ordine)>=2
order by ordine



SELECT DISTINCT CODICE,DESCRIZIONE,RUOLI,LINK,ORDINE 
FROM MENU 
LEFT OUTER JOIN UTENTI 
ON MENU.RUOLI LIKE '%'+UTENTI.RUOLO+'%' 
WHERE UTENTI.RUOLO = 'A' 
AND MENU.FLAG = 'S' 
--AND LEN(MENU.ORDINE)=2
ORDER BY MENU.ORDINE


