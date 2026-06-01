
ALTER TABLE [dbo].[RES_OPER] ADD 
	res_dtpartda varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_RES_OPER_res_dtpartda] DEFAULT (''),
	res_dtpartal varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_RES_OPER_res_dtpartal] DEFAULT ('')

go
