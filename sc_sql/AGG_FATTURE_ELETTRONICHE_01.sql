
/* 
***********************************************************************************************
INSERIMENTO CAMPO "FE_RICEVUTA" PER IDENTIFICARE LA RICEVUTA DELL'AGENZIA DELLE ENTRATE
***********************************************************************************************
*/
ALTER TABLE [dbo].[FATTURE_ELETTRONICHE] ADD 
	 [FE_RICEV_DA_SDI]   [text] NULL CONSTRAINT [DF_FATTURE_ELETTRONICHE_FE_RICEV_DA_SDI]  DEFAULT ('')
go

UPDATE FATTURE_ELETTRONICHE SET FE_RICEV_DA_SDI = ''
