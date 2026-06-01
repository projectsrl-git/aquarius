
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_FOR] ADD 
	 PAR_TIPOPA varchar(3) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_FOR_PAR_TIPOPA] DEFAULT ('') FOR [PAR_TIPOPA]
go

UPDATE PART_FOR SET PAR_TIPOPA 	= ' ' 



/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_FOR] ADD 
	 PAR_DTUSOL varchar(10) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_FOR_PAR_DTUSOL] DEFAULT ('') FOR [PAR_DTUSOL]
go

UPDATE PART_FOR SET PAR_DTUSOL 	= ' '



/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_FOR] ADD 
	 PAR_NUMSOL numeric(6,0) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_FOR_PAR_NUMSOL] DEFAULT ('0') FOR [PAR_NUMSOL]
go

UPDATE PART_FOR SET PAR_NUMSOL = 0


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_FOR] ADD 
	[PAR_NOPART] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_FOR_PAR_NOPART] DEFAULT (0) FOR [PAR_NOPART]
go

UPDATE PART_FOR SET PAR_NOPART = 0


/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[PART_FOR] ADD 
	 PAR_STORIA text COLLATE Latin1_General_CI_AS NULL	
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_FOR_PAR_STORIA] DEFAULT ('') FOR [PAR_STORIA]
go

UPDATE PART_FOR SET PAR_STORIA = ''





/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_FOR] ADD 
	 PAR_DTNEWS varchar(10) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_FOR_PAR_DTNEWS] DEFAULT ('') FOR [PAR_DTNEWS]
go

UPDATE PART_FOR SET PAR_DTNEWS 	= ' ' 




