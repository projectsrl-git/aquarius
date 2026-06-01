
/*
*** Variabile per il campo gestito nella scheda "Contabilità", sottoscheda "Impostazioni"
***		- Abilita la ricerca all'interno della descrizione del conto
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	azi_riccontdes BIT NOT NULL DEFAULT (0)
GO
