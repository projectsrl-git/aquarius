
/* 
********************************************************************************************
INSERIMENTO CAMPO PER LA GESTIONE DEL COSTO UNITARIO AZIENDALE PROPEDEUTICO AL CALCOLO UTILE
********************************************************************************************
*/
ALTER TABLE [dbo].[U_OFF_DD] ADD 
	ORD_PRZCON NUMERIC(17,6) NOT NULL CONSTRAINT [DF_U_OFF_DD_ORD_PRZCON] DEFAULT (0)
go
