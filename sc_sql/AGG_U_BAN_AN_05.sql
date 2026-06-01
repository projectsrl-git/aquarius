
ALTER TABLE [dbo].[U_BAN_AN] ADD 
	ban_swift	varchar(11) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BAN_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BAN_AN_ban_swift]	DEFAULT ('') FOR [ban_swift]
go

UPDATE U_BAN_AN SET ban_swift 	= ''
