/* 
********************************************************************************************************************
VARIAZIONE DIMENSIONI CAMPO U_FAT_TT.ORD_PESNET DA NUMERIC(8,0) A NUMERIC(19,3) PER COERENZA CON U_BOL_TT.ORD_PESNET
********************************************************************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN
	 ORD_PESNET NUMERIC(19,3)
GO
