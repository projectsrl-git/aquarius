
DELETE FROM PARA WHERE CODICE LIKE 'CMPA%'

UPDATE PARA SET DISATTIVO = 1 WHERE CODICE LIKE 'CMP%'

INSERT INTO PARA (CODICE,DESCRI,LIBERA,DESIVA,ITALIANO) VALUES ('CMPA1','Analisi preliminare','Relazione preliminare + schede esigenze + rilievo','Ore tecnico + spese trasferte','Sopralluogo e rilievo
Raccolta esigenze cliente e Definizione budget preliminare')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,DESIVA,ITALIANO) VALUES ('CMPA2','Concept Design','Tavole concept + moodboard approvata','Ore progettista / grafico','Layout distributivo iniziale
Moodboard e palette materiali
Confronti con cliente e validazione concept')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,DESIVA,ITALIANO) VALUES ('CMPA3','Progetto definitivo','Tavole esecutive + capitolato descrittivo','Ore progettista + consulenze specialistiche','Elaborati tecnici (piante, sezioni, render, modello architettonico 3D)
Scelta materiali e arredi
Redazione capitolato tecnico')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,DESIVA,ITALIANO) VALUES ('CMPA4','Stima economica','Computo metrico di massima + report revisione','Ore tecnico contabile','Stima costi di massima
Revisione progetto in base al budget')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,DESIVA,ITALIANO) VALUES ('CMPA5','Art Direction','Verbali visite + note di verifica estetica','Ore di direzione artistica / visite cantiere','Supervisione estetica
Approvazione varianti
Presenze mirate in cantiere
Coordinamento con PM')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,DESIVA,ITALIANO) VALUES ('CMPA6','Logistica','organizzazione spedizioni + stivaggio materiale ','Ore di gestione','Spese di spedizione
Gestione magazzino')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,DESIVA,ITALIANO) VALUES ('CMPA7','Ricerca e Sviluppo','','Ore di gestione','Sviluppo prototipi
Selezione campionature 
Corsi di aggiornamento
Ricerca materiali ')

SELECT * FROM PARA WHERE CODICE LIKE 'CMP%' AND DISATTIVO = 0 ORDER BY CODICE

