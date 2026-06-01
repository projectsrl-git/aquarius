/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 cli_ragleg varchar(40) COLLATE Latin1_General_CI_AS NULL,
	 cli_rgleg2 varchar(40) COLLATE Latin1_General_CI_AS NULL,
	 cli_indleg varchar(40) COLLATE Latin1_General_CI_AS NULL,
	 cli_locleg varchar(40) COLLATE Latin1_General_CI_AS NULL,
	 cli_proleg varchar(02) COLLATE Latin1_General_CI_AS NULL,
	 cli_nazleg varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 cli_capleg varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 cli_cfislg varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 cli_pivalg varchar(11) COLLATE Latin1_General_CI_AS NULL,
	 cli_ivcelg varchar(20) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_cli_ragleg] DEFAULT ('') FOR [cli_ragleg],
	CONSTRAINT [DF_U_CLI_AN_cli_rgleg2] DEFAULT ('') FOR [cli_rgleg2],
	CONSTRAINT [DF_U_CLI_AN_cli_indleg] DEFAULT ('') FOR [cli_indleg],
	CONSTRAINT [DF_U_CLI_AN_cli_locleg] DEFAULT ('') FOR [cli_locleg],
	CONSTRAINT [DF_U_CLI_AN_cli_proleg] DEFAULT ('') FOR [cli_proleg],
	CONSTRAINT [DF_U_CLI_AN_cli_nazleg] DEFAULT ('') FOR [cli_nazleg],
	CONSTRAINT [DF_U_CLI_AN_cli_capleg] DEFAULT ('') FOR [cli_capleg],
	CONSTRAINT [DF_U_CLI_AN_cli_cfislg] DEFAULT ('') FOR [cli_cfislg],
	CONSTRAINT [DF_U_CLI_AN_cli_pivalg] DEFAULT ('') FOR [cli_pivalg],
	CONSTRAINT [DF_U_CLI_AN_cli_ivcelg] DEFAULT ('') FOR [cli_ivcelg]
go

UPDATE U_CLI_AN SET cli_ragleg = ''
UPDATE U_CLI_AN SET cli_rgleg2 = ''
UPDATE U_CLI_AN SET cli_indleg = ''
UPDATE U_CLI_AN SET cli_locleg = ''
UPDATE U_CLI_AN SET cli_proleg = ''
UPDATE U_CLI_AN SET cli_nazleg = ''
UPDATE U_CLI_AN SET cli_capleg = ''
UPDATE U_CLI_AN SET cli_cfislg = ''
UPDATE U_CLI_AN SET cli_pivalg = ''
UPDATE U_CLI_AN SET cli_ivcelg = ''
