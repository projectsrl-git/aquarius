/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_RIM_TT] ALTER COLUMN 
	RIC_BACLI varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_RIM_TT] ALTER COLUMN 
	RIC_BAPRES varchar(10) COLLATE Latin1_General_CI_AS NULL 
go


/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_RIM_TT] ADD 
	RIC_PRES BIT NULL
go

ALTER TABLE [dbo].[U_RIM_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRV_AN_RIC_PRES] DEFAULT (0) FOR [RIC_PRES]
go


UPDATE U_RIM_TT SET RIC_PRES = 0


/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_RIM_TT] ADD 
	RIC_CPA varchar(3) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_RIM_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRV_AN_RIC_CPA] DEFAULT ('') FOR [RIC_CPA]
go


UPDATE U_RIM_TT SET RIC_CPA = ''