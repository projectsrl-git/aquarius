/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PRO_CA] ADD 
	 CAP_TEMTAG numeric(6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRO_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRO_CA_CAP_TEMTAG] DEFAULT (0) FOR [CAP_TEMTAG]
go

UPDATE U_PRO_CA SET CAP_TEMTAG = 0

