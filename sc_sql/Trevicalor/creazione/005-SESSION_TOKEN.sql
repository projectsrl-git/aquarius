-- Table: session_token

-- DROP TABLE session_token;

CREATE TABLE session_token
(
  id_token  uniqueidentifier ROWGUIDCOL  NOT NULL ,
  ipaddress character varying NOT NULL,
  ts_ins datetime,
  datamap text,
  CONSTRAINT key2 PRIMARY KEY (id_token)
)