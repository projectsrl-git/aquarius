/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CCO_TT] ADD 
	 	 ABI varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 	 CAB varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 	 CC varchar(12) COLLATE Latin1_General_CI_AS NULL,
	 	 CIN varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 	 CHKDGT varchar(2) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CCO_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CCO_TT_ABI] DEFAULT ('') FOR [ABI],
	CONSTRAINT [DF_U_CCO_TT_CAB] DEFAULT ('') FOR [CAB],
	CONSTRAINT [DF_U_CCO_TT_CC] DEFAULT ('') FOR [CC],
	CONSTRAINT [DF_U_CCO_TT_CIN] DEFAULT ('') FOR [CIN],
	CONSTRAINT [DF_U_CCO_TT_CHKDGT] DEFAULT ('') FOR [CHKDGT]
go

UPDATE U_CCO_TT SET ABI 	= ''
UPDATE U_CCO_TT SET CAB 	= ''
UPDATE U_CCO_TT SET CC 	= ''
UPDATE U_CCO_TT SET CIN 	= ''
UPDATE U_CCO_TT SET CHKDGT 	= ''


