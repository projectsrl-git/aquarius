
--################################################################################################
--################################################################################################
--##
--##		MOVIMENTI DI MAGAZZINO
--##
--################################################################################################
--################################################################################################

--- TEST SULLA DATA DOCUMENTO
SELECT MOV_DTDOCU,MOV_DTREGI,MOV_DATORF,MOV_DATSCA,MOV_ANNO
FROM U_MAG_MO 
WHERE ( LEN(LTRIM(MOV_DTDOCU)) != 0 AND (	LEN(LTRIM(MOV_DTDOCU)) < 10 OR LEN(LTRIM(SUBSTRING(MOV_DTDOCU,1,4))) < 4 ) )
OR    ( LEN(LTRIM(MOV_DTREGI)) != 0 AND (	LEN(LTRIM(MOV_DTREGI)) < 10 OR LEN(LTRIM(SUBSTRING(MOV_DTREGI,1,4))) < 4 ) )
OR    ( LEN(LTRIM(MOV_DATORF)) != 0 AND (	LEN(LTRIM(MOV_DATORF)) < 10 OR LEN(LTRIM(SUBSTRING(MOV_DATORF,1,4))) < 4 ) )
OR    ( LEN(LTRIM(MOV_DATSCA)) != 0 AND (	LEN(LTRIM(MOV_DATSCA)) < 10 OR LEN(LTRIM(SUBSTRING(MOV_DATSCA,1,4))) < 4 ) )
OR	  ( LEN(LTRIM(MOV_ANNO)) < 4 AND LEN(LTRIM(MOV_ANNO)) != 0  )

ORDER BY MOV_DTDOCU



--- TEST SULLA DATA DI REGISTRAZIONE
SELECT MOV_DTDOCU,MOV_DTREGI,MOV_DATORF,MOV_DATSCA,MOV_ANNO,* 
FROM U_MAG_MO 
WHERE LEN(LTRIM(MOV_DTREGI)) != 0 AND (	LEN(LTRIM(MOV_DTREGI)) < 10 OR LEN(LTRIM(SUBSTRING(MOV_DTREGI,1,4))) < 4)
--and mov_top = 'in+'
ORDER BY MOV_DTREGI




--- LE DATE QUI "SONO TUTTE OK"
SELECT MOV_DTDOCU,MOV_DTREGI,MOV_DATORF,MOV_DATSCA,MOV_ANNO,* 
FROM U_MAG_MO 
WHERE LEN(LTRIM(MOV_DATORF)) != 0 AND (	LEN(LTRIM(MOV_DATORF)) < 10 OR LEN(LTRIM(SUBSTRING(MOV_DATORF,1,4))) < 4 )
--and mov_top = 'in+'
ORDER BY MOV_DATORF




--- TEST SULLA DATA DI SCARICO
SELECT MOV_DTDOCU,MOV_DTREGI,MOV_DATORF,MOV_DATSCA,MOV_ANNO,* 
FROM U_MAG_MO 
WHERE LEN(LTRIM(MOV_DATSCA)) != 0 AND (	LEN(LTRIM(MOV_DATSCA)) < 10 OR LEN(LTRIM(SUBSTRING(MOV_DATSCA,1,4))) < 4 )
--and mov_top = 'in+'
ORDER BY MOV_DATSCA




--################################################################################################
--################################################################################################
--##
--##		U_MAG_GG  --  GIACENZE DI MAGAZZINO
--##
--################################################################################################
--################################################################################################
SELECT MAG_DATAGG,* 
FROM U_MAG_GG
WHERE LEN(LTRIM(MAG_DATAGG)) != 0
AND (	LEN(LTRIM(MAG_DATAGG)) < 10 
		OR 
		LEN(LTRIM(SUBSTRING(MAG_DATAGG,1,4))) < 4
	)
ORDER BY MAG_DATAGG




--################################################################################################
--################################################################################################
--##
--##		U_MAG_AN  
--##
--################################################################################################
--################################################################################################
SELECT MAG_DTCREA,* 
FROM U_MAG_AN
WHERE LEN(LTRIM(MAG_DTCREA)) != 0
AND (	LEN(LTRIM(MAG_DTCREA)) < 10 
		OR 
		LEN(LTRIM(SUBSTRING(MAG_DTCREA,1,4))) < 4
	)
ORDER BY MAG_DTCREA


--select * from sys.tables where substring(name,1,5) = 'u_mag'

--################################################################################################
--################################################################################################
--##
--##		U_MAG_AR  
--##
--################################################################################################
--################################################################################################
select MAG_DATAGG,* from U_MAG_AR
WHERE LEN(LTRIM(MAG_DATAGG)) != 0
AND (	LEN(LTRIM(MAG_DATAGG)) < 10 
		OR 
		LEN(LTRIM(SUBSTRING(MAG_DATAGG,1,4))) < 4
	)
ORDER BY MAG_DATAGG


-- VUOTA
-- select * from U_MAG_CA

-- VUOTA
-- select * from U_MAG_CL

-- VUOTA
-- select * from U_MAG_CP

-- VUOTA
-- select * from U_MAG_DA

-- VUOTA
-- select * from U_MAG_DF

-- VUOTA
-- select * from U_MAG_DM

-- VUOTA
-- select * from U_MAG_GS

-- VUOTA
-- select * from U_MAG_IN

-- VUOTA
-- select * from U_MAG_MF

-- VUOTA
-- select * from U_MAG_MS

-- VUOTA
-- select * from U_MAG_PR

-- VUOTA
-- select * from U_MAG_RI

-- VUOTA
-- select * from U_MAG_SS


--################################################################################################
--################################################################################################
--##
--##		U_MAG_FO  
--##
--################################################################################################
--################################################################################################
select * from U_MAG_FO
WHERE LEN(LTRIM(MAG_DATAGG)) != 0
AND (	LEN(LTRIM(MAG_DATAGG)) < 10 
		OR 
		LEN(LTRIM(SUBSTRING(MAG_DATAGG,1,4))) < 4
	)
ORDER BY MAG_DATAGG


--################################################################################################
--################################################################################################
--##
--##		U_MAG_MA  
--##
--################################################################################################
--################################################################################################
select * from U_MAG_MA
WHERE LEN(LTRIM(MAG_DATAGG)) != 0
AND (	LEN(LTRIM(MAG_DATAGG)) < 10 
		OR 
		LEN(LTRIM(SUBSTRING(MAG_DATAGG,1,4))) < 4
	)
ORDER BY MAG_DATAGG


--################################################################################################
--################################################################################################
--##
--##		U_MAG_SA  
--##
--################################################################################################
--################################################################################################
select * from U_MAG_SA
WHERE LEN(LTRIM(MAG_DATAGG)) != 0
AND (	LEN(LTRIM(MAG_DATAGG)) < 10 
		OR 
		LEN(LTRIM(SUBSTRING(MAG_DATAGG,1,4))) < 4
	)
ORDER BY MAG_DATAGG