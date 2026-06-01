/* 
*****************************************************************************************************************************
INSERIMENTO NUOVO CAMPO PER ESPRESSIONE DI OBBLIGATORIETA' E DESCRIZIONE CAMPO IN CONFIGURAZIONE PERSONALIZZATA FORM
*****************************************************************************************************************************
*/

ALTER TABLE [dbo].[FORMCONF] ADD 
	[EXPROBLIGATORY] [varchar] (254) COLLATE Latin1_General_CI_AS NULL,
	[FLDNAMEOBLIGATORY] [varchar] (254) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[FORMCONF] WITH NOCHECK ADD 
	CONSTRAINT [DF_FORMCONF_EXPROBLIGATORY] DEFAULT ('') FOR [EXPROBLIGATORY],
	CONSTRAINT [DF_FORMCONF_FLDNAMEOBLIGATORY] DEFAULT ('') FOR [FLDNAMEOBLIGATORY]
go


UPDATE FORMCONF SET EXPROBLIGATORY = ''
UPDATE FORMCONF SET FLDNAMEOBLIGATORY = ''
