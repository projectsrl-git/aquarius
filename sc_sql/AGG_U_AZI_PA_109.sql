/* 
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Attiva la gestione della produzione dadi pressati
*/

ALTER TABLE [dbo].[u_azi_pa] ADD 
	 azi_contes [bit] NULL,
	 azi_condet [bit] NULL,
	 azi_conxrig[bit] NULL,
	 azi_conobl [bit] NULL,
	 azi_ccotes [bit] NULL,
	 azi_ccodet [bit] NULL,
	 azi_ccoxrig [bit] NULL,
	 azi_ccoobl [bit] NULL,
	 azi_noriford [bit] NULL,
	 azi_noriffat [bit] NULL
go 
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_azi_contes] DEFAULT (0) FOR [azi_contes],
	CONSTRAINT [DF_u_azi_pa_azi_condet] DEFAULT (0) FOR [azi_condet],
	CONSTRAINT [DF_u_azi_pa_azi_conxrig] DEFAULT (0) FOR [azi_conxrig],
	CONSTRAINT [DF_u_azi_pa_azi_conobl] DEFAULT (0) FOR [azi_conobl],
	CONSTRAINT [DF_u_azi_pa_azi_ccotes] DEFAULT (0) FOR [azi_ccotes],
	CONSTRAINT [DF_u_azi_pa_azi_ccodet] DEFAULT (0) FOR [azi_ccodet],
	CONSTRAINT [DF_u_azi_pa_azi_ccoxrig] DEFAULT (0) FOR [azi_ccoxrig],
	CONSTRAINT [DF_u_azi_pa_azi_ccoobl] DEFAULT (0) FOR [azi_ccoobl],
	CONSTRAINT [DF_u_azi_pa_azi_noriford] DEFAULT (0) FOR [azi_noriford],
	CONSTRAINT [DF_u_azi_pa_azi_noriffat] DEFAULT (0) FOR [azi_noriffat]
go


UPDATE u_azi_pa SET azi_contes = 0 
UPDATE u_azi_pa SET azi_condet = 0 
UPDATE u_azi_pa SET azi_conxrig = 0 
UPDATE u_azi_pa SET azi_conobl = 0 
UPDATE u_azi_pa SET azi_ccotes = 0 
UPDATE u_azi_pa SET azi_ccodet = 0 
UPDATE u_azi_pa SET azi_ccoxrig = 0 
UPDATE u_azi_pa SET azi_ccoobl = 0 
UPDATE u_azi_pa SET azi_noriford = 0 
UPDATE u_azi_pa SET azi_noriffat = 0













