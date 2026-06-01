/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 cli_ragsoca varchar(80) COLLATE Latin1_General_CI_AS NULL,
	 cli_ragduea varchar(80) COLLATE Latin1_General_CI_AS NULL,
	 cli_indira varchar(80) COLLATE Latin1_General_CI_AS NULL,
	 cli_localia varchar(80) COLLATE Latin1_General_CI_AS NULL,
	 cli_provina varchar(02) COLLATE Latin1_General_CI_AS NULL,
	 cli_naziona varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 cli_capa varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 cli_codfisa varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 cli_parivaa varchar(11) COLLATE Latin1_General_CI_AS NULL,
	 cli_ivaceea varchar(20) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_cli_ragsoca] DEFAULT ('') FOR [cli_ragsoca],
	CONSTRAINT [DF_U_CLI_AN_cli_ragduea] DEFAULT ('') FOR [cli_ragduea],
	CONSTRAINT [DF_U_CLI_AN_cli_indira] DEFAULT ('') FOR [cli_indira],
	CONSTRAINT [DF_U_CLI_AN_cli_localia] DEFAULT ('') FOR [cli_localia],
	CONSTRAINT [DF_U_CLI_AN_cli_provina] DEFAULT ('') FOR [cli_provina],
	CONSTRAINT [DF_U_CLI_AN_cli_naziona] DEFAULT ('') FOR [cli_naziona],
	CONSTRAINT [DF_U_CLI_AN_cli_capa] DEFAULT ('') FOR [cli_capa],
	CONSTRAINT [DF_U_CLI_AN_cli_codfisa] DEFAULT ('') FOR [cli_codfisa],
	CONSTRAINT [DF_U_CLI_AN_cli_parivaa] DEFAULT ('') FOR [cli_parivaa],
	CONSTRAINT [DF_U_CLI_AN_cli_ivaceea] DEFAULT ('') FOR [cli_ivaceea]
go

UPDATE U_CLI_AN SET cli_ragsoca = ''
UPDATE U_CLI_AN SET cli_ragduea = ''
UPDATE U_CLI_AN SET cli_indira = ''
UPDATE U_CLI_AN SET cli_localia = ''
UPDATE U_CLI_AN SET cli_provina = ''
UPDATE U_CLI_AN SET cli_naziona = ''
UPDATE U_CLI_AN SET cli_capa = ''
UPDATE U_CLI_AN SET cli_codfisa = ''
UPDATE U_CLI_AN SET cli_parivaa = ''
UPDATE U_CLI_AN SET cli_ivaceea = ''
