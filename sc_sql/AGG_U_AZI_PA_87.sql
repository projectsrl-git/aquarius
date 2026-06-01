
/*
*** Variabile per l'opzione gestite nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Tutti i documenti"
*** dei parametri di sistama nel "form\menu_azi000.scx":
***		- Segnala clienti a Rischio 1 / 2 nei documenti ordini/ddt/packing list

*** Variabile per l'opzione gestite nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Packing list",
*** sottoscheda "Packing list produzione pannelli truciolari" dei parametri di sistama nel "form\menu_azi000.scx":
***		- Durante la preparazione delle packing list da ordini se il cliente è a Rischio1 o Rischio2 , 
***		  attiva la stampa di un documento di AUTORIZZAZIONE con possibilità di invio e-mail
*/


if exists (select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
			left outer join sys.all_columns as col on col.object_id = tab.object_id
			where tab.type = 'U' AND tab.name = 'U_AZI_PA' AND col.name = 'AZI_OPZPKR')
	BEGIN
		ALTER TABLE [dbo].[U_AZI_PA] DROP CONSTRAINT DF_U_AZI_PA_AZI_OPZPKR
		ALTER TABLE [dbo].[U_AZI_PA] DROP COLUMN AZI_OPZPKR
	END
GO

if exists (select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
			left outer join sys.all_columns as col on col.object_id = tab.object_id
			where tab.type = 'U' AND tab.name = 'U_AZI_PA' AND col.name = 'AZI_OPZRSK')
	BEGIN
		ALTER TABLE [dbo].[U_AZI_PA] DROP CONSTRAINT DF_U_AZI_PA_AZI_OPZRSK
		ALTER TABLE [dbo].[U_AZI_PA] DROP COLUMN AZI_OPZRSK
	END
GO

if exists (select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
			left outer join sys.all_columns as col on col.object_id = tab.object_id
			where tab.type = 'U' AND tab.name = 'U_AZI_PA' AND col.name = 'AZI_PKRSTA')
	BEGIN
		ALTER TABLE [dbo].[U_AZI_PA] DROP CONSTRAINT DF_U_AZI_PA_AZI_PKRSTA
		ALTER TABLE [dbo].[U_AZI_PA] DROP COLUMN AZI_PKRSTA
	END
GO    

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_OPZRSK NUMERIC(1,0),
	AZI_PKRSTA BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_OPZRSK] DEFAULT (0) FOR [AZI_OPZRSK],
	CONSTRAINT [DF_U_AZI_PA_AZI_PKRSTA] DEFAULT (0) FOR [AZI_PKRSTA]
GO

UPDATE U_AZI_PA SET AZI_OPZRSK = 2
UPDATE U_AZI_PA SET AZI_PKRSTA = 1
