
/*
*** Variabile per l'opzione gestita nella scheda "Top standard" dei parametri di sistema nel "form\menu_azi000.scx":
***	DDT fornitori in conto lavoro
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_CTLD varchar(3) COLLATE Latin1_General_CI_AS NOT NULL  CONSTRAINT [DF_U_AZI_PC_AZI_CTLD] DEFAULT ('')
GO

UPDATE U_AZI_PC SET AZI_CTLD = (SELECT AZI_CTLO FROM U_AZI_AN)