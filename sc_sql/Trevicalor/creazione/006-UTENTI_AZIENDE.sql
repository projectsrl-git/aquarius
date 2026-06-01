-- Table: utenti_aziende

-- DROP TABLE utenti_aziende;

CREATE TABLE utenti_aziende
(
  id_utente_azienda INT IDENTITY(1, 1) NOT NULL,
  id_utente integer NOT NULL,
  id_azienda integer NOT NULL,
  CONSTRAINT fk_utenti_aziende PRIMARY KEY (id_utente, id_azienda, id_utente_azienda),
  CONSTRAINT k_id_utente_azienda UNIQUE (id_utente_azienda)
)