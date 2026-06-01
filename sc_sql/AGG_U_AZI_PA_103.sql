/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Produzione dispositivi medicali" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Causale di carico per prelievo di magazzino
***		- Causale di scarico per prelievo di magazzino
***		- Causale di carico per versamenti di magazzino
***		- Causale di scarico per versamenti di magazzino
***		- Codice Linea prodotti finiti di produzione interna
***		- Codice Linea semilavorati di produzione interna
*/

/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Magazzino", sottoscheda "Magazzini per produz. dispositivi medicali" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Magazzino di destinazione per il materiale prelevato
***		- Magazzino di destinazione per il materiale versato
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_CAPPDMPREL varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_SCPPDMPREL varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_CAPPDMVERS varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_SCPPDMVERS varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_PDMLINPF varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_PDMLINSL varchar (3) COLLATE Latin1_General_CI_AS NULL ,
	AZI_MAGPDMPREL varchar (6) COLLATE Latin1_General_CI_AS NULL ,
	AZI_MAGPDMVERS varchar (6) COLLATE Latin1_General_CI_AS NULL 
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_CAPPDMPREL] DEFAULT ('') FOR [AZI_CAPPDMPREL],
	CONSTRAINT [DF_U_AZI_PA_AZI_SCPPDMPREL] DEFAULT ('') FOR [AZI_SCPPDMPREL],
	CONSTRAINT [DF_U_AZI_PA_AZI_CAPPDMVERS] DEFAULT ('') FOR [AZI_CAPPDMVERS],
	CONSTRAINT [DF_U_AZI_PA_AZI_SCPPDMVERS] DEFAULT ('') FOR [AZI_SCPPDMVERS],
	CONSTRAINT [DF_U_AZI_PA_AZI_PDMLINPF] DEFAULT ('') FOR [AZI_PDMLINPF],
	CONSTRAINT [DF_U_AZI_PA_AZI_PDMLINSL] DEFAULT ('') FOR [AZI_PDMLINSL],
	CONSTRAINT [DF_U_AZI_PA_AZI_MAGPDMPREL] DEFAULT ('') FOR [AZI_MAGPDMPREL],
	CONSTRAINT [DF_U_AZI_PA_AZI_MAGPDMVERS] DEFAULT ('') FOR [AZI_MAGPDMVERS]
GO

UPDATE U_AZI_PA SET AZI_CAPPDMPREL = ''
UPDATE U_AZI_PA SET AZI_SCPPDMPREL = ''
UPDATE U_AZI_PA SET AZI_CAPPDMVERS = ''
UPDATE U_AZI_PA SET AZI_SCPPDMVERS = ''
UPDATE U_AZI_PA SET AZI_PDMLINPF = ''
UPDATE U_AZI_PA SET AZI_PDMLINSL = ''
UPDATE U_AZI_PA SET AZI_MAGPDMPREL = ''
UPDATE U_AZI_PA SET AZI_MAGPDMVERS = ''