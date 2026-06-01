
-- VISTA FATTURATO_FORNITORI_PER_ANNO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[FATTURATO_FORNITORI_PER_ANNO]'))
	DROP VIEW [dbo].[FATTURATO_FORNITORI_PER_ANNO]
GO
CREATE VIEW [dbo].[FATTURATO_FORNITORI_PER_ANNO]  
AS
	SELECT
		MOV_ANNO AS ANNO,
		MOV_CONTO AS CONTO,
		MAIN.CON_DESCR AS RAG_SOCIALE,
		SUM((CASE SUBSTRING(LIBERA,11,1) WHEN 'S' THEN -1 ELSE 1 END) * MOV_IMP) AS IMPORTO,
		FOR_CONTO1 AS CONTROP,
		COALESCE(CONTIC.CON_DESCR,'') AS DESCR_CONTROP
	FROM (
		SELECT mov_cont.*, conti.con_descr, conti.con_tipoco, COALESCE(para.libera,'') AS libera FROM mov_cont 
		LEFT OUTER JOIN conti on conti.con_anno = mov_cont.mov_anno and conti.con_conto = mov_cont.mov_conto 
		LEFT OUTER JOIN para on para.codice = 'TOP'+mov_cont.mov_top 
		WHERE con_tipoco = 'F' and SUBSTRING(libera,2,1) = 'S'
		) AS MAIN
	left outer join u_for_an on FOR_CODCLI = RIGHT(MOV_CONTO,8)
	LEFT OUTER JOIN conti AS CONTIC on CONTIC.con_anno = MAIN.mov_anno and CONTIC.con_conto = FOR_CONTO1
	GROUP BY MOV_ANNO,MOV_CONTO,MAIN.CON_DESCR,FOR_CONTO1,CONTIC.CON_DESCR

GO
