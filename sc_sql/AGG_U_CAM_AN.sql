 
/* 
*************************************************************************
AGGIUNTA NELLA TABELLA DELLE CATEGORIE PER AMMORTAMENTO DEL CAMPO CONTO *
*************************************************************************
*/
ALTER TABLE [dbo].[U_CAM_AN] ADD 
	 CAM_CONTO varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CAM_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CAM_AN_CAM_CONTO] DEFAULT ('') FOR [CAM_CONTO]
go

UPDATE U_CAM_AN SET CAM_CONTO = SPACE(13)