
/* 
**************************************************************************************************************
ALLARGAMENTO CAMPI RELATIVI ALLA PARITA IVA (P.IVA ITALIANA / P.IVA CEE / CODICE FISCALE) SU TUTTI I DOCUMENTI
**************************************************************************************************************
*/
--------------------- FATTURE-------------------------- 
ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN 
	ORD_PARIVA varchar(20) COLLATE Latin1_General_CI_AS NULL
go


------------------ FATTURE PROFORMA ------------------- 
ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN 
	ORD_PARIVA varchar(20) COLLATE Latin1_General_CI_AS NULL
go

------------------ ORDINI CLIENTI ------------------- 
ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN 
	ORD_PARIVA varchar(20) COLLATE Latin1_General_CI_AS NULL
go

------------------ PREVENTIVI CLIENTI ------------------- 
ALTER TABLE [dbo].[U_OFF_TT] ALTER COLUMN 
	ORD_PARIVA varchar(20) COLLATE Latin1_General_CI_AS NULL
go

-------------------- DDT CLIENTI --------------------- 
ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN 
	ORD_PARIVA varchar(20) COLLATE Latin1_General_CI_AS NULL
go

-------------------- DDT CLIENTI EVENTI----------------- 
ALTER TABLE [dbo].[L_BOL_TT] ALTER COLUMN 
	ORD_PARIVA varchar(20) COLLATE Latin1_General_CI_AS NULL
go

-------------------- ORDINI FORNITORI ----------------- 
ALTER TABLE [dbo].[U_ORF_TT] ALTER COLUMN 
	ORD_PARIVA varchar(20) COLLATE Latin1_General_CI_AS NULL
go

-------------------- DDT CARICO DA FORNITORE ----------------- 
ALTER TABLE [dbo].[U_BFO_TT] ALTER COLUMN 
	ORD_PARIVA varchar(20) COLLATE Latin1_General_CI_AS NULL
go
