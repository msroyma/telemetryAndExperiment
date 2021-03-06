USE [SKSS]
GO
/****** Object:  StoredProcedure [dbo].[p_Unattending_fileinjection_rawdata]    Script Date: 9/5/2017 8:48:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_Unattending_fileinjection_rawdata]
@uniquecode varchar(20)='LGCY102'   
WITH EXECUTE AS CALLER
AS 
/* 
	Date			: Sep 2017
	author			: royma
	Notes			: 
*/
set nocount on  
declare --@uniquecode varchar(20)='LGCY102',								
		@fetchfrom varchar(128)='\\rmz840\aswraw\FileIn\'  ,	
		@sql varchar(max)='' ,											@thefile varchar(1024)='', 
		@archieveto varchar(128)='\\rmz840\aswraw\FileStay\',			@sampletab varchar(128),
		@datafile varchar(1024)='',										@schemaline varchar(8000), 			
		@datasql varchar(max)='',										@installidcol varchar(50),			 
		@middlern int,													@db varchar(128),						
		@tab varchar(128),												@localtab varchar(128),					
		@isexists bit,													@ischopped bit,						
		@idd int =0,													@columns varchar(2048),					
		@schemas varchar(2048),											@issuccess bit=0, 
		@specificfile bit=0,											@specific varchar(128)='' 

declare @tfile table (idd int identity,	
		thefile varchar(1024),											installidcol varchar(128),  
		db varchar(128), 												tab varchar(128),				
		localtab varchar(128),											isexists bit default 0, 
		ischopped bit default 0,										injected bit default 0,		
		hasFileError bit default 0 ) 
		 
if @specificfile=1
begin 
	insert into @tfile(thefile)
	exec ('master..xp_cmdshell ''dir '+@fetchfrom +@specific+'*.* /b''') 
end
else 
begin 
	insert into @tfile(thefile)
	exec ('master..xp_cmdshell ''dir '+@fetchfrom +@uniquecode+'*.* /b''') 
end
 
delete from @tfile where thefile is null or ( thefile not like '%.csv' and thefile not like '%.txt' )  
 
-------------------------------------------------------- 1. stemp LGCY102_InstallIdList.txt  ----------------------------
if exists(select 1 from @tfile where thefile like @uniquecode+'_InstallIdList.txt')
begin
	select @sampletab=@uniquecode+'_InstallIdList'

	if not exists(select 1 from sys.tables (nolock) where name=@sampletab)
	begin
		select @sql='create table '+@sampletab+'(metaday date,inn int, app_appversionmajor varchar(20),metadata_installid varchar(128),
		experiment varchar(128),expgroup varchar(50),metadata_appversion varchar(50),manufacturer
		nvarchar(128), model	nvarchar(128), os_version	varchar(50),screen_width
		varchar(50),	screen_height varchar(50),	locale nvarchar(50), 	country_name nvarchar(128), 
		[oem]	nvarchar(128),  b2b	varchar(20), sk_tenure_group varchar(128)); create clustered index c_i_'
		+@sampletab+' on '+@sampletab+'(metadata_installid) with (data_compression=page)'
		exec(@sql) 
	end 
	select top 1 @thefile=thefile from @tfile where thefile like @uniquecode+'_InstallIdList.txt' order by thefile
	 
	truncate table ABSampleInstallIdStaging
	select @sql='bulk insert  ABSampleInstallIdStaging from '''+@fetchfrom+@thefile+''' with (fieldterminator=''\t'')' 
	exec(@sql)
	delete from ABSampleInstallIdStaging where inn='inn'
	select @sql='truncate table '+@sampletab
	exec(@sql)

	select @sql='insert into '+@sampletab+'(metaday,inn,app_appversionmajor,metadata_installid,experiment,expgroup,metadata_appversion,'
	+' manufacturer,model,os_version,screen_width,screen_height,locale,country_name,oem,b2b,sk_tenure_group) '
	+' select  metaday,inn,app_appversionmajor,metadata_installid,experiment,expgroup,metadata_appversion,manufacturer,model,os_version,'
	+' screen_width,screen_height,locale,country_name,oem,b2b,sk_tenure_group'+
	'  from ABSampleInstallIdStaging (nolock) where inn!=''inn'''
	exec(@sql)     
	select @sql='master..xp_cmdshell ''move '+@fetchfrom+@thefile+' '+@archieveto+''''
	exec(@sql)
 end   
if exists(select 1 from sys.tables where name='__mm')  exec('drop table __mm') 
create table __mm(line varchar(max)) 
 
update tt set 
		tt.localtab=substring(outputfile,
					charindex('LGCY', outputfile, 0), charindex('.', outputfile, 0)
						-charindex('LGCY', outputfile, 0))
		, tt.db=bb.db
		, tt.tab=bb.tab
		, ischopped= case when bb.outputfile like '%[_][_][0-9][0-9].txt'  then 1 else 0 end 
		, injected=case when bb.injected is null then 0 else 1 end 
		, hasFileError=bb.hasFileError
		, tt.installidcol=tb.installidcol
from @tfile tt join ABQueryLog (nolock) bb on bb.outputfile like '%'+ tt.thefile and bb.uniquecode=@uniquecode  
	join abdatatable tb on bb.db=tb.db and bb.tab=tb.tab

update @tfile set localtab=case when localtab like '%[_][_][0-9][0-9]' then left(localtab, len(localtab)-4) else localtab end 	 
 
update tt set tt.isexists=1 from @tfile tt join sys.tables bb (nolock) 
on tt.localtab=bb.name  
 
--- profile tab with install_id  
update @tfile set installidcol='install_id' where thefile like '%[_]profile.txt' 
 
select @datafile=''
while 1=1 
begin
	select top 1 @idd=idd from @tfile where  hasFileError=0 and idd>@idd and (injected =0 or (injected=1  and isexists=0))  
	order by idd 
	if @@ROWCOUNT=0
	break;   
	select @datafile=thefile
			, @isexists=isexists
			, @ischopped=ischopped
			, @db=db
			, @tab=tab
			, @localtab=localtab
			, @installidcol=installidcol from @tfile where idd=@idd 
	--select @datafile, @isexists, @db, @localtab return
	truncate table __mm 
	exec(' bulk insert __mm from '''+@fetchfrom+@datafile+''' with(lastrow=100)')
	if not exists(select 1 from __mm where line like '%'+@installidcol+'%')
	begin
		truncate table __mm 
		exec(' bulk insert __mm from '''+@fetchfrom+@datafile+'''')
	end   
	   
	select @schemaline=line from __mm where line like '%'+@installidcol+'%' 
	select @columns='['+replace(@schemaline, char(9), '],[')+']' 
	select @schemas='['+replace(@schemaline, char(9), '] varchar(2048),[')+'] varchar(2048)'
	 
	if exists(select 1 from sys.tables where name ='ABDataStaging' )
		exec('drop table ABDataStaging')  
	select @datasql='create table ABDataStaging('+@schemas+')' 	
	exec(@datasql)  
	select @issuccess=0 
	begin try
		select @datasql='bulk insert ABDataStaging from '''+@fetchfrom+@datafile+''' with (fieldterminator=''\t'')' 
		exec(@datasql)
		select @issuccess=1

	end try
	begin catch  
		select ERROR_MESSAGE()
		update ABQueryLog set hasFileError =1 where Outputfile=@fetchfrom+@datafile 
	end catch   
	--- [p_Unattending_fileinjection_rawdata] select * from ABDataStaging update ABQueryLog set  hasFileError=0 where hasFileError=1 
	if @issuccess=1
	begin 
		select @datasql='create table '+@localtab+'('+@schemas+');
		create clustered index c_i_'+@localtab+' on '+@localtab+'('+@installidcol+') with (data_compression=page)'
	  
		if @isexists=0
		begin 
			exec(@datasql)
		end 
		update @tfile set isexists=1 where localtab=@localtab

		select @datasql='insert into '+@localtab+'('+@columns+')'+'select '+@columns+' from ABDataStaging (nolock) where '+
			@installidcol+' !='''+@installidcol+''''
		exec(@datasql)
		if  exists(select 1 from ABDataStaging (nolock))
			update ABQueryLog set injected=GETUTCDATE() where Outputfile=@fetchfrom+@datafile and uniquecode=@uniquecode 
		select @datasql='master..xp_cmdshell ''move '+@fetchfrom+@datafile+' '+@archieveto+''''
		exec(@datasql)  
	end  
end       

