
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[ccosto] ALTER COLUMN 
	 mov_IMPVAL numeric(18,4) 
go

ALTER TABLE [dbo].[indice] ALTER COLUMN 
	 mov_IMPVAL numeric(18,4) 
go

ALTER TABLE [dbo].[mov_cco] ALTER COLUMN 
	 mov_IMPVAL numeric(18,4) 
go

ALTER TABLE [dbo].[mov_cont] ALTER COLUMN 
	 mov_IMPVAL numeric(18,4) 
go

ALTER TABLE [dbo].[mo_conca] ALTER COLUMN 
	 mov_IMPVAL numeric(18,4) 
go

ALTER TABLE [dbo].[PART_CLI] ALTER COLUMN 
	 PAR_IMPVAL numeric(18,4) 
go

ALTER TABLE [dbo].[PART_for] ALTER COLUMN 
	 PAR_IMPVAL numeric(18,4) 
go

ALTER TABLE [dbo].[u_cea_dd] ALTER COLUMN 
	 ord_IMPVAL numeric(18,4) 
go

