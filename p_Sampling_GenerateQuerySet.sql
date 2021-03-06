USE [SKSS]
GO
/****** Object:  StoredProcedure [dbo].[p_Sampling_GenerateQuerySet]    Script Date: 9/5/2017 8:44:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_Sampling_GenerateQuerySet]  --ABQueryLog
@uniquecode varchar(12)='LGCY112'  
, @ismanualoutput int=1  --- 1: print profile query, 2: print chop=0, 4: print chop>0 
WITH EXECUTE AS CALLER
AS
--/*
--	core proc. run when registering a nex exeriment
--	logic: 
--		1.defines a unique experiment: For BIBO: a.experiment name, b.flight_id, c.flight_start_time
--									   For Legacy: not yet defined. 	
--		2.
--		3.
--		4. the profile table has flight start/end, install_id's start/end timestamp 
--		Notes		:  
--*/ 

--declare @uniquecode varchar(12)='LGCY102'  
--, @ismanualoutput bit=1 
set nocount on     
  
 
------------------------------------------------ get the maximum code. maximum 3 characters. starts from ZA ------------------------------------------------
declare @max varchar(3),			@numberpairs int,		
		@start int =0,				@len int,						@regnerateFull bit=1 
				  
------------------------------------------------ start query generation sections ------------------------------------------------
------------------------------------------------ start query generation sections ------------------------------------------------
declare @outputpath varchar(1024)='\\rmz840\aswraw\FileIn\',					@filename varchar(1024),	 
		@samplequery varchar(8000),												@outputquery varchar(8000), 
		@awstmptableFull varchar(128)='' ,										@fullquery varchar(max) ='' ,	 
		@printout varchar(max),		 
		@daysbeforeflightstarts int,											@daysafterflightends int,												
		@fromutc date,															@toutc date, 
		@expname varchar(128),													@gp varchar(64), 
		@appver varchar(64),													@appvermajor varchar(32), 
		@quota int,																@oversampling float, 
		@randomer varchar(20),													@athirdrandomer varchar(20) , 
		@fromtimestamp varchar(50),												@totimestamp varchar(50), 
		@dayleft int,															@dayright int, 
		@startdate date,														@enddate date, 
		@movedate date,															@chop int=0 
		
select @daysbeforeflightstarts=convert(int, val) from ABConfig where config='Days before Flight Start' 
select @daysafterflightends=convert(int, val) from ABConfig where config='Days after Flight ends' 
select @oversampling=convert(float, val) from ABConfig where config='Extra Sample Rate' 
select @dayright=convert(int, val) from ABConfig where config='Days after Flight ends' 
select @dayleft=convert(int, val) from ABConfig where config='Days before Flight Start' 
  
select @fromutc=fromUtc, @toutc=toUtc from ABExperimentQuota where uniquecode=@uniquecode --- the same for every row. 
--select @daysafterflightends, @daysbeforeflightstarts, @fromutc, @toutc 
--select  * from  ABExperimentQuota where uniquecode=@uniquecode

------------------------------------------------------------ sample install ids and output profile --------------------------------- 
------------------------------------------------------------ sample install ids and output profile ---------------------------------

declare @uidd int =0
select @printout='' 
while 1=1 
begin
	select top 1 @uidd=idd from  ABExperimentQuota where uniquecode=@uniquecode and idd>@uidd order by idd asc 
	if @@ROWCOUNT=0
	break ; 
	select @expname=inferredexpname
		, @gp=gp
		, @appver=appver
		, @appvermajor=appvermajor 
		, @quota=quota 
		, @randomer=convert(int, n*@oversampling/quota) 
		, @athirdrandomer=case when convert(int, n*@oversampling/quota)/3<=1 then 1
						else convert(int, n*@oversampling/quota)/3 end 
		from   ABExperimentQuota (nolock)
	where idd=@uidd 
	
	select @awstmptableFull= @uniquecode+'_InstallIdList'

	-- select @expname, @gp, @appver, @appvermajor, @quota, @randomer, @athirdrandomer thirder	
	select @printout=case when @printout='' then ''
	else @printout+' union all ' end+
	'select * from (
select metadata_timestamp_utcTimestamp, date(from_unixtime(metadata_timestamp_utcTimestamp/1000)) as metaDay, int(rand()*'+@randomer+') as inn, '''+@appvermajor+''' as app_appVersionMajor,  metadata_installid, experiment, group, metadata_appVersion  from skandroid.core_experiment_group_joined_event 
where  date(from_unixtime(metadata_timestamp_utcTimestamp/1000))>='''+convert(varchar(20), @fromutc)+''' and 
date(from_unixtime(metadata_timestamp_utcTimestamp/1000)) <='''+convert(varchar(20), @toutc)+''' 
and experiment='''+@expname+''' and group='''+@gp+''' and metadata_appVersion='''+@appver+''') as B1 where inn='+@athirdrandomer 
 
end 
 
select @printout='------------------------------------------------  sampling install ids: '+@awstmptableFull +'------------------------------------------------'+
'
DROP TABLE if exists abitemp.'+@awstmptableFull+';
CREATE TABLE  abitemp.'+@awstmptableFull+' 
AS '+@printout+';'
  
if @ismanualoutput&1=1
print( @printout )
select @samplequery=@printout


------------------------------------------------------------ output profile to local drive  --------------------------------- 
------------------------------------------------------------ output profile to local drive  --------------------------------- 
select @filename=@outputpath+@awstmptableFull+'.txt' 
select @printout='WbExport -type=text
         -file='''+@filename+'''
         -lineEnding=''crlf''
         -delimiter=''\t''; '
		+'select aa.*, bb.manufacturer, bb.model,bb.os_version, bb.screen_width, bb.screen_height, bb.locale, bb.country_name, 
 bb.oem, bb.b2b, bb.sk_tenure_group from abitemp.'+@awstmptableFull+' as aa join aggregates.install_profile as bb ' 
		+' on aa.metadata_installid=bb.install_id;' 

if @ismanualoutput&1=1
print(@printout) 
select @outputquery=@printout;

if exists(select 1 from ABsamplelog where uniquecode=@uniquecode)
update ABSampleLog set exptype=left(@uniquecode, 4)
, awssampletab='abitemp.'+@awstmptableFull
, awssamplequery=@samplequery
, outputfilename=@outputpath+@awstmptableFull+'.txt'
, outputquery=@outputquery
, querygenerated=GETUTCDATE()
else 
insert into ABsamplelog (UniqueCode, exptype, awssampletab, awssamplequery, outputfilename, outputquery, querygenerated)
select @uniquecode, left(@uniquecode, 4), 'abitemp.'+@awstmptableFull, @samplequery, @outputpath+@awstmptableFull+'.txt', 
@outputquery, getutcdate()

------------------------------------------------------------ output data file  ---------------------------------   
------------------------------------------------------------ output data file  ---------------------------------   
select @fromtimestamp=convert(bigint, datediff(second, 'jan 1 1970', dateadd(day, -@dayleft, convert(datetime, @fromutc)))*convert(bigint, 1000))
select @totimestamp=convert(bigint, datediff(second, 'jan 1 1970', dateadd(day, @dayright, convert(datetime, @toutc)))*convert(bigint, 1000))

declare @db varchar(128), @tab varchar(128), @installcol varchar(128), @idd int =0, @chopby int
select @fullquery='' 
while 1=1
begin
	select top 1 @idd=idd from abdatatable where idd>@idd order by idd 
	if @@rowcount =0 
	break;

	select @db=db, @tab=tab, @installcol=installidcol, @chopby=chopby from abdatatable where idd=@idd 
	 
	select @printout='' 
	if @chopby=0
	begin
		select @filename=@outputpath+@uniquecode+'__'+@db+'__'+@tab+'.txt'
		select @printout='WbExport -type=text
			 -file='''+@filename+'''
			 -lineEnding=''crlf''
			 -delimiter=''\t''; '
			+'select bb.* from abitemp.'+@awstmptableFull+' as aa join '+@db+'.'+@tab+' as bb ' 
			+' on aa.metadata_installid=bb.'+@installcol 
			---+'  where bb.metadata_timestamp_utcTimestamp>'+@fromtimestamp+' and bb.metadata_timestamp_utcTimestamp<='+@totimestamp+';' 
			+'  where bb.date_received>'+@fromtimestamp+' and bb.date_received<='+@totimestamp+';' 
		if @ismanualoutput&2=2
		print(@printout) 
		select @fullquery=@fullquery
		+
'
'
+@printout
		if exists(select 1 from ABquerylog (nolock) where uniquecode=@uniquecode and db=@db and tab=@tab and outputfile=@filename )
		update   ABquerylog set fetchquery=@printout, outputfile=@filename where uniquecode=@uniquecode and db=@db and tab=@tab
			and outputfile=@filename
		else 
		insert into ABquerylog(uniquecode,db,tab,fetchquery,outputfile)
		select @uniquecode, @db, @tab, @printout, @filename  
	end
	else 
	begin
		select @chop=10 
		select @startdate= dateadd(day, -@dayleft, convert(datetime, @fromutc))
		select @enddate= dateadd(day, @dayright, convert(datetime, @toutc))
		select @fullquery='' 
		while @startdate<@enddate
		begin
			select @chop=@chop+1
			select @filename=@outputpath+@uniquecode+'__'+@db+'__'+@tab+'__'+convert(varchar(10), @chop)+'.txt'
			select @movedate=dateadd(day, @chopby, @startdate)
			if @movedate>@enddate
				select @movedate=@enddate

			select @printout='WbExport -type=text
			 -file='''+@filename+'''
			 -lineEnding=''crlf''
			 -delimiter=''\t''; '
			+'select bb.* from abitemp.'+@awstmptableFull+' as aa join '+@db+'.'+@tab+' as bb ' 
			+' on aa.metadata_installid=bb.'+@installcol 
			---+'  where bb.metadata_timestamp_utcTimestamp>'+@fromtimestamp+' and bb.metadata_timestamp_utcTimestamp<='+@totimestamp+';' 
			+'  where bb.date_received>='''+convert(varchar(20), @startdate)+''' and bb.date_received<='''
			+convert(varchar(20), @movedate)+''';' 

			if @ismanualoutput&4=4
			print(@printout) 
			select @fullquery=@fullquery
		+
'
'
+@printout
			select @startdate=dateadd(day, 1, @movedate)

			if exists(select 1 from ABquerylog (nolock) where uniquecode=@uniquecode and db=@db and tab=@tab and outputfile=@filename )
			update   ABquerylog set fetchquery=@printout, outputfile=@filename where uniquecode=@uniquecode and db=@db and tab=@tab
				and outputfile=@filename
			else 
			insert into ABquerylog(uniquecode,db,tab,fetchquery,outputfile, ischopped)
			select @uniquecode, @db, @tab, @printout, @filename,1 
		end 
	end 
	
end    
   
update ABSampleLog set dataQuery=@fullquery where isnull(uniquecode, '')=@uniquecode 
   
------------------------------------------------------------- registering tables ----------------------------------------------------
delete from ABDatalog where UniqueCode=@uniquecode 
insert into ABDatalog (UniqueCode,  db,tab,localTab)
select distinct  @uniquecode, db,tab, uniqueCode+'__'+db+'__'+tab  
from abquerylog (nolock) where UniqueCode =@uniquecode 