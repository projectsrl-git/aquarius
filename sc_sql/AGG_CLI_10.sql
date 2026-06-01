/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CLI_AN] ADD 
	cli_01dal VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_02dal VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_03dal VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_04dal VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_05dal VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_06dal VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_07dal VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_09dal VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_10dal VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_11dal VARCHAR(4) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_cli_01dal] DEFAULT ('') FOR [cli_01dal],
	CONSTRAINT [DF_U_CLI_AN_cli_02dal] DEFAULT ('') FOR [cli_02dal],
	CONSTRAINT [DF_U_CLI_AN_cli_03dal] DEFAULT ('') FOR [cli_03dal],
	CONSTRAINT [DF_U_CLI_AN_cli_04dal] DEFAULT ('') FOR [cli_04dal],
	CONSTRAINT [DF_U_CLI_AN_cli_05dal] DEFAULT ('') FOR [cli_05dal],
	CONSTRAINT [DF_U_CLI_AN_cli_06dal] DEFAULT ('') FOR [cli_06dal],
	CONSTRAINT [DF_U_CLI_AN_cli_07dal] DEFAULT ('') FOR [cli_07dal],
	CONSTRAINT [DF_U_CLI_AN_cli_09dal] DEFAULT ('') FOR [cli_09dal],
	CONSTRAINT [DF_U_CLI_AN_cli_10dal] DEFAULT ('') FOR [cli_10dal],
	CONSTRAINT [DF_U_CLI_AN_cli_11dal] DEFAULT ('') FOR [cli_11dal]
go

UPDATE U_CLI_AN SET cli_01dal = '0101'
UPDATE U_CLI_AN SET cli_02dal = '0102'
UPDATE U_CLI_AN SET cli_03dal = '0103'
UPDATE U_CLI_AN SET cli_04dal = '0104'
UPDATE U_CLI_AN SET cli_05dal = '0105'
UPDATE U_CLI_AN SET cli_06dal = '0106'
UPDATE U_CLI_AN SET cli_07dal = '0107'
UPDATE U_CLI_AN SET cli_09dal = '0109'
UPDATE U_CLI_AN SET cli_10dal = '0110'
UPDATE U_CLI_AN SET cli_11dal = '0111'

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	cli_01al VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_02al VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_03al VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_04al VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_05al VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_06al VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_07al VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_09al VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_10al VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_11al VARCHAR(4) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_cli_01al] DEFAULT ('') FOR [cli_01al],
	CONSTRAINT [DF_U_CLI_AN_cli_02al] DEFAULT ('') FOR [cli_02al],
	CONSTRAINT [DF_U_CLI_AN_cli_03al] DEFAULT ('') FOR [cli_03al],
	CONSTRAINT [DF_U_CLI_AN_cli_04al] DEFAULT ('') FOR [cli_04al],
	CONSTRAINT [DF_U_CLI_AN_cli_05al] DEFAULT ('') FOR [cli_05al],
	CONSTRAINT [DF_U_CLI_AN_cli_06al] DEFAULT ('') FOR [cli_06al],
	CONSTRAINT [DF_U_CLI_AN_cli_07al] DEFAULT ('') FOR [cli_07al],
	CONSTRAINT [DF_U_CLI_AN_cli_09al] DEFAULT ('') FOR [cli_09al],
	CONSTRAINT [DF_U_CLI_AN_cli_10al] DEFAULT ('') FOR [cli_10al],
	CONSTRAINT [DF_U_CLI_AN_cli_11al] DEFAULT ('') FOR [cli_11al]
go

UPDATE U_CLI_AN SET cli_01al = '3101'
UPDATE U_CLI_AN SET cli_02al = '2802'
UPDATE U_CLI_AN SET cli_03al = '3103'
UPDATE U_CLI_AN SET cli_04al = '3004'
UPDATE U_CLI_AN SET cli_05al = '3105'
UPDATE U_CLI_AN SET cli_06al = '3006'
UPDATE U_CLI_AN SET cli_07al = '3107'
UPDATE U_CLI_AN SET cli_09al = '3009'
UPDATE U_CLI_AN SET cli_10al = '3110'
UPDATE U_CLI_AN SET cli_11al = '3011'

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	cli_01gg VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_02gg VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_03gg VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_04gg VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_05gg VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_06gg VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_07gg VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_09gg VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_10gg VARCHAR(4) COLLATE Latin1_General_CI_AS NULL,
	cli_11gg VARCHAR(4) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_cli_01gg] DEFAULT ('') FOR [cli_01gg],
	CONSTRAINT [DF_U_CLI_AN_cli_02gg] DEFAULT ('') FOR [cli_02gg],
	CONSTRAINT [DF_U_CLI_AN_cli_03gg] DEFAULT ('') FOR [cli_03gg],
	CONSTRAINT [DF_U_CLI_AN_cli_04gg] DEFAULT ('') FOR [cli_04gg],
	CONSTRAINT [DF_U_CLI_AN_cli_05gg] DEFAULT ('') FOR [cli_05gg],
	CONSTRAINT [DF_U_CLI_AN_cli_06gg] DEFAULT ('') FOR [cli_06gg],
	CONSTRAINT [DF_U_CLI_AN_cli_07gg] DEFAULT ('') FOR [cli_07gg],
	CONSTRAINT [DF_U_CLI_AN_cli_09gg] DEFAULT ('') FOR [cli_09gg],
	CONSTRAINT [DF_U_CLI_AN_cli_10gg] DEFAULT ('') FOR [cli_10gg],
	CONSTRAINT [DF_U_CLI_AN_cli_11gg] DEFAULT ('') FOR [cli_11gg]
go

UPDATE U_CLI_AN SET cli_01gg = '0502'
UPDATE U_CLI_AN SET cli_02gg = '0503'
UPDATE U_CLI_AN SET cli_03gg = '0504'
UPDATE U_CLI_AN SET cli_04gg = '0505'
UPDATE U_CLI_AN SET cli_05gg = '0506'
UPDATE U_CLI_AN SET cli_06gg = '0507'
UPDATE U_CLI_AN SET cli_07gg = '0509'
UPDATE U_CLI_AN SET cli_09gg = '0510'
UPDATE U_CLI_AN SET cli_10gg = '0511'
UPDATE U_CLI_AN SET cli_11gg = '0512'



