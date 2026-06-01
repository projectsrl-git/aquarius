
/*
*** Variabile per opzione gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Tutti i commenti
***		- Solo i commenti con Codice commento
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_OPZFECOMM numeric(1,0) NOT NULL  CONSTRAINT [DF_U_AZI_PC_AZI_OPZFECOMM] DEFAULT (1)
GO
