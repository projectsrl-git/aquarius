
/*         
***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************
*/
ALTER TABLE [dbo].[U_PDV_CD] ADD 
	 PDV_CGE varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 PDV_CGEINC varchar(1) COLLATE Latin1_General_CI_AS NULL
	 
go
ALTER TABLE [dbo].[U_PDV_CD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_CD_PDV_CGE] DEFAULT ('') FOR [PDV_CGE],
	CONSTRAINT [DF_U_PDV_CD_PDV_CGEINC] DEFAULT ('') FOR [PDV_CGEINC]
	

go


UPDATE U_pdv_cd SET pdv_cge = SPACE(1)
UPDATE U_pdv_cd SET pdv_cgeinc = SPACE(1)