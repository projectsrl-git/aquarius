
ALTER TABLE [dbo].[U_BAN_AN] ADD 
	ban_iban	varchar(29) COLLATE Latin1_General_CI_AS NULL,
	ban_nazion	varchar(3) COLLATE Latin1_General_CI_AS NULL,
	ban_checkd	varchar(2) COLLATE Latin1_General_CI_AS NULL,
	ban_codncc	varchar(12) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BAN_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BAN_AN_ban_iban]	DEFAULT ('') FOR [ban_iban],
	CONSTRAINT [DF_U_BAN_AN_ban_nazion] DEFAULT ('') FOR [ban_nazion],
	CONSTRAINT [DF_U_BAN_AN_ban_checkd] DEFAULT ('') FOR [ban_checkd],
	CONSTRAINT [DF_U_BAN_AN_ban_codncc] DEFAULT ('') FOR [ban_codncc]
go

UPDATE U_BAN_AN SET ban_iban 	= ''
UPDATE U_BAN_AN SET ban_nazion 	= ''
UPDATE U_BAN_AN SET ban_checkd 	= ''
UPDATE U_BAN_AN SET ban_codncc 	= ''

