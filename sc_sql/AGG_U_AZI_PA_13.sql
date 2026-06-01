/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
	[AZI_NUCOCG] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_NUCOCG] DEFAULT (0) FOR [AZI_NUCOCG]
go

UPDATE U_AZI_PA SET AZI_NUCOCG  = 0

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
	[AZI_NUCOAQ] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_NUCOAQ] DEFAULT (0) FOR [AZI_NUCOAQ]
go

UPDATE U_AZI_PA SET AZI_NUCOAQ  = 0

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
	[AZI_NUCOAS] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_NUCOAS] DEFAULT (0) FOR [AZI_NUCOAS]
go

UPDATE U_AZI_PA SET AZI_NUCOAS  = 0

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
	[AZI_NUCOOK] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_NUCOOK] DEFAULT (0) FOR [AZI_NUCOOK]
go

UPDATE U_AZI_PA SET AZI_NUCOOK  = 0
