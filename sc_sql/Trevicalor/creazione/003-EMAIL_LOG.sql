-- Table: email_log

DROP TABLE email_log;

CREATE TABLE email_log
(
  id_email_log uniqueidentifier ROWGUIDCOL  NOT NULL ,
  sender character varying(100) NOT NULL,
  recipients_to character varying(250) NOT NULL,
  recipients_cc character varying(250) NOT NULL,
  recipients_bcc character varying(250),
  subject character varying(150),
  body text,
  attachment_list character varying(250),
  attempts integer NOT NULL,
  ts_send datetime,
  email_data text NOT NULL,
  fl_sent  BIT DEFAULT 0 NOT NULL,
  username character varying(150),
  ts_ins datetime,
  fl_stop_send  BIT DEFAULT 0 NOT NULL,
  CONSTRAINT key_email_log PRIMARY KEY (id_email_log)
)
