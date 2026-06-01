
--/********************************************************
-- AGGIORNAMENTO ARTICOLI DI PRODUZIONE BOBINE
-- ********************************************************/

UPDATE U_ART_PR SET ART_TIPART = 'P', ART_TIPOPR = 'I' WHERE (ART_CODMAT = '003' OR ART_CODMAT = '008') AND ART_CODPRI NOT LIKE '%LDPE%'

--/********************************************************
-- AGGIORNAMENTO ARTICOLI DI ACQUISTO BOBINE
-- ********************************************************/
UPDATE U_ART_PR SET ART_TIPART = 'A', ART_TIPOPR = '' WHERE (ART_CODMAT = '003' OR ART_CODMAT = '008') AND ART_CODPRI LIKE '%LDPE%'