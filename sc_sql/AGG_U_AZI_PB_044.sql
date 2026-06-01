
ALTER TABLE [DBO].[U_AZI_PB] ADD 
	azi_ddt_poliec  BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_azi_ddt_poliec ] DEFAULT (0) FOR [azi_ddt_poliec ]
GO

UPDATE U_AZI_PB SET azi_ddt_poliec  = 0