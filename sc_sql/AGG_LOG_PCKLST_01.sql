
ALTER TABLE [dbo].[LOG_PCKLST] ADD 
	log_numbob numeric(10,0) NULL
go

ALTER TABLE [dbo].[LOG_PCKLST] WITH NOCHECK ADD 
	CONSTRAINT [DF_LOG_PCKLST_log_numbob] DEFAULT (0) FOR [log_numbob]
go

UPDATE LOG_PCKLST SET log_numbob = 0
