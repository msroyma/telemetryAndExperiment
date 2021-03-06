USE [SKSS]
GO
/****** Object:  StoredProcedure [dbo].[p_Inspection_injectSchemaQuery]    Script Date: 9/5/2017 8:06:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_Inspection_injectSchemaQuery]
	@storefilefolder [varchar](1024) = 'C:\Development\ASWRaw\FileIn\',
	@file [varchar](128) = 'schema2017081816skandroid_beta.txt'
WITH EXECUTE AS CALLER
AS 
/*	
	Date		: Aug 2017
	author		: royma
	Notes		: 
					This compares schement change: new/delete/change 
					run p_Prerequisite_generateSchemaQuery_exception only when there is exception. from line 73: print(@tab). 
					in which case, @tab will be printed. and run it separately to get the sample data and schema
					 
*/   
set nocount on 

declare @archfolder varchar(1024)='C:\Development\ASWRaw\FileStay\'
exec('truncate table PRSchemaStaging '+
'bulk insert PRSchemaStaging from '''+@storefilefolder+@file+''' with ( fieldterminator=''\n'')')

update PRSchemaStaging set line =replace(replace(replace(line, char(10), ''), char(13), ''), char(9), '')

declare @schemaon varchar(50) 
declare @line varchar(max)
select @line=line from PRSchemaStaging 
select @schemaon=right(left(@file, 16), 10) 
 
declare @insert int=-6,				@values int=0,						@commit int=0,			@insertstmt varchar(4000), 
		@valuestmt varchar(4000),	@leftparent int,					@rightparent int,		@tab varchar(128), 
		@vleftparent int,			@vrightparent int,					@tabs int=0

----- to avoid scrumbled data, use two tab variables first 
declare @t_insert table(id int, val varchar(256))
declare @t_val table (id int, val varchar(256))
 
While @insert!=0
begin
	select @insert=charindex('INSERT INTO', @line, @insert+5)
	if @insert =0
	break; 
	select @tabs=@tabs+1

	select @values=charindex('VALUES(', @line, @insert)
	select @commit=charindex('COMMIT;', @line, @values)
	 
	select @insertstmt=SUBSTRING(@line, @insert, @values-@insert)
	select @valuestmt=SUBSTRING(@line, @values, @commit-@values) 

	select @leftparent=charindex('(', @insertstmt, 0) , @rightparent=charindex(')', @insertstmt, 0)  
	select @vleftparent=charindex('(', @valuestmt, 0) , @vrightparent=charindex(')', @valuestmt, 0)  
	select @tab=ltrim(rtrim(substring(@insertstmt, len('INSERT INTO')+1,  @leftparent-1-len('INSERT INTO') )))  
	 
	if exists(select 1 from PRschema where tab=@tab and addedon=@schemaon )
	delete from  PRschema where tab=@tab and addedon=@schemaon
	
	delete from @t_insert
	delete from @t_val 
	begin try
		insert into @t_insert(id, val)
		select idd, idstring from  dbo.[fnSplitStringToString](substring(@insertstmt, @leftparent+1, @rightparent-@leftparent-1), ',')
	end try  
	begin catch
		-- skip
	end catch 
	
	begin try
		insert into @t_val(id, val)
		select idd, idstring from  dbo.[fnSplitStringToString](substring(@valuestmt, @vleftparent+1, @vrightparent-@vleftparent-1), ',')
	end try
	begin catch
		insert into PRSchemaException(db, tab, addedon, reason)
		select left(@tab, charindex('.', @tab, 1)-1),  substring(@tab, charindex('.', @tab, 1)+1, 128)
		, @schemaon, left(error_Message(), 1024)
		print(@tab)
	end catch 

	if exists (select 1 from @t_insert)
	begin
		insert into PRschema (seq, db, tab, col, samplevalue, addedon) 
		select aa.id, left(@tab, charindex('.', @tab, 1)-1),  substring(@tab, charindex('.', @tab, 1)+1, 
		128), aa.val, bb.val, @schemaon 
		from @t_insert aa left join @t_val bb on aa.id=bb.id
	end 
	else
	begin
		print(@tab) 
	end    
	if @vrightparent-@vleftparent-1>0 and @rightparent-@leftparent-1>0
	begin
		insert into PRschema (seq, tab, col, samplevalue, addedon) 
		select aa.idd, @tab, aa.idstring, bb.idstring, @schemaon 
		from dbo.[fnSplitStringToString](substring(@insertstmt, @leftparent+1, @rightparent-@leftparent-1), ',') aa 
		join dbo.[fnSplitStringToString](substring(@valuestmt, @vleftparent+1, @vrightparent-@vleftparent-1), ',') bb
		on aa.idd=bb.idd  
	end 
	else 
	begin
		select @tab, @insertstmt, @valuestmt, @commit com, @values val
	end 
end  
print(@tabs)
exec('master..xp_cmdshell ''move ' +@storefilefolder+@file+'  ' +@archfolder+'''')
/*
use skexperiment;
go
declare @db varchar(128)='skios_emoji_beta'		, @post varchar(32)=''		,  @monster varchar(max)=''   
select  @monster=case when  @monster='' then '' else @monster+' union all ' end 
+ 'select top 1  '''+substring(object_name(object_id), charindex('__', object_name(object_id), 6)+2, 128)
+''' ev, '+convert(varchar(20), column_id)+' seq,'''+
substring(object_name(object_id), 6, charindex('__', object_name(object_id), 6)-6) 
+''' db,'''+name+''' col, ['
+name+'] val, ''2017072921'' addedon  from skexperiment.dbo.'
+ object_name(object_id) +' (nolock)   '   from sys.columns (nolock) 
where object_name(object_id) like 'tab[_][_]'+@db+'[_][_]%'+@post
and name not in ('Bia', 'BIA2') and name not like 'pool%' 

select @monster='insert into skss.dbo.PRschema(tab,seq, db, col, samplevalue, addedon) '+
' select  ev, seq, db, col, val, addedon from ('+@monster+' ) as mon' 
 
exec(@monster) 


---- table list
insert into skss.dbo.prtable(tab, istemp, addedon, db) 
select substring(name,charindex('__', name, 6) +2, 128), 'false', 
'2017072921',
substring(name, 6, charindex('__', name, 6)-6)   from sys.tables where name like 'tab[_][_]%' 
and substring(name, 6, charindex('__', name, 6)-6)  in ('aggregates'
,'skandroid'
,'skandroid_beta'
,'skandroid_emoji'
,'skios'
,'skios_beta'
,'skios_emoji_beta') and not exists(select 1 from  skss.dbo.prtable
bb where bb.addedon='2017072921' and  bb.tab=substring(name,charindex('__', name, 6) +2, 128) and bb.db=substring(name, 6, charindex('__', name, 6)-6))
 


 */   