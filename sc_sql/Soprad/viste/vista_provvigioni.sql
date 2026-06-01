
-- VISTA PROVVIGIONI

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PROVVIGIONI]'))
	DROP VIEW [dbo].[PROVVIGIONI]
GO

CREATE VIEW [dbo].[PROVVIGIONI]  
AS

select 
	ORD_ANNO AS Anno,
	cli.CLI_AGE AS Codice_Agente,
	par.descri AS Descrizione_Agente,
	ORD_CODCLI AS Codice_Cliente,
	ORD_RAGSOC AS Ragione_Sociale,
	ORD_DATORD AS Data_fattura,
	ORD_NUMORD AS Numero_Fattura,
	(CASE SUBSTRING(CAU.LIBERA,11,1) WHEN 'S' THEN -1 ELSE 1 END) * FAT.ORD_IMPONIB AS Imponibile,
	cli.CLI_PROVVI AS __Provv_,
	(CASE SUBSTRING(CAU.LIBERA,11,1) WHEN 'S' THEN -1 ELSE 1 END) * FAT.ORD_IMPONIB * cli.CLI_PROVVI/100 AS Importo_Provv_,
	ORD_VALUTA AS Valuta,
	ORD_CAMBIO AS Cambio_Euro_Valuta
from U_FAT_TT as fat
left outer join U_CLI_AN as cli
on ORD_CODCLI=CLI_CODCLI
left outer join para as par
on par.codice='AGE'+cli.CLI_AGE
left outer join para as CAU
on CAU.codice='TOP'+FAT.ORD_CAUS

GO