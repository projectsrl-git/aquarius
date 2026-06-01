
-- ########################################################################################
-- ###### AGGIORNAMENTO ARTICOLI CARTA GREZZA PER PRODUZIONE PANNELLI TRUCIOLARI
-- ########################################################################################

UPDATE U_ART_PR SET ART_TIPART = 'L' WHERE ART_CODPRI LIKE '01.003.G%'

SELECT ART_TIPART,* FROM U_ART_PR WHERE ART_CODPRI LIKE '01.003.G%' ORDER BY ART_CODPRI