   
/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "TIPOLOGIA ORDINE" IN PARA
**********************************************************************************************
*/

DELETE PARA WHERE SUBSTRING(CODICE,1,3) = 'TDE'

INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE,ITALIANO) values ('TDECLI-GEC','TESTO INVIO EMAIL RELATIVO A DOCUMENTI GENERICI CLIENTI','Invio documenti','IN LIBERA INSERIRE : OGGETTO EMAIL
NEL MESSAGGIO INSERIRE : CORPO EMAIL

Se non specificato in anagrafica clienti/fornitori le procedure di invio delle email considerano questi testi','Gent.le Cliente 
In allegato le inviamo quanto riportato in oggetto. 

Cordiali saluti 
ENNEESSE S.R.L. 
Sede legale : Via V. Monti, 32 - 20123 Milano 
Sede Operativa e Amministrativa : Via A.Da Giussano, 34 - 20011 Corbetta (MI) 
Tel. +39 02 90.12.194  -  +39 02 90.37.86.29  -  Fax +39 02 90.37.65.88 
e-mail : Info@enneesse.it 
Web : http://www.enneesse.it 

')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE,ITALIANO) values ('TDECLI-GEF','TESTO INVIO EMAIL RELATIVO A DOCUMENTI GENERICI FORNITORI','Invio documenti','IN LIBERA INSERIRE : OGGETTO EMAIL
NEL MESSAGGIO INSERIRE : CORPO EMAIL

Se non specificato in anagrafica clienti/fornitori le procedure di invio delle email considerano questi testi','Gent.le Fornitore 
In allegato le inviamo quanto riportato in oggetto. 

Cordiali saluti 
ENNEESSE S.R.L. 
Sede legale : Via V. Monti, 32 - 20123 Milano 
Sede Operativa e Amministrativa : Via A.Da Giussano, 34 - 20011 Corbetta (MI) 
Tel. +39 02 90.12.194  -  +39 02 90.37.86.29  -  Fax +39 02 90.37.65.88 
e-mail : Info@enneesse.it 
Web : http://www.enneesse.it 

')


INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE,ITALIANO) values ('TDECLI-FAT','TESTO INVIO EMAIL RELATIVO ALLE FATTURE ','&_YEAR - &_MONTH Invio fatture di vendita','IN LIBERA INSERIRE : OGGETTO EMAIL
NEL MESSAGGIO INSERIRE : CORPO EMAIL

Se non specificato in anagrafica clienti/fornitori le procedure di invio delle email considerano questi testi','Gent.le Cliente 
In allegato le inviamo quanto riportato in oggetto. 

Cordiali saluti 
ENNEESSE S.R.L. 
Sede legale : Via V. Monti, 32 - 20123 Milano 
Sede Operativa e Amministrativa : Via A.Da Giussano, 34 - 20011 Corbetta (MI) 
Tel. +39 02 90.12.194  -  +39 02 90.37.86.29  -  Fax +39 02 90.37.65.88 
e-mail : Info@enneesse.it 
Web : http://www.enneesse.it 

')

INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE,ITALIANO) values ('TDECLI-FAP','TESTO INVIO EMAIL RELATIVO ALLE FATTURE PROFORMA ','&_YEAR - &_MONTH Invio fatture proforma','IN LIBERA INSERIRE : OGGETTO EMAIL
NEL MESSAGGIO INSERIRE : CORPO EMAIL

Se non specificato in anagrafica clienti/fornitori le procedure di invio delle email considerano questi testi','Gent.le Cliente 
In allegato le inviamo quanto riportato in oggetto. 

Cordiali saluti 
ENNEESSE S.R.L. 
Sede legale : Via V. Monti, 32 - 20123 Milano 
Sede Operativa e Amministrativa : Via A.Da Giussano, 34 - 20011 Corbetta (MI) 
Tel. +39 02 90.12.194  -  +39 02 90.37.86.29  -  Fax +39 02 90.37.65.88 
e-mail : Info@enneesse.it 
Web : http://www.enneesse.it 

')
 
INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE,ITALIANO) values ('TDECLI-BOL','TESTO INVIO EMAIL RELATIVO AI DOCUMENTI DI TRASPORTO ','&_YEAR - &_MONTH Invio documenti di trasporto','IN LIBERA INSERIRE : OGGETTO EMAIL
NEL MESSAGGIO INSERIRE : CORPO EMAIL

Se non specificato in anagrafica clienti/fornitori le procedure di invio delle email considerano questi testi','Gent.le Cliente 
In allegato le inviamo quanto riportato in oggetto. 

Cordiali saluti 
ENNEESSE S.R.L. 
Sede legale : Via V. Monti, 32 - 20123 Milano 
Sede Operativa e Amministrativa : Via A.Da Giussano, 34 - 20011 Corbetta (MI) 
Tel. +39 02 90.12.194  -  +39 02 90.37.86.29  -  Fax +39 02 90.37.65.88 
e-mail : Info@enneesse.it 
Web : http://www.enneesse.it 

')

INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE,ITALIANO) values ('TDECLI-OFF','TESTO INVIO EMAIL RELATIVO AI PREVENTIVI CLIENTI ','&_YEAR - &_MONTH Invio preventivi clienti','IN LIBERA INSERIRE : OGGETTO EMAIL
NEL MESSAGGIO INSERIRE : CORPO EMAIL

Se non specificato in anagrafica clienti/fornitori le procedure di invio delle email considerano questi testi','Gent.le Cliente 
In allegato le inviamo quanto riportato in oggetto. 

Cordiali saluti 
ENNEESSE S.R.L. 
Sede legale : Via V. Monti, 32 - 20123 Milano 
Sede Operativa e Amministrativa : Via A.Da Giussano, 34 - 20011 Corbetta (MI) 
Tel. +39 02 90.12.194  -  +39 02 90.37.86.29  -  Fax +39 02 90.37.65.88 
e-mail : Info@enneesse.it 
Web : http://www.enneesse.it 

')

INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE,ITALIANO) values ('TDECLI-ORD','TESTO INVIO EMAIL RELATIVO ALLE CONFERME ORDINI CLIENTI ','&_YEAR - &_MONTH Invio conferme ordini','IN LIBERA INSERIRE : OGGETTO EMAIL
NEL MESSAGGIO INSERIRE : CORPO EMAIL

Se non specificato in anagrafica clienti/fornitori le procedure di invio delle email considerano questi testi','Gent.le Cliente 
In allegato le inviamo quanto riportato in oggetto. 

Cordiali saluti 
ENNEESSE S.R.L. 
Sede legale : Via V. Monti, 32 - 20123 Milano 
Sede Operativa e Amministrativa : Via A.Da Giussano, 34 - 20011 Corbetta (MI) 
Tel. +39 02 90.12.194  -  +39 02 90.37.86.29  -  Fax +39 02 90.37.65.88 
e-mail : Info@enneesse.it 
Web : http://www.enneesse.it 

')

INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE,ITALIANO) values ('TDEFOR-ORF','TESTO INVIO EMAIL RELATIVO AGLI ORDINI FORNITORI ','&_YEAR - &_MONTH Invio ordini fornitori','IN LIBERA INSERIRE : OGGETTO EMAIL
NEL MESSAGGIO INSERIRE : CORPO EMAIL

Se non specificato in anagrafica clienti/fornitori le procedure di invio delle email considerano questi testi','Gent.le Fornitore 
In allegato le inviamo quanto riportato in oggetto. 

Cordiali saluti 
ENNEESSE S.R.L. 
Sede legale : Via V. Monti, 32 - 20123 Milano 
Sede Operativa e Amministrativa : Via A.Da Giussano, 34 - 20011 Corbetta (MI) 
Tel. +39 02 90.12.194  -  +39 02 90.37.86.29  -  Fax +39 02 90.37.65.88 
e-mail : Info@enneesse.it 
Web : http://www.enneesse.it 

')

