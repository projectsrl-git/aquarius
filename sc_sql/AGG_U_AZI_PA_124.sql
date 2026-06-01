/*
*** Variabile per l' opzione gestita nella scheda "Valute Euro"
*  acquisisce l'ultimo cambio disponibile se il cambio del giorno cercato non è presente
*/

ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 AZI_ULTCAM BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_ULTCAM] DEFAULT (0) FOR [AZI_ULTCAM]
go

UPDATE U_AZI_PA SET AZI_ULTCAM = 0
