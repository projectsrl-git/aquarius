/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_DD] ADD 
 	 cam_tipoc varchar(02) COLLATE Latin1_General_CI_AS NULL,
	 cam_spema numeric(10,3)  NULL,
 	 cam_tipop varchar(01) COLLATE Latin1_General_CI_AS NULL,
 	 cam_peord numeric(10,3)  NULL,
	 cam_peant numeric(10,3)  NULL,
	 cam_peacc numeric(10,3)  NULL,
	 cam_aapre numeric(10,3)  NULL,
	 cam_contr varchar(33) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_DD_cam_tipoc]  DEFAULT ('   ') FOR [cam_tipoc],
	CONSTRAINT [DF_U_AMM_DD_cam_spema] DEFAULT (0) FOR [cam_spema],
	CONSTRAINT [DF_U_AMM_DD_cam_tipop]  DEFAULT ('   ') FOR [cam_tipop],
	CONSTRAINT [DF_U_AMM_DD_cam_peord] DEFAULT (0) FOR [cam_peord],
	CONSTRAINT [DF_U_AMM_DD_cam_peant] DEFAULT (0) FOR [cam_peant],
	CONSTRAINT [DF_U_AMM_DD_cam_peacc] DEFAULT (0) FOR [cam_peacc],
	CONSTRAINT [DF_U_AMM_DD_cam_aapre] DEFAULT (0) FOR [cam_aapre],
	CONSTRAINT [DF_U_AMM_DD_cam_contr]  DEFAULT ('   ') FOR [cam_contr]
go

UPDATE U_AMM_DD SET cam_tipoc 	= '  '
UPDATE U_AMM_DD SET cam_spema 	= 0
UPDATE U_AMM_DD SET cam_tipop 	= ' '
UPDATE U_AMM_DD SET cam_peord 	= 0
UPDATE U_AMM_DD SET cam_peant 	= 0
UPDATE U_AMM_DD SET cam_peacc 	= 0
UPDATE U_AMM_DD SET cam_aapre 	= 0
UPDATE U_AMM_DD SET cam_contr 	= '      '



/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_DD] ADD 
 	 ord_destbe varchar(25) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_DD_ord_destbe]  DEFAULT ('   ') FOR [ord_destbe]
go

UPDATE U_AMM_DD SET ord_destbe 	= '  '


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_DD] ADD 
 	 ord_sysriga varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_DD_ord_sysriga]  DEFAULT ('   ') FOR [ord_sysriga]
go

UPDATE U_AMM_DD SET ord_sysriga 	= '  '



/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_DD] ADD 
	 cam_aamin numeric(10,3)  NULL,
	 cam_aamax numeric(10,3)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_DD_cam_aamin] DEFAULT (0) FOR [cam_aamin],
	CONSTRAINT [DF_U_AMM_DD_cam_aamax] DEFAULT (0) FOR [cam_aamax]
go

UPDATE U_AMM_DD SET cam_aamin 	= 0
UPDATE U_AMM_DD SET cam_aamax 	= 0


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_DD] ADD 
 	 ord_nregis varchar(10) COLLATE Latin1_General_CI_AS NULL,
 	 ord_dtreg varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_DD_ord_nregis]  DEFAULT ('   ') FOR [ord_nregis],
	CONSTRAINT [DF_U_AMM_DD_ord_dtreg]  DEFAULT ('   ') FOR [ord_dtreg]
go

UPDATE U_AMM_DD SET ord_nregis 	= '  '
UPDATE U_AMM_DD SET ord_dtreg 	= '  '



/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_DD] ADD 
 	 ord_codpri varchar(16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_DD_ord_codpri]  DEFAULT ('   ') FOR [ord_codpri]
go



UPDATE U_AMM_DD SET ord_codpri 	= '  '