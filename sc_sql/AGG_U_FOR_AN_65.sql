/*********************************************************/
/* INSERIMENTO NUOVO CAMPO 'TOP proposto in fatture CGE' */
/*********************************************************/

ALTER TABLE [dbo].[U_FOR_AN] ADD
	FOR_TOPCGE varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_FOR_AN_FOR_TOPCGE] DEFAULT ('')
GO
