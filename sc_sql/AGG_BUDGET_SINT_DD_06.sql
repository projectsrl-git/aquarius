
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_SINT_DD] ADD 
	[TIPO_ORE] [numeric] (1,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[BUDGET_SINT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_SINT_DD_TIPO_ORE] DEFAULT (0) FOR [TIPO_ORE]
go

/*################################################################*/
/*################################################################*/
/*																  */
/*					ATTENZIONE ALLA UPDATE						  */
/*																  */
/*################################################################*/
/*################################################################*/
-- Viene settato a 1 per le commesse già presenti in comunità nuova
-- il valore 1 equivale alla gestione attuale per calcolare le ore
UPDATE BUDGET_SINT_DD SET TIPO_ORE = 1
