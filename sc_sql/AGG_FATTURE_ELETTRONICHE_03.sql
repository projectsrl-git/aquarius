/* 
***********************************************************************************************************************
INSERIMENTO CAMPO "FE_TIPDOCXML" PER IDENTIFICARE LA TIPOLOGIA FATTURA SECONDO IL TAG <TipoDocumento> del tracciato XML
***********************************************************************************************************************
*/
ALTER TABLE [dbo].[FATTURE_ELETTRONICHE] ADD 
	 [FE_TIPDOCXML] varchar(4) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_FATTURE_ELETTRONICHE_FE_TIPDOCXML]  DEFAULT ('')
go

UPDATE FATTURE_ELETTRONICHE SET FE_TIPDOCXML = ''
