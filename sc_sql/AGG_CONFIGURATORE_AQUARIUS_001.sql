
/*
*** Variabile per opzione gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Codice Destinatario SDI
*/

ALTER TABLE [DBO].[CONFIGURATORE_AQUARIUS] ADD 
	AZI_CODICL varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CONFIGURATORE_AQUARIUS_AZI_CODICL] DEFAULT ('')
GO
