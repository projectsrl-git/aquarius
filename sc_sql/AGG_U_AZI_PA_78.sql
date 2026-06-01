
/*
*** Variabile per l'opzione "Obbliga la valorizzazione del prezzo di costo proponendo l'ultimo prezzo di costo in carichi manuali e da DDT fornitore"
*** gestita nella scheda "Altro", sottoscheda "Listini prezzi" dei parametri di sistama nel "form\menu_azi000.scx"
*/

ALTER TABLE [dbo].[u_azi_pa] ADD 
	AZI_FLGPCO bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_AZI_FLGPCO] DEFAULT (0) FOR [AZI_FLGPCO]
go

UPDATE u_azi_pa SET AZI_FLGPCO = 0
