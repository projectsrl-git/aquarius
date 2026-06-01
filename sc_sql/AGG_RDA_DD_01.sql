/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[RDA_DD] ADD 
	SC1 numeric (7,3) NULL,
	SC2 numeric (7,3) NULL,
	SC3 numeric (7,3) NULL
go

ALTER TABLE [dbo].[RDA_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_RDA_DD_SC1] DEFAULT (0) FOR [SC1],
	CONSTRAINT [DF_RDA_DD_SC2] DEFAULT (0) FOR [SC2],
	CONSTRAINT [DF_RDA_DD_SC3] DEFAULT (0) FOR [SC3]
go


UPDATE RDA_DD SET SC1 = 0
UPDATE RDA_DD SET SC2 = 0
UPDATE RDA_DD SET SC3 = 0
