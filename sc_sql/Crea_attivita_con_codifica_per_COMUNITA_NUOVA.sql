
insert into para (codice,descri,classe,libera) values ('CMP50','Personale							                               ',0,'R')
insert into para (codice,descri,classe,libera) values ('CMP51','Attività							                               ',0,'X')
insert into para (codice,descri,classe,libera) values ('CMP52','Utenze							                                 ',0,'X')
insert into para (codice,descri,classe,libera) values ('CMP53','Acquisto materiali, spese generali e servizi				 ',0,'X')
insert into para (codice,descri,classe,libera) values ('CMP54','Acquisto e manutenzione attrezzature, locali e arredi',0,'X')
insert into para (codice,descri,classe,libera) values ('CMP55','Acquisto e gestione automezzi							           ',0,'X')
insert into para (codice,descri,classe,libera) values ('CMP56','Affitti e spese condominiali							           ',0,'X')
insert into para (codice,descri,classe,libera) values ('CMP57','Imposte, tasse, spese bancarie							         ',0,'X')
insert into para (codice,descri,classe,libera) values ('CMP58','Spese varie							                             ',0,'X')
insert into para (codice,descri,classe,libera) values ('CMP59','Entrate da rette							                       ',1,'X')
insert into para (codice,descri,classe,libera) values ('CMP60','Entrate da altri contributi pubblici							   ',1,'X')
insert into para (codice,descri,classe,libera) values ('CMP61','Entrate da fondazioni private							           ',1,'X')
insert into para (codice,descri,classe,libera) values ('CMP62','Entrate da donazioni e sponsor privati							 ',1,'X')
insert into para (codice,descri,classe,libera) values ('CMP63','Entrate da attività e iniziative							       ',1,'X')
insert into para (codice,descri,classe,libera) values ('CMP64','Entrate da utenti							                       ',1,'X')

select * from para where codice like 'CMP%' order by codice
