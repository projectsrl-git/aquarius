-- Table: aziende

-- DROP TABLE aziende;

CREATE TABLE aziende
(
  id_azienda INT IDENTITY(1, 1) NOT NULL,
  id_azienda_parent integer,
  codice character varying(10) NOT NULL,
  ragsoc character varying(100) NOT NULL,
  partita_iva character(11),
  codice_fiscale character(16),
  alias_azienda character varying(50) NOT NULL,
  tipo_azienda character varying(100),
  indirizzo character(200),
  fl_disattivo bit NOT NULL DEFAULT 0,
  sedelegale_registroimprese character varying,
  registroimprese_rea character varying,
  registroimprese_numeroiscrizione character varying,
  azienda_formagiuridica character varying,
  sedisecondarie_unitalocali text,
  oggettosociale character varying,
  sindacisupplenti integer,
  sindacieffettivi integer,
  componenti_cda integer,
  azienda_attocostituzione character(10),
  sedelegale_codicefiscale character varying,
  sedelegale_indirizzocompleto character varying,
  sedelegale_telefono character varying,
  sedelegale_fax character varying,
  sedelegale_pec character varying,
  sedelegale_mail character varying,
  inps_sede character varying,
  inps_matricola character varying,
  inail_sede character varying,
  inail_matricola character varying,
  agenziaentrate_ufficio character varying,
  agenziaentrate_indirizzocompleto character varying,
  industrial_area character(3),
  CONSTRAINT pk_aziende PRIMARY KEY (id_azienda),
  CONSTRAINT id_azienda UNIQUE (id_azienda)
)

