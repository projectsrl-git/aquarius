/* 
****************************************************************************************
AGGIUNTA CAMPO SERIAL NUMBER (PER GESTIONE DISPOSITIVI MEDICALI)
****************************************************************************************
*/

ALTER TABLE [dbo].[U_MAG_GG] ADD
	 [MAG_SERIAL] [varchar] (10) COLLATE Latin1_General_CI_AS NULL
GO

ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_MAG_GG_MAG_SERIAL] DEFAULT ('') FOR [MAG_SERIAL]
go

UPDATE U_MAG_GG SET MAG_SERIAL = ''
