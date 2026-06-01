ALTER TABLE [dbo].[U_ART_PR] ADD 
	ART_notprd varchar(200) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_notprd] DEFAULT ('') FOR [ART_notprd]
go

UPDATE U_ART_PR SET ART_notprd = '' 
