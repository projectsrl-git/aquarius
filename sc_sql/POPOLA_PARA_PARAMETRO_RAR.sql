

delete from para where codice like 'RAR001'
delete from para where codice like 'RAR002'
delete from para where codice like 'RAR003'
delete from para where codice like 'RAR004'
delete from para where codice like 'RAR005'
delete from para where codice like 'RAR006'
delete from para where codice like 'RAR007'


delete from para where codice like 'RAR01'
delete from para where codice like 'RAR02'
delete from para where codice like 'RAR03'
delete from para where codice like 'RAR04'
delete from para where codice like 'RAR05'
delete from para where codice like 'RAR06'
delete from para where codice like 'RAR07'

insert into para (codice,descri,libera) values ('RAR01','RATEI ATTIVI','115001')
insert into para (codice,descri,libera) values ('RAR02','RATEI PASSIVI','210001')
insert into para (codice,descri,libera) values ('RAR03','RISCONTI ATTIVI','110001')
insert into para (codice,descri,libera) values ('RAR04','RISCONTI ATTIVI IMMOBILE','110002')
insert into para (codice,descri,libera) values ('RAR05','RISCONTI ATTIVI LEASING IMMOBILE','110002')
insert into para (codice,descri,libera) values ('RAR06','RISCONTI ATTIVI LEASING MACCHINARI','110003')
insert into para (codice,descri,libera) values ('RAR07','RISCONTI PASSIVI','216001')






select * from para where codice like 'RAR%'

