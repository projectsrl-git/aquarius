/* 
********************************************************************************
VARIAZIONE DIMENSIONI CAMPO U_ART_PR.ART_ULNCAR DA VARCHAR(6) A VARCHAR(20)
********************************************************************************
*/
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_ULNCAR varchar(20) COLLATE Latin1_General_CI_AS NULL
GO
