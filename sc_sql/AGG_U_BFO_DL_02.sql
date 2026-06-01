
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DL] ADD 
	 	 ORS_ERRNOT text COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BFO_DL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DL_ORS_ERRNOT] DEFAULT ('') FOR [ORS_ERRNOT]
go


UPDATE U_BFO_DL SET ORS_ERRNOT = '' 
