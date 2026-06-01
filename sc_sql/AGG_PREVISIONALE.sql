/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[MOV_CONT] ADD 
	 	 MOV_CONTABILITA_PREVISIONALE varchar(1) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CONT_MOV_CONTABILITA_PREVISIONALE] DEFAULT ('0') FOR [MOV_CONTABILITA_PREVISIONALE]
go

UPDATE MOV_CONT SET MOV_CONTABILITA_PREVISIONALE = ' '


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[INDICE] ADD 
	 	 MOV_CONTABILITA_PREVISIONALE varchar(1) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[INDICE] WITH NOCHECK ADD 
	CONSTRAINT [DF_INDICE_MOV_CONTABILITA_PREVISIONALE] DEFAULT ('0') FOR [MOV_CONTABILITA_PREVISIONALE]
go

UPDATE INDICE SET MOV_CONTABILITA_PREVISIONALE = ' '

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_FOR] ADD 
	 	 PAR_CONTABILITA_PREVISIONALE varchar(1) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_FOR_PAR_CONTABILITA_PREVISIONALE] DEFAULT ('0') FOR [PAR_CONTABILITA_PREVISIONALE]
go

UPDATE PART_FOR SET PAR_CONTABILITA_PREVISIONALE = ' '


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_CLI] ADD 
	 	 PAR_CONTABILITA_PREVISIONALE varchar(1) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_CLI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_CLI_PAR_CONTABILITA_PREVISIONALE] DEFAULT ('0') FOR [PAR_CONTABILITA_PREVISIONALE]
go

UPDATE PART_CLI SET PAR_CONTABILITA_PREVISIONALE = ' '


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[MOV_CCO] ADD 
	 	 MOV_CONTABILITA_PREVISIONALE varchar(1) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CCO] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CCO_MOV_CONTABILITA_PREVISIONALE] DEFAULT ('0') FOR [MOV_CONTABILITA_PREVISIONALE]
go

UPDATE MOV_CCO SET MOV_CONTABILITA_PREVISIONALE = ' '



/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CONTI] ADD 
	[PRE_IMP_D] [numeric] (17,3) NULL ,
	[PRE_IMP_A] [numeric] (17,3) NULL ,
	[PRE_DA01]  [numeric] (17,3) NULL ,
	[PRE_AV01]  [numeric] (17,3) NULL ,
	[PRE_DA02]  [numeric] (17,3) NULL ,
	[PRE_AV02]  [numeric] (17,3) NULL ,
	[PRE_DA03]  [numeric] (17,3) NULL ,
	[PRE_AV03]  [numeric] (17,3) NULL ,
	[PRE_DA04]  [numeric] (17,3) NULL ,
	[PRE_AV04]  [numeric] (17,3) NULL ,
	[PRE_DA05]  [numeric] (17,3) NULL ,
	[PRE_AV05]  [numeric] (17,3) NULL ,
	[PRE_DA06]  [numeric] (17,3) NULL ,
	[PRE_AV06]  [numeric] (17,3) NULL ,
	[PRE_DA07]  [numeric] (17,3) NULL ,
	[PRE_AV07]  [numeric] (17,3) NULL ,
	[PRE_DA08]  [numeric] (17,3) NULL ,
	[PRE_AV08]  [numeric] (17,3) NULL ,
	[PRE_DA09]  [numeric] (17,3) NULL ,
	[PRE_AV09]  [numeric] (17,3) NULL ,
	[PRE_DA10]  [numeric] (17,3) NULL ,
	[PRE_AV10]  [numeric] (17,3) NULL ,
	[PRE_DA11]  [numeric] (17,3) NULL ,
	[PRE_AV11]  [numeric] (17,3) NULL ,
	[PRE_DA12]  [numeric] (17,3) NULL ,
	[PRE_AV12]  [numeric] (17,3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[conti] WITH NOCHECK ADD 
	CONSTRAINT [DF_conti_PRE_IMP_D] DEFAULT (0) FOR [PRE_IMP_D],
	CONSTRAINT [DF_conti_PRE_IMP_A] DEFAULT (0) FOR [PRE_IMP_A],
	CONSTRAINT [DF_conti_PRE_DA01] DEFAULT (0) FOR [PRE_DA01],
	CONSTRAINT [DF_conti_PRE_AV01] DEFAULT (0) FOR [PRE_AV01],
	CONSTRAINT [DF_conti_PRE_DA02] DEFAULT (0) FOR [PRE_DA02],
	CONSTRAINT [DF_conti_PRE_AV02] DEFAULT (0) FOR [PRE_AV02],
	CONSTRAINT [DF_conti_PRE_DA03] DEFAULT (0) FOR [PRE_DA03],
	CONSTRAINT [DF_conti_PRE_AV03] DEFAULT (0) FOR [PRE_AV03],
	CONSTRAINT [DF_conti_PRE_DA04] DEFAULT (0) FOR [PRE_DA04],
	CONSTRAINT [DF_conti_PRE_AV04] DEFAULT (0) FOR [PRE_AV04],
	CONSTRAINT [DF_conti_PRE_DA05] DEFAULT (0) FOR [PRE_DA05],
	CONSTRAINT [DF_conti_PRE_AV05] DEFAULT (0) FOR [PRE_AV05],
	CONSTRAINT [DF_conti_PRE_DA06] DEFAULT (0) FOR [PRE_DA06],
	CONSTRAINT [DF_conti_PRE_AV06] DEFAULT (0) FOR [PRE_AV06],
	CONSTRAINT [DF_conti_PRE_DA07] DEFAULT (0) FOR [PRE_DA07],
	CONSTRAINT [DF_conti_PRE_AV07] DEFAULT (0) FOR [PRE_AV07],
	CONSTRAINT [DF_conti_PRE_DA08] DEFAULT (0) FOR [PRE_DA08],
	CONSTRAINT [DF_conti_PRE_AV08] DEFAULT (0) FOR [PRE_AV08],
	CONSTRAINT [DF_conti_PRE_DA09] DEFAULT (0) FOR [PRE_DA09],
	CONSTRAINT [DF_conti_PRE_AV09] DEFAULT (0) FOR [PRE_AV09],
	CONSTRAINT [DF_conti_PRE_DA10] DEFAULT (0) FOR [PRE_DA10],
	CONSTRAINT [DF_conti_PRE_AV10] DEFAULT (0) FOR [PRE_AV10],
	CONSTRAINT [DF_conti_PRE_DA11] DEFAULT (0) FOR [PRE_DA11],
	CONSTRAINT [DF_conti_PRE_AV11] DEFAULT (0) FOR [PRE_AV11],
	CONSTRAINT [DF_conti_PRE_DA12] DEFAULT (0) FOR [PRE_DA12],
	CONSTRAINT [DF_conti_PRE_AV12] DEFAULT (0) FOR [PRE_AV12]
go



UPDATE CONTI SET PRE_IMP_D  =  0
UPDATE CONTI SET PRE_IMP_A  =  0
UPDATE CONTI SET PRE_DA01   =  0
UPDATE CONTI SET PRE_AV01   =  0
UPDATE CONTI SET PRE_DA02   =  0
UPDATE CONTI SET PRE_AV02   =  0
UPDATE CONTI SET PRE_DA03   =  0
UPDATE CONTI SET PRE_AV03   =  0 
UPDATE CONTI SET PRE_DA04   =  0
UPDATE CONTI SET PRE_AV04   =  0 
UPDATE CONTI SET PRE_DA05   =  0 
UPDATE CONTI SET PRE_AV05   =  0 
UPDATE CONTI SET PRE_DA06   =  0 
UPDATE CONTI SET PRE_AV06   =  0  
UPDATE CONTI SET PRE_DA07   =  0 
UPDATE CONTI SET PRE_AV07   =  0  
UPDATE CONTI SET PRE_DA08   =  0 
UPDATE CONTI SET PRE_AV08   =  0 
UPDATE CONTI SET PRE_DA09   =  0 
UPDATE CONTI SET PRE_AV09   =  0 
UPDATE CONTI SET PRE_DA10   =  0 
UPDATE CONTI SET PRE_AV10   =  0  
UPDATE CONTI SET PRE_DA11   =  0 
UPDATE CONTI SET PRE_AV11   =  0 
UPDATE CONTI SET PRE_DA12   =  0 
UPDATE CONTI SET PRE_AV12   =  0 

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CCOSTO] ADD 
	[PRE_IMP_D] [numeric] (17,3) NULL ,
	[PRE_DA01]  [numeric] (17,3) NULL ,
	[PRE_DA02]  [numeric] (17,3) NULL ,
	[PRE_DA03]  [numeric] (17,3) NULL ,
	[PRE_DA04]  [numeric] (17,3) NULL ,
	[PRE_DA05]  [numeric] (17,3) NULL ,
	[PRE_DA06]  [numeric] (17,3) NULL ,
	[PRE_DA07]  [numeric] (17,3) NULL ,
	[PRE_DA08]  [numeric] (17,3) NULL ,
	[PRE_DA09]  [numeric] (17,3) NULL ,
	[PRE_DA10]  [numeric] (17,3) NULL ,
	[PRE_DA11]  [numeric] (17,3) NULL ,
	[PRE_DA12]  [numeric] (17,3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[CCOSTO] WITH NOCHECK ADD 
	CONSTRAINT [DF_CCOSTO_PRE_IMP_D] DEFAULT (0) FOR [PRE_IMP_D],
	CONSTRAINT [DF_CCOSTO_PRE_DA01] DEFAULT (0) FOR [PRE_DA01],
	CONSTRAINT [DF_CCOSTO_PRE_DA02] DEFAULT (0) FOR [PRE_DA02],
	CONSTRAINT [DF_CCOSTO_PRE_DA03] DEFAULT (0) FOR [PRE_DA03],
	CONSTRAINT [DF_CCOSTO_PRE_DA04] DEFAULT (0) FOR [PRE_DA04],
	CONSTRAINT [DF_CCOSTO_PRE_DA05] DEFAULT (0) FOR [PRE_DA05],
	CONSTRAINT [DF_CCOSTO_PRE_DA06] DEFAULT (0) FOR [PRE_DA06],
	CONSTRAINT [DF_CCOSTO_PRE_DA07] DEFAULT (0) FOR [PRE_DA07],
	CONSTRAINT [DF_CCOSTO_PRE_DA08] DEFAULT (0) FOR [PRE_DA08],
	CONSTRAINT [DF_CCOSTO_PRE_DA09] DEFAULT (0) FOR [PRE_DA09],
	CONSTRAINT [DF_CCOSTO_PRE_DA10] DEFAULT (0) FOR [PRE_DA10],
	CONSTRAINT [DF_CCOSTO_PRE_DA11] DEFAULT (0) FOR [PRE_DA11],
	CONSTRAINT [DF_CCOSTO_PRE_DA12] DEFAULT (0) FOR [PRE_DA12]
go



UPDATE CCOSTO SET PRE_IMP_D  =  0
UPDATE CCOSTO SET PRE_DA01   =  0
UPDATE CCOSTO SET PRE_DA02   =  0
UPDATE CCOSTO SET PRE_DA03   =  0
UPDATE CCOSTO SET PRE_DA04   =  0
UPDATE CCOSTO SET PRE_DA05   =  0 
UPDATE CCOSTO SET PRE_DA06   =  0 
UPDATE CCOSTO SET PRE_DA07   =  0 
UPDATE CCOSTO SET PRE_DA08   =  0 
UPDATE CCOSTO SET PRE_DA09   =  0 
UPDATE CCOSTO SET PRE_DA10   =  0 
UPDATE CCOSTO SET PRE_DA11   =  0 
UPDATE CCOSTO SET PRE_DA12   =  0 
