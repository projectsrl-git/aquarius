/* 
********************************************************************
AGGIUNTA CAMPO "SEQUEN" IN TABELLE PER DETTAGLI FATTURABILE COMMESSE 
********************************************************************
*/

ALTER TABLE [dbo].[FATTURABILE_A] ADD 
	Sequen numeric (10,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FATTURABILE_A] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_A_Sequen] DEFAULT (0) FOR [Sequen]
go
UPDATE FATTURABILE_A SET Sequen = 0


ALTER TABLE [dbo].[FATTURABILE_P] ADD 
	Sequen numeric (10,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FATTURABILE_P] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_P_Sequen] DEFAULT (0) FOR [Sequen]
go
UPDATE FATTURABILE_P SET Sequen = 0


ALTER TABLE [dbo].[FATTURABILE_R] ADD 
	Sequen numeric (10,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FATTURABILE_R] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_R_Sequen] DEFAULT (0) FOR [Sequen]
go
UPDATE FATTURABILE_R SET Sequen = 0


ALTER TABLE [dbo].[FATTURABILE_S] ADD 
	Sequen numeric (10,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FATTURABILE_S] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_S_Sequen] DEFAULT (0) FOR [Sequen]
go
UPDATE FATTURABILE_S SET Sequen = 0


ALTER TABLE [dbo].[FATTURABILE_X] ADD 
	Sequen numeric (10,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FATTURABILE_X] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_X_Sequen] DEFAULT (0) FOR [Sequen]
go
UPDATE FATTURABILE_X SET Sequen = 0
