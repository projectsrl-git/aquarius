/* 
****************************************************************************************
AGGIUNTA CAMPO SERIAL NUMBER (PER GESTIONE DISPOSITIVI MEDICALI)
****************************************************************************************
*/

ALTER TABLE [dbo].[U_MAG_MO] ADD
	 [MOV_SERIAL] [varchar] (10) COLLATE Latin1_General_CI_AS NULL
GO

ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_MAG_MO_MOV_SERIAL] DEFAULT ('') FOR [MOV_SERIAL]
go

UPDATE U_MAG_MO SET MOV_SERIAL = ''
