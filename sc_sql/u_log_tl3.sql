ALTER TABLE [dbo].[u_log_tl] ADD 
	 LOG_TEL1  char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL2  char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL3  char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL4  char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL5  char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL6  char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL7  char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL8  char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL9  char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL10 char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL11 char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL12 char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL13 char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL14 char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL15 char(1) COLLATE Latin1_General_CI_AS NULL,
	 LOG_TEL16 char(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[u_log_tl] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_log_tl_LOG_TEL1] DEFAULT ('') FOR [LOG_TEL1],
	CONSTRAINT [DF_u_log_tl_LOG_TEL2] DEFAULT ('') FOR [LOG_TEL2],
	CONSTRAINT [DF_u_log_tl_LOG_TEL3] DEFAULT ('') FOR [LOG_TEL3],
	CONSTRAINT [DF_u_log_tl_LOG_TEL4] DEFAULT ('') FOR [LOG_TEL4],
	CONSTRAINT [DF_u_log_tl_LOG_TEL5] DEFAULT ('') FOR [LOG_TEL5],
	CONSTRAINT [DF_u_log_tl_LOG_TEL6] DEFAULT ('') FOR [LOG_TEL6],
	CONSTRAINT [DF_u_log_tl_LOG_TEL7] DEFAULT ('') FOR [LOG_TEL7],
	CONSTRAINT [DF_u_log_tl_LOG_TEL8] DEFAULT ('') FOR [LOG_TEL8],
	CONSTRAINT [DF_u_log_tl_LOG_TEL9] DEFAULT ('') FOR [LOG_TEL9],
	CONSTRAINT [DF_u_log_tl_LOG_TEL10] DEFAULT ('') FOR [LOG_TEL10],
	CONSTRAINT [DF_u_log_tl_LOG_TEL11] DEFAULT ('') FOR [LOG_TEL11],
	CONSTRAINT [DF_u_log_tl_LOG_TEL12] DEFAULT ('') FOR [LOG_TEL12],
	CONSTRAINT [DF_u_log_tl_LOG_TEL13] DEFAULT ('') FOR [LOG_TEL13],
	CONSTRAINT [DF_u_log_tl_LOG_TEL14] DEFAULT ('') FOR [LOG_TEL14],
	CONSTRAINT [DF_u_log_tl_LOG_TEL15] DEFAULT ('') FOR [LOG_TEL15],
	CONSTRAINT [DF_u_log_tl_LOG_TEL16] DEFAULT ('') FOR [LOG_TEL16]
go
