USE [SKSS]
GO
/****** Object:  StoredProcedure [dbo].[p_Inspection_generateSchemaQuery]    Script Date: 9/5/2017 8:01:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_Inspection_generateSchemaQuery]
	@storefilefolder [varchar](1024) = 'C:\Development\ASWRaw\FileIn\',
	@db [varchar](128) = 'skios', 
	@isexception bit=1, 
	@exceptiontab varchar(128)='skios.sk_ios_image_share_event' 
WITH EXECUTE AS CALLER
AS
/*
	Date		: Aug 2017
	author		: royma
	Notes		: 
				This is manual process for now at dev environment
				copy and paste it to query 
				the following dbs are monitored:
					skios_beta
					skandroid_emoji
					skios_emoji_beta
					skandroid
					dossier_test
					skios
					aggregates
					skandroid_beta
*/   
declare @last varchar(20),			@hugequery varchar(max)='' ,			@file varchar(1024)='' , 
		@n int=1
select @last=max(addedon) from PRTable  (nolock) where db=@db 
if charindex('.', @exceptiontab, 0)>0
	select @exceptiontab=substring(@exceptiontab, charindex('.', @exceptiontab, 0)+1, 128)
	 
select @file='schema'+@last+@db+case when @isexception=1 then 'exception' else ''end+ '.txt' 
declare @tab varchar(128)='' 
while 1=1
begin
	select top 1 @tab=tab from PRTable  (nolock)  where
	((@isexception=1 and  tab=@exceptiontab) or @isexception=0) and 
	 tab>@tab and addedon=@last and istemp='False' 
		and  db=@db  order by tab 
	if @@ROWCOUNT=0
	break; 
	select @n=@n+1
	select @hugequery=  
	'
	WbExport -type=sqlinsert
         -file='''+@storefilefolder+@file+'''
         -append=true
         -lineEnding=crlf
         -header=true
         -useSchema=true
         -delimiter=''|'';
	SELECT *
	FROM '+@db+'.'+@tab+' limit 1;'
	print(@hugequery)
end    
  


