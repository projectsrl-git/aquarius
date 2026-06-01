/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Produzione macchine industriali" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Causale di carico per prelievo di magazzino
***		- Causale di scarico per prelievo di magazzino
***		- Causale di carico per versamenti di magazzino
***		- Causale di scarico per versamenti di magazzino
***		- Codice Linea prodotti finiti di produzione interna
***		- Codice Linea semilavorati di produzione interna
***		- Codice Linea semilavorati di produzione esterna
*/

/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Magazzino", sottoscheda "Magazzini per produz.  macchine industriali" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Magazzino di destinazione per il materiale prelevato
***		- Magazzino di destinazione per il materiale versato
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_CAPPMIPREL varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_SCPPMIPREL varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_CAPPMIVERS varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_SCPPMIVERS varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_PMILINPF varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_PMILINSL varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_PMILINSE varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_MAGPMIPREL varchar (6) COLLATE Latin1_General_CI_AS NULL ,
	AZI_MAGPMIVERS varchar (6) COLLATE Latin1_General_CI_AS NULL 
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_CAPPMIPREL] DEFAULT ('') FOR [AZI_CAPPMIPREL],
	CONSTRAINT [DF_U_AZI_PB_AZI_SCPPMIPREL] DEFAULT ('') FOR [AZI_SCPPMIPREL],
	CONSTRAINT [DF_U_AZI_PB_AZI_CAPPMIVERS] DEFAULT ('') FOR [AZI_CAPPMIVERS],
	CONSTRAINT [DF_U_AZI_PB_AZI_SCPPMIVERS] DEFAULT ('') FOR [AZI_SCPPMIVERS],
	CONSTRAINT [DF_U_AZI_PB_AZI_PMILINPF] DEFAULT ('') FOR [AZI_PMILINPF],
	CONSTRAINT [DF_U_AZI_PB_AZI_PMILINSL] DEFAULT ('') FOR [AZI_PMILINSL],
	CONSTRAINT [DF_U_AZI_PB_AZI_PMILINSE] DEFAULT ('') FOR [AZI_PMILINSE],
	CONSTRAINT [DF_U_AZI_PB_AZI_MAGPMIPREL] DEFAULT ('') FOR [AZI_MAGPMIPREL],
	CONSTRAINT [DF_U_AZI_PB_AZI_MAGPMIVERS] DEFAULT ('') FOR [AZI_MAGPMIVERS]
GO

UPDATE U_AZI_PB SET AZI_CAPPMIPREL = ''
UPDATE U_AZI_PB SET AZI_SCPPMIPREL = ''
UPDATE U_AZI_PB SET AZI_CAPPMIVERS = ''
UPDATE U_AZI_PB SET AZI_SCPPMIVERS = ''
UPDATE U_AZI_PB SET AZI_PMILINPF = ''
UPDATE U_AZI_PB SET AZI_PMILINSL = ''
UPDATE U_AZI_PB SET AZI_PMILINSE = ''
UPDATE U_AZI_PB SET AZI_MAGPMIPREL = ''
UPDATE U_AZI_PB SET AZI_MAGPMIVERS = ''
