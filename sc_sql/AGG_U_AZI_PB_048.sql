


 
ALTER TABLE [DBO].[U_AZI_PB] ADD 
	azi_ricclides  BIT NULL,
	azi_ricfordes  BIT NULL,
	azi_ricbandes  BIT NULL,
	azi_ricartdes  BIT NULL

GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_azi_ricclides] DEFAULT (0) FOR [azi_ricclides],
	CONSTRAINT [DF_U_AZI_PB_azi_ricfordes] DEFAULT (0) FOR [azi_ricfordes],
	CONSTRAINT [DF_U_AZI_PB_azi_ricbandes] DEFAULT (0) FOR [azi_ricbandes],
	CONSTRAINT [DF_U_AZI_PB_azi_ricartdes] DEFAULT (0) FOR [azi_ricartdes]
GO

UPDATE U_AZI_PB SET azi_ricclides  = 0
UPDATE U_AZI_PB SET azi_ricfordes  = 0
UPDATE U_AZI_PB SET azi_ricbandes  = 0
UPDATE U_AZI_PB SET azi_ricartdes  = 0