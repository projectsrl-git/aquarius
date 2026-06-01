
/*
*** Cancellazione campi PAR_A-B-C-D-E-F-G-H gestiti in PARA
*/
if exists(select * from sys.columns where name = 'PAR_A' and object_id = object_id(N'[dbo].[PARA]'))
BEGIN
	ALTER TABLE PARA DROP CONSTRAINT DF_PARA_PAR_A
	ALTER TABLE PARA DROP COLUMN PAR_A
END

if exists(select * from sys.columns where name = 'PAR_B' and object_id = object_id(N'[dbo].[PARA]'))
BEGIN
	ALTER TABLE PARA DROP CONSTRAINT DF_PARA_PAR_B
	ALTER TABLE PARA DROP COLUMN PAR_B
END

if exists(select * from sys.columns where name = 'PAR_C' and object_id = object_id(N'[dbo].[PARA]'))
BEGIN
	ALTER TABLE PARA DROP CONSTRAINT DF_PARA_PAR_C
	ALTER TABLE PARA DROP COLUMN PAR_C
END

if exists(select * from sys.columns where name = 'PAR_D' and object_id = object_id(N'[dbo].[PARA]'))
BEGIN
	ALTER TABLE PARA DROP CONSTRAINT DF_PARA_PAR_D
	ALTER TABLE PARA DROP COLUMN PAR_D
END

if exists(select * from sys.columns where name = 'PAR_E' and object_id = object_id(N'[dbo].[PARA]'))
BEGIN
	ALTER TABLE PARA DROP CONSTRAINT DF_PARA_PAR_E
	ALTER TABLE PARA DROP COLUMN PAR_E
END

if exists(select * from sys.columns where name = 'PAR_F' and object_id = object_id(N'[dbo].[PARA]'))
BEGIN
	ALTER TABLE PARA DROP CONSTRAINT DF_PARA_PAR_F
	ALTER TABLE PARA DROP COLUMN PAR_F
END

if exists(select * from sys.columns where name = 'PAR_G' and object_id = object_id(N'[dbo].[PARA]'))
BEGIN
	ALTER TABLE PARA DROP CONSTRAINT DF_PARA_PAR_G
	ALTER TABLE PARA DROP COLUMN PAR_G
END

if exists(select * from sys.columns where name = 'PAR_H' and object_id = object_id(N'[dbo].[PARA]'))
BEGIN
	ALTER TABLE PARA DROP CONSTRAINT DF_PARA_PAR_H
	ALTER TABLE PARA DROP COLUMN PAR_H
END




/*
*** Variabili gestite per ottenere le formule di calcolo relative alle manutenzioni impianti dai listini
*/

        
ALTER TABLE [DBO].[PARANEW] ADD 
	PAR_A bit NOT NULL CONSTRAINT [DF_PARANEW_PAR_A] DEFAULT (0),
	PAR_B bit NOT NULL CONSTRAINT [DF_PARANEW_PAR_B] DEFAULT (0),
	PAR_C bit NOT NULL CONSTRAINT [DF_PARANEW_PAR_C] DEFAULT (0),
	PAR_D bit NOT NULL CONSTRAINT [DF_PARANEW_PAR_D] DEFAULT (0),
	PAR_E bit NOT NULL CONSTRAINT [DF_PARANEW_PAR_E] DEFAULT (0),
	PAR_F bit NOT NULL CONSTRAINT [DF_PARANEW_PAR_F] DEFAULT (0),
	PAR_G bit NOT NULL CONSTRAINT [DF_PARANEW_PAR_G] DEFAULT (0),
	PAR_H bit NOT NULL CONSTRAINT [DF_PARANEW_PAR_H] DEFAULT (0)
GO
