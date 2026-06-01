ALTER TABLE [dbo].[u_log_tl] ADD 
	 LOG_TIPAUTH varchar(30) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[u_log_tl] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_log_tl_LOG_TIPAUTH] DEFAULT ('') FOR [LOG_TIPAUTH]
go
