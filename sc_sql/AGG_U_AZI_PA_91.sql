
ALTER TABLE [DBO].[U_AZI_PA] ADD 
	azi_nosaldi  BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_nosaldi] DEFAULT (0) FOR [azi_nosaldi]
GO

UPDATE U_AZI_PA SET azi_nosaldi = 0
