
/* 
****************************************************************************************
INSERIMENTO CAMPI PER LA GESTIONE DEI TOTALI CONVERGENTI NELLE RIGHE DOCUMENTO ACCORPATE
****************************************************************************************
*/
ALTER TABLE [dbo].[U_OFF_DD] ADD 
	ORD_PRZACC NUMERIC(17,6) NOT NULL CONSTRAINT [DF_U_OFF_DD_ORD_PRZACC] DEFAULT (0),
	ORD_PRNACC NUMERIC(17,6) NOT NULL CONSTRAINT [DF_U_OFF_DD_ORD_PRNACC] DEFAULT (0),
	ORD_VALACC NUMERIC(17,3) NOT NULL CONSTRAINT [DF_U_OFF_DD_ORD_VALACC] DEFAULT (0)
go
