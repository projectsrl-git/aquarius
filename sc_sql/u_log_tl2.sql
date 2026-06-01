ALTER TABLE [dbo].[u_log_tl] ADD 
	[LOG_FLGTRA] [bit] NULL
go
ALTER TABLE [dbo].[u_log_tl] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_log_tl_LOG_FLGTRA] DEFAULT (0) FOR [LOG_FLGTRA]
go