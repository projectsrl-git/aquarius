/* 
***************************************************
AGGIUNTA CAMPO "ART_ECOMM" PER GESTIONE E-COMMERCE
***************************************************
*/

ALTER TABLE [dbo].[U_ART_AN] ADD 
	ART_ECOMM BIT NOT NULL CONSTRAINT [DF_U_ART_AN_ART_ECOMM] DEFAULT (0)
go
