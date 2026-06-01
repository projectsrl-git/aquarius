/*************************************************************/
/* INSERIMENTO NUOVO CAMPO 'Mag. dep. per Bolle a fornitore' */
/*************************************************************/

ALTER TABLE [dbo].[U_FOR_AN] ADD
	FOR_MAGDEP varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_FOR_AN_FOR_MAGDEP] DEFAULT ('')
GO
