
-- VISTA SPEDITO_PESO_NETTO_LORDO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SPEDITO_PESO_NETTO_LORDO]'))
	DROP VIEW [dbo].[SPEDITO_PESO_NETTO_LORDO]
GO

CREATE VIEW [dbo].[SPEDITO_PESO_NETTO_LORDO]  
AS
	SELECT
		ord_anno AS ANNO,
		ord_codcli AS COD_CLIENTE,
		ord_ragsoc AS RAG_SOCIALE,
		ord_numord AS NUM_DDT,
		ord_datord AS DATA_DDT,
		ord_pesnet AS PESO_NETTO,
		ord_peso AS PESO_LORDO,
		CAST(coalesce(stuff((select  DISTINCT ',' + RTRIM(art_DESLIN)
                    from	u_art_pr where art_codpri in (select ord_codart from u_bol_dd WHERE	ORD_CODART <> '' AND daggancio = TT.taggancio)
                    for xml path('')
                ),1,1,''),'') AS nvarchar(254)) AS COD_LINEE_PRODOTTO,
		CAST(coalesce(stuff((select  DISTINCT ',' + RTRIM(art_DESLIN)
                    from	u_art_pr where art_codpri in (select ord_codart from u_bol_dd WHERE	ORD_CODART <> '' AND daggancio = TT.taggancio)
                    for xml path('')
                ),1,1,''),'') AS nvarchar(254)) AS DESCR_LINEE_PRODOTTO
	from u_bol_tt as tt
GO


SELECT * FROM SPEDITO_PESO_NETTO_LORDO WHERE ANNO = '2019'

