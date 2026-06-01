
/* 
**************************************************************************************************************
INSERIMENTO CAMPI RELATIVI ALLA NAZIONE DELLA LOCALITA' DI CONSEGNA SU TUTTI I DOCUMENTI
**************************************************************************************************************
*/
--------------------- FATTURE-------------------------- 
ALTER TABLE [dbo].[U_FAT_TT] ADD
	ORD_DSNAZC varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_FAT_TT_ORD_DSNAZC] DEFAULT ('')
go

------------------ FATTURE PROFORMA ------------------- 
ALTER TABLE [dbo].[U_FAP_TT] ADD
	ORD_DSNAZC varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_FAP_TT_ORD_DSNAZC] DEFAULT ('')
go

------------------ ORDINI CLIENTI ------------------- 
ALTER TABLE [dbo].[U_ORD_TT] ADD
	ORD_DSNAZC varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_TT_ORD_DSNAZC] DEFAULT ('')
go

------------------ PREVENTIVI CLIENTI ------------------- 
ALTER TABLE [dbo].[U_OFF_TT] ADD
	ORD_DSNAZC varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_OFF_TT_ORD_DSNAZC] DEFAULT ('')
go

-------------------- DDT CLIENTI --------------------- 
ALTER TABLE [dbo].[U_BOL_TT] ADD
	ORD_DSNAZC varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_BOL_TT_ORD_DSNAZC] DEFAULT ('')
go

-------------------- DDT CLIENTI EVENTI----------------- 
ALTER TABLE [dbo].[L_BOL_TT] ADD
	ORD_DSNAZC varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_L_BOL_TT_ORD_DSNAZC] DEFAULT ('')
go

-------------------- ORDINI FORNITORI ----------------- 
ALTER TABLE [dbo].[U_ORF_TT] ADD
	ORD_DSNAZC varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORF_TT_ORD_DSNAZC] DEFAULT ('')
go

-------------------- DDT CARICO DA FORNITORE ----------------- 
ALTER TABLE [dbo].[U_BFO_TT] ADD
	ORD_DSNAZC varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_BFO_TT_ORD_DSNAZC] DEFAULT ('')
go
