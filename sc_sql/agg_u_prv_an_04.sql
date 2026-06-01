/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_PRV_AN] ADD 
	PRV_DTSTDE varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_PRV_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRV_AN_PRV_DTSTDE] DEFAULT ('') FOR [PRV_DTSTDE]
go


UPDATE U_PRV_AN SET PRV_DTSTDE = '' 

