
--********************************************************************
-- INSERIMENTO PARAMETRO STATO FATTURE ELETTRONICHE (PORTALE BLUENEXT)
--********************************************************************

delete from para where codice like 'TLF%'

insert into para (codice,descri,libera) values ('TLFAIC','AIC','')
insert into para (codice,descri,libera) values ('TLFARI','ARISTON','')
insert into para (codice,descri,libera) values ('TLFBAX','BAXI','')
insert into para (codice,descri,libera) values ('TLFBER','BERETTA','')
insert into para (codice,descri,libera) values ('TLFCAL','CALEFFI','')
insert into para (codice,descri,libera) values ('TLFCIB','CIB UNIGAS','')
insert into para (codice,descri,libera) values ('TLFCOS','COSMOGAS','')
insert into para (codice,descri,libera) values ('TLFCOP','COPACO','')
insert into para (codice,descri,libera) values ('TLFDAB','DAB','')
insert into para (codice,descri,libera) values ('TLFIMA','GRUPPO IMAR','')
insert into para (codice,descri,libera) values ('TLFHER','HERMANN','')
insert into para (codice,descri,libera) values ('TLFRIE','RIELLO','')
insert into para (codice,descri,libera) values ('TLFROB','ROBUR','')
insert into para (codice,descri,libera) values ('TLFSAN','SANT''ANDREA','')
insert into para (codice,descri,libera) values ('TLFSIM','FONDERIE SIME S.P.A.','')
insert into para (codice,descri,libera) values ('TLFVIE','VIESSMANN','')

select * from para where codice like 'TLF%' ORDER BY CODICE

