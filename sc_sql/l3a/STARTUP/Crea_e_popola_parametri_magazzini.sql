
-- ATTIVAZIONE MAGAZZINI PER PIANIFICAZIONE PRODUZIONE
UPDATE para SET LIBERA = '' where codice LIKE 'MAG%'

UPDATE para SET LIBERA = 'S' where codice = 'MAGMAP'
UPDATE para SET LIBERA = 'S' where codice = 'MAG006'
UPDATE para SET LIBERA = 'S' where codice = 'MAG010'


select * from para where codice like 'MAG%' ORDER BY CODICE


