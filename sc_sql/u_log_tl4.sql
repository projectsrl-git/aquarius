ALTER TABLE [dbo].[u_log_tl] ADD 
	 LOG_TELP1 char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TELP2 char(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[u_log_tl] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_log_tl_LOG_TELP1] DEFAULT ('') FOR [LOG_TELP1],
	CONSTRAINT [DF_u_log_tl_LOG_TELP2] DEFAULT ('') FOR [LOG_TELP2]
go
