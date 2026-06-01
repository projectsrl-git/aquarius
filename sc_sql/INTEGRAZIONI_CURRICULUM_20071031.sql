
/* 
**************************************************************
	NUOVO CAMPO IN ISTRFORM
**************************************************************
*/
ALTER TABLE [dbo].[ISTRFORM] ADD 
	 DIVIDENDO varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 DIVISORE varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[ISTRFORM] WITH NOCHECK ADD 
	CONSTRAINT [DF_ISTRFORM_DIVIDENDO] DEFAULT ('') FOR [DIVIDENDO],
	CONSTRAINT [DF_ISTRFORM_DIVISORE] DEFAULT ('') FOR [DIVISORE]
go

UPDATE ISTRFORM SET DIVIDENDO = ''
UPDATE ISTRFORM SET DIVISORE = ''





/* 
**************************************************************
	NUOVO CAMPO IN ESPPROF
**************************************************************
*/
ALTER TABLE [dbo].[ESPPROF] ADD 
	 ATTIVMANS_ISTR varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[ESPPROF] WITH NOCHECK ADD 
	CONSTRAINT [DF_ESPPROF_ATTIVMANS_ISTR] DEFAULT ('') FOR [ATTIVMANS_ISTR]
go

UPDATE ESPPROF SET ATTIVMANS_ISTR = ''






/* 
**************************************************************
	NUOVO CAMPO IN CURRICUL
**************************************************************
*/
ALTER TABLE [dbo].[CURRICUL] ADD 
	IDTIOPL_INFO_ATT varchar(3) COLLATE Latin1_General_CI_AS NULL,
	IDTIPOCNTR_ATT varchar(3) COLLATE Latin1_General_CI_AS NULL,
	RETRIB_ATT numeric(17,2) NULL,
	PREAVV_ATT varchar(3) COLLATE Latin1_General_CI_AS NULL,
	ATTIVMANS_ISTR_ATT varchar(3) COLLATE Latin1_General_CI_AS NULL,
	IDTIOPL_INFO_RIC varchar(3) COLLATE Latin1_General_CI_AS NULL,
	IDTIPOCNTR_RIC varchar(3) COLLATE Latin1_General_CI_AS NULL,
	RETRIB_RIC numeric(17,2) NULL,
	ATTIVMANS_ISTR_RIC varchar(3) COLLATE Latin1_General_CI_AS NULL,
	TRASFERTE varchar(3) COLLATE Latin1_General_CI_AS NULL,
	TURNI varchar(3) COLLATE Latin1_General_CI_AS NULL,
	ATTIVMANS_PROF varchar(3) COLLATE Latin1_General_CI_AS NULL
go	
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)	
ALTER TABLE [dbo].[CURRICUL] WITH NOCHECK ADD 
	CONSTRAINT [DF_CURRICUL_IDTIOPL_INFO_ATT] DEFAULT ('') FOR [IDTIOPL_INFO_ATT],
	CONSTRAINT [DF_CURRICUL_IDTIPOCNTR_ATT] DEFAULT ('') FOR [IDTIPOCNTR_ATT],
	CONSTRAINT [DF_CURRICUL_RETRIB_ATT] DEFAULT (0) FOR [RETRIB_ATT],
	CONSTRAINT [DF_CURRICUL_PREAVV_ATT] DEFAULT ('') FOR [PREAVV_ATT],
	CONSTRAINT [DF_CURRICUL_ATTIVMANS_ISTR_ATT] DEFAULT ('') FOR [ATTIVMANS_ISTR_ATT],
	CONSTRAINT [DF_CURRICUL_IDTIOPL_INFO_RIC] DEFAULT ('') FOR [IDTIOPL_INFO_RIC],
	CONSTRAINT [DF_CURRICUL_IDTIPOCNTR_RIC] DEFAULT ('') FOR [IDTIPOCNTR_RIC],
	CONSTRAINT [DF_CURRICUL_RETRIB_RIC] DEFAULT (0) FOR [RETRIB_RIC],
	CONSTRAINT [DF_CURRICUL_ATTIVMANS_ISTR_RIC] DEFAULT ('') FOR [ATTIVMANS_ISTR_RIC],
	CONSTRAINT [DF_CURRICUL_TRASFERTE] DEFAULT ('') FOR [TRASFERTE],
	CONSTRAINT [DF_CURRICUL_TURNI] DEFAULT ('') FOR [TURNI],
	CONSTRAINT [DF_CURRICUL_ATTIVMANS_PROF] DEFAULT ('') FOR [ATTIVMANS_PROF]
go


UPDATE CURRICUL SET IDTIOPL_INFO_ATT = '' 	  
UPDATE CURRICUL SET IDTIPOCNTR_ATT = '' 	  
UPDATE CURRICUL SET RETRIB_ATT = 0 	  
UPDATE CURRICUL SET PREAVV_ATT = '' 	  
UPDATE CURRICUL SET ATTIVMANS_ISTR_ATT = '' 	  
UPDATE CURRICUL SET IDTIOPL_INFO_RIC = '' 	  
UPDATE CURRICUL SET IDTIPOCNTR_RIC = '' 	  
UPDATE CURRICUL SET RETRIB_RIC = 0 	  
UPDATE CURRICUL SET ATTIVMANS_ISTR_RIC = '' 	   	
UPDATE CURRICUL SET TRASFERTE = '' 	  
UPDATE CURRICUL SET TURNI = '' 	  
UPDATE CURRICUL SET ATTIVMANS_PROF = '' 	  




/* 
**************************************************************
	NUOVO CAMPO IN COLLOQUI
**************************************************************
*/
ALTER TABLE [dbo].[COLLOQUI] ADD 
	RISCOLLOQUIO varchar(3) COLLATE Latin1_General_CI_AS NULL,
	RICHIESTASPEC text COLLATE Latin1_General_CI_AS NULL
go	
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)	
ALTER TABLE [dbo].[COLLOQUI] WITH NOCHECK ADD 
	CONSTRAINT [DF_COLLOQUI_RISCOLLOQUIO] DEFAULT ('') FOR [RISCOLLOQUIO],
	CONSTRAINT [DF_COLLOQUI_RICHIESTASPEC] DEFAULT ('') FOR [RICHIESTASPEC]
go

UPDATE COLLOQUI SET RISCOLLOQUIO = '' 	  
UPDATE COLLOQUI SET RICHIESTASPEC = '' 	 




/* 
**************************************************************
	CAMBIO TIPO DI CAMPO
**************************************************************
*/
ALTER TABLE [dbo].[CURRICUL] ALTER COLUMN
	DISPONDAL varchar(10) COLLATE Latin1_General_CI_AS NULL
go	





-- PARAMETRO PER TRASFERTE

delete from para where codice like 'TRX%'

insert into para (codice,descri) values ('TRX001','Nessuna disponibilità')
insert into para (codice,descri) values ('TRX002','Italia - Brevi')
insert into para (codice,descri) values ('TRX003','Italia')
insert into para (codice,descri) values ('TRX004','Estero - Brevi')
insert into para (codice,descri) values ('TRX005','Estero')
insert into para (codice,descri) values ('TRX006','Italia/Estero - Brevi')
insert into para (codice,descri) values ('TRX007','Italia/Estero')

select * from para where codice like 'TRX%'




-- PARAMETRO PER PREAVVISO

delete from para where codice like 'PRV%'

insert into para (codice,descri) values ('PRV001','1 settimana')
insert into para (codice,descri) values ('PRV002','2 settimane')
insert into para (codice,descri) values ('PRV003','3 settimane')
insert into para (codice,descri) values ('PRV004','1 mese')
insert into para (codice,descri) values ('PRV005','2 mesi')
insert into para (codice,descri) values ('PRV006','3 mesi')
insert into para (codice,descri) values ('PRV007','4 mesi')
insert into para (codice,descri) values ('PRV008','5 mesi')
insert into para (codice,descri) values ('PRV009','6 mesi')
insert into para (codice,descri) values ('PRV010','7 mesi')
insert into para (codice,descri) values ('PRV011','8 mesi')
insert into para (codice,descri) values ('PRV012','9 mesi')
insert into para (codice,descri) values ('PRV012','10 mesi')
insert into para (codice,descri) values ('PRV012','11 mesi')
insert into para (codice,descri) values ('PRV012','1 anno')
insert into para (codice,descri) values ('PRV012','Più di 1 anno')

select * from para where codice like 'PRV%'




-- PARAMETRO PER VALUTAZIONE PERSONA

delete from para where codice like 'VLP%'

insert into para (codice,descri) values ('VLP001','Negativa')
insert into para (codice,descri) values ('VLP002','Media')
insert into para (codice,descri) values ('VLP003','Positiva')

select * from para where codice like 'VLP%'



-- PARAMETRO PER RISULTATO COLLOQUIO

delete from para where codice like 'RCQ%'

insert into para (codice,descri) values ('RCQ001','Adeguato')
insert into para (codice,descri) values ('RCQ002','Non Adeguato')
insert into para (codice,descri) values ('RCQ003','Necessario uteriore approfondimento')
insert into para (codice,descri) values ('RCQ004','Non risponde al telefono/mail')
insert into para (codice,descri) values ('RCQ005','Non interessato')
insert into para (codice,descri) values ('RCQ006','Fissato colloquio in Sede')

select * from para where codice like 'RCQ%'


