
/*
*** Variabile gestita nella scheda "terza cartella LIPE XML" del "form\menu_azi000.scx":
***		- Serve per attivare o meno la procedura per creare il file XML per la creazione della liquidazione trimestrale LIPE
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_XML_LIPE bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_XML_LIPE] DEFAULT (0)
GO

