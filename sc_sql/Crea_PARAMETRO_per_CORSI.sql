
-- PARAMETRO PER CORSO
-- codice = codice corso
-- descri = descrizione corso
-- libera = codice dell'area di riferimento (x es. ARC+"001" = Area 1)


delete from para where codice like 'COR%'

insert into para (codice,descri,libera) values ('COR001','Informatica base','001')
insert into para (codice,descri,libera) values ('COR002','Lingue','001')
insert into para (codice,descri,libera) values ('COR003','Pubblicità','002')
insert into para (codice,descri,libera) values ('COR004','Grafica','002')
insert into para (codice,descri,libera) values ('COR005','Taglio e cucito','002')

select * from para where codice like 'COR%'
