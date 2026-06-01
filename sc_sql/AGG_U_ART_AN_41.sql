/* 
********************************************************************
AGGIUNTA CAMPO "ART_SCORMIECO" PER GESTIONE SCORTA MINIMA E-COMMERCE
********************************************************************
*/

ALTER TABLE [dbo].[U_ART_AN] ADD 
	ART_SCORMIECO NUMERIC(19,4) NOT NULL CONSTRAINT [DF_U_ART_AN_ART_SCORMIECO] DEFAULT (0)
go
