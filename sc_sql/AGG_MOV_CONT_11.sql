/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/    

ALTER TABLE [dbo].[MOV_CONT] ADD 
  MOV_MODINC varchar(1) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_MOV_CONT_MOV_MODINC] DEFAULT ('')
go
