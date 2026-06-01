
/* 
**************************************************************
INSERIMENTO NUOVO CAMPO IN TESTATA RDA:
	- RDA_TT.INOLTRATA: Inoltrata alla direzione
**************************************************************
*/

ALTER TABLE [dbo].[RDA_TT] ADD 
	 INOLTRATA bit NOT NULL DEFAULT (0)
go
