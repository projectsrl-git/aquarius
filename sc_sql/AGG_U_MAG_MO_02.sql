/* 
****************************************************************************************
ALTERAZIONE DELLA SOLA DIMENSIONE DEL CAMPO
****************************************************************************************
*/

ALTER TABLE [dbo].[U_MAG_MO] ALTER COLUMN
	 MOV_QTAMOV Numeric (19,4) NULL
GO


/* 
****************************************************************************************
AGGIUNTA CAMPO QUANTITA' IN METRI CUBI
****************************************************************************************
*/

ALTER TABLE [dbo].[U_MAG_MO] ADD
	 [MOV_QTAMC] NUMERIC(19,4) NULL
GO

ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_MAG_MO_MOV_QTAMC] DEFAULT (0) FOR [MOV_QTAMC]
go

UPDATE U_MAG_MO SET MOV_QTAMC = 0 
