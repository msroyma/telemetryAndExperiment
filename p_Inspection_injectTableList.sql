USE [SKSS]
GO
/****** Object:  StoredProcedure [dbo].[p_Inspection_injectTableList]    Script Date: 9/5/2017 8:07:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_Inspection_injectTableList]
	@filefolder [varchar](1024) = 'C:\Development\ASWRaw\FileIn\',
	@file [varchar](1024) = 'dossier_test.txt',
	@db [varchar](128) = 'dossier_test',
	@moveto [varchar](1024) = 'C:\Development\ASWRaw\FileStay\'
WITH EXECUTE AS CALLER
AS
/*	
	Date		: Aug 2017
	author		: royma
	Notes		: 
					make sure line ending change to CRLF
*/ 
--1: beekeeper show tables and save data into file  
set nocount on 
declare @archieve varchar(1024),		@timestmp varchar(128)
select @timestmp=datename(year, GETUTCDATE())+case when datepart(month, GETUTCDATE())>9 then '' else '0' end 
				+convert(varchar(20), datepart(month, GETUTCDATE()))+
				case when datepart(day, GETUTCDATE())>9 then '' else '0' end 
				+convert(varchar(20), datepart(day, GETUTCDATE()))+
				case when datepart(hour, GETUTCDATE())>9 then '' else '0' end 
				+convert(varchar(20), datepart(hour, GETUTCDATE()))
select @archieve= left(@file, charindex('.', @file, 0)-1)+@timestmp+substring(@file, charindex('.', @file, 0), 128)
  
exec('truncate table PRTablesStaging; bulk insert PRTablesStaging from '''+@filefolder+@file+''' with (fieldterminator=''\t'')')
 
exec('master..xp_cmdshell ''move '+@filefolder+@file+'  '+@moveto+@archieve+'''')

if exists(select 1 from PRTablesStaging(nolock) )
begin
	delete from PRTable  where addedon=@timestmp and db=@db 
	insert into PRTable (tab, istemp, db,  addedon)
	select tab, istemp,@db, @timestmp from PRTablesStaging (nolock) 
end 
