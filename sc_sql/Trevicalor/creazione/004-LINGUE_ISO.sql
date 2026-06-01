-- Table: lingue_iso

-- DROP TABLE lingue_iso;

CREATE TABLE lingue_iso
(
  id_lingue_iso uniqueidentifier ROWGUIDCOL  NOT NULL ,
  codice_iso character(2) NOT NULL,
  lingua character varying(50) NOT NULL,
  CONSTRAINT pk_lingue_iso PRIMARY KEY (id_lingue_iso),
  CONSTRAINT k_lingue_iso_1 UNIQUE (id_lingue_iso),
  CONSTRAINT k_lingue_iso_2 UNIQUE (codice_iso)
)


insert into lingue_iso (id_lingue_iso,codice_iso,lingua) values ('EB4558D8-B87A-42FD-996C-1B01FB3B61EB','it','Italiano');
insert into lingue_iso (id_lingue_iso,codice_iso,lingua) values ('EB4558D8-B87A-42FD-996C-1B01FB3B61EC','en','English');