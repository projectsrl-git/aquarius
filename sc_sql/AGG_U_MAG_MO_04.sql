/* 
****************************************************************************************
AGGIUNTA CAMPO MOV_MAGUNQ, CORRISPONDENTE AL CAMPO U_MAG_GG.MAG_UNIQUE
****************************************************************************************
*/

ALTER TABLE [dbo].[U_MAG_MO] ADD
	[MOV_MAGUNQ] [varchar] (10) COLLATE Latin1_General_CI_AS NULL
GO

ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_MAG_MO_MOV_MAGUNQ] DEFAULT ('') FOR [MOV_MAGUNQ]
go

UPDATE U_MAG_MO SET MOV_MAGUNQ = ''
