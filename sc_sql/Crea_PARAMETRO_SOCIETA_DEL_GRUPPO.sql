
-- PARAMETRO PER SOCIETA' DEL GRUPPO

delete from para where codice like 'SSG%'

insert into para (codice,descri,libera) values ('SSG001','CROSSOVER GROUP S.R.L.','aq_CrossOverGroupSrl')
insert into para (codice,descri,libera) values ('SSG002','CROSSOVER ITALIA S.R.L.','aq_CrossOverItaliaSrl')
insert into para (codice,descri,libera) values ('SSG003','CROSSOVER S.R.L.','aq_CrossOverSrl')
insert into para (codice,descri,libera) values ('SSG004','CROSSOVER SUD S.R.L.','aq_CrossOverSudSrl')
insert into para (codice,descri,libera) values ('SSG005','ETHIKON','aq_Ethikon')
insert into para (codice,descri,libera) values ('SSG006','GBO S.R.L.','aq_GboSrl')
insert into para (codice,descri,libera) values ('SSG007','KM ITALIA S.R.L.','aq_KmItaliaSrl')
insert into para (codice,descri,libera) values ('SSG008','FONDAZIONE ONLUS','aq_FondazioneOnlus')
insert into para (codice,descri,libera) values ('SSG009','PARTNERS ASSOCIATES','aq_PA')
insert into para (codice,descri,libera) values ('SSG010','WEB CROSSOVER GROUP S.R.L.','aq2_CrossOverGroupSrl')
insert into para (codice,descri,libera) values ('SSG011','WEB TEST','AQ_test')

select * from para where codice like 'SSG%'
