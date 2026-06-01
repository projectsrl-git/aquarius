/************************************************************/
/* INSERIMENTO NUOVO CAMPO PER GESTIONE QUALIFICA FORNITORE */
/************************************************************/

ALTER TABLE [dbo].[U_FOR_AN] ADD
	FOR_CRITICO BIT NOT NULL CONSTRAINT [DF_U_FOR_AN_FOR_CRITICO] DEFAULT (0)
GO
