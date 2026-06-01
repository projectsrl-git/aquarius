
ALTER TABLE [dbo].[LOG_BOLLE] ADD 
	log_numbob numeric(10,0) NULL
go

ALTER TABLE [dbo].[LOG_BOLLE] WITH NOCHECK ADD 
	CONSTRAINT [DF_LOG_BOLLE_log_numbob] DEFAULT (0) FOR [log_numbob]
go

UPDATE LOG_BOLLE SET log_numbob = 0
