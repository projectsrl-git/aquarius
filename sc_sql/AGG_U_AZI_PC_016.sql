
/*
*** Variabile per opzione gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Codice Destinatario SDI
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_IDSDI varchar(7) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_IDSDI] DEFAULT ('')
GO
