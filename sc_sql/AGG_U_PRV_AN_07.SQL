/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_PRV_AN] ADD 
	PRV_GN varchar(1) COLLATE Latin1_General_CI_AS NULL,
	PRV_TIPOGN varchar(1) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_PRV_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRV_AN_PRV_GN] DEFAULT ('') FOR [PRV_GN],
	CONSTRAINT [DF_U_PRV_AN_PRV_TIPOGN] DEFAULT ('') FOR [PRV_TIPOGN]
go


UPDATE U_PRV_AN SET PRV_GN = '' 
UPDATE U_PRV_AN SET PRV_TIPOGN = ''
