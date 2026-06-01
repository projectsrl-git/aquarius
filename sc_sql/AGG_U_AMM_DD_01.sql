/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_DD] ADD 
 	 CAM_CATEG varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 cam_peuti numeric(10,3)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_DD_CAM_CATEG]  DEFAULT ('   ') FOR [CAM_CATEG],
	CONSTRAINT [DF_U_AMM_DD_cam_peuti] DEFAULT (0) FOR [cam_peuti]
go

UPDATE U_AMM_DD SET CAM_CATEG 	= '      '
UPDATE U_AMM_DD SET cam_peuti 	= 0

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_DD] ADD 
 	 ORD_DTUTIL varchar(10) COLLATE Latin1_General_CI_AS NULL,
 	 ORD_TIPOBE varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 ORD_NUCESP numeric(6,0)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_DD_ORD_DTUTIL]  DEFAULT ('   ') FOR [ORD_DTUTIL],
	CONSTRAINT [DF_U_AMM_DD_ORD_TIPOBE]  DEFAULT ('   ') FOR [ORD_TIPOBE],
	CONSTRAINT [DF_U_AMM_DD_ORD_NUCESP] DEFAULT (0) FOR [ORD_NUCESP]
go

UPDATE U_AMM_DD SET ORD_DTUTIL 	= '      '
UPDATE U_AMM_DD SET ORD_NUCESP 	= 0
UPDATE U_AMM_DD SET ORD_TIPOBE 	= '      '



