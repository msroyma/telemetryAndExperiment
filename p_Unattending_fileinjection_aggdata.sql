USE [SKSS]
GO
/****** Object:  StoredProcedure [dbo].[p_Unattending_fileinjection_aggdata]    Script Date: 9/5/2017 8:48:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_Unattending_fileinjection_aggdata]
WITH EXECUTE AS CALLER
AS 
/* 
	Date			: Sep 2017
	author			: royma
	Notes			:  
*/
set nocount on  
declare @NOTERRORN int=1000 --- this is an arbitury number that defines min experiment size. need to revisit
select @NOTERRORN=convert(int, val)  from abconfig where config='Minimum Experiment Size'
 
declare @fetchfrom varchar(128)='\\rmz840\aswraw\FileIn\'  ,	@sql varchar(max)='' ,		@thefile varchar(1024)='', 
		@archieveto varchar(128)='\\rmz840\aswraw\FileStay\'

if object_id('tempdb..#thedatafile') is not null 
drop table #thedatafile
create table #thedatafile(idd int identity, thefile varchar(1024), stem varchar(128))

select @sql='insert into #thedatafile (thefile) exec master..xp_cmdshell ''dir '+@fetchfrom +'*.* /b'''
exec(@sql)
 
delete from #thedatafile where thefile is null or ( thefile not like '%.csv' and thefile not like '%.txt' )
 select * from #thedatafile 
-------------------------------------------------------- 1. stemp aggregates__experiments.csv--------------------------------------------------------
-------------------------------------------------------- 1. stemp aggregates__experiments.csv--------------------------------------------------------
if exists(select 1 from #thedatafile where thefile like 'aggregates__experiments%')
begin
	select top 1 @thefile=thefile from #thedatafile where thefile like 'aggregates__experiments%' order by thefile 
	truncate table ABExperimentStaging

	select @sql='bulk insert  ABExperimentStaging from '''+@fetchfrom+@thefile+''' with (fieldterminator=''\t'')'
	exec(@sql)

	if @@ROWCOUNT>2 -- at least two rows, one row is headers. 
	begin 
		-- update it
		update ab set ab.flight_start_time=ss.flight_start_time
					, ab.flight_end_time=ss.flight_end_time
					, ab.completed=ss.completed
					, ab.start_timestamp=ss.start_timestamp
					, ab.end_timestamp=ss.end_timestamp
					, ab.disN=ss.disN
					, ab.N=ss.N
					, ab.lastupdated=GETUTCDATE()
		from ABExperiment ab join ABExperimentStaging ss 
		on  ab.experiment=ss.experiment 
			and isnull(ab.flight_id,'')=isnull(ss.flight_id, '')
			and isnull(ab.api_key,'')=isnull(ss.api_key, '')
			and isnull(ab.experiment_group, '')=isnull(ss.experiment_group, '')
			and isnull(ab.[type], '')=isnull(ss.[type], '')
			and isnull(ab.category, '')=isnull(ss.category, '')
			and isnull(ab.variant, '')=isnull(ss.variant, '')
			and isnull(ab.sub_category, '')=isnull(ss.sub_category, '') 
			and isnull(ab.app_version, '')=isnull(ss.app_version, '')

		insert into ABExperiment (api_key
			,app_version
			,type
			,experiment
			,experiment_group
			,flight_id
			,category
			,sub_category
			,variant
			,blob_owner
			,flight_start_time
			,flight_end_time
			,completed 
			, reformulated_experiment_group
			, start_timestamp
			, end_timestamp
			, disN 
			, N) 
		select api_key
			,app_version
			,type
			,experiment
			,experiment_group
			,flight_id
			,category
			,sub_category
			,variant
			,blob_owner
			,flight_start_time
			,flight_end_time
			,completed 
			,case when charindex(':', experiment_group,0)>0 then experiment_group
					else case when len(experiment_group)=1 or experiment_group='CONTROL' then experiment+':'+ experiment_group
					when 	experiment_group like '%Control' then experiment+':CONTROL' 
					else experiment+':' + right(experiment_group, 1) end end
			, start_timestamp
			, end_timestamp
			, disN 
			, N
			from ABExperimentStaging ss where N!='N' 
			and not exists(select 1 from ABExperiment ab where 
			ab.experiment=ss.experiment 
			and isnull(ab.flight_id,'')=isnull(ss.flight_id, '')
			and isnull(ab.api_key,'')=isnull(ss.api_key, '')
			and isnull(ab.experiment_group, '')=isnull(ss.experiment_group, '')
			and isnull(ab.[type], '')=isnull(ss.[type], '')
			and isnull(ab.category, '')=isnull(ss.category, '')
			and isnull(ab.sub_category, '')=isnull(ss.sub_category, '') 
			and isnull(ab.app_version, '')=isnull(ss.app_version, '')  
			and isnull(ab.variant, '')=isnull(ss.variant, '')) 

		select @sql='master..xp_cmdshell ''move '+@fetchfrom+'aggregates__experiments* '+@archieveto+''''
		exec(@sql) 
	end   

	declare @max varchar(16)

	select @max=isnull(max(uniquecode), '') from ABExperiment 
	if @max ='' 
	select @max='Z000'

	;with rawlistthelist(x, f, s) as (
	select distinct experiment, flight_id, flight_start_time from abexperiment where uniquecode is null and N>@noterrorN)
	,thelist(x,f,s, newmax) as (select x,f, s,row_number() over(order by x)+convert(int, right(@max, 3))
	from rawlistthelist )  
	update ee  set ee.uniquecode ='Z'+case when newmax>99 then convert(varchar(20), newmax)
					when newmax>9 then '0' +convert(varchar(20), newmax)
					else '00'+convert(varchar(20), newmax) end 
	from ABExperiment ee join thelist bb on ee.experiment=bb.x
	and isnull(ee.flight_id, '')=isnull(bb.f, '')
	and isnull(ee.flight_start_time, 'Jan 1 1900')=isnull(s, 'Jan 1 1900') 
	 
 end 
  
-------------------------------------------------------- 2. for those without specific dates--------------------------------------------------------
-------------------------------------------------------- 2. for those without specific dates--------------------------------------------------------
if exists(select 1 from #thedatafile where thefile like 'aggregates__experimentvolume%')
begin
	select top 1 @thefile=thefile from #thedatafile where thefile like 'aggregates__experimentvolume%' order by thefile 
	truncate table ABExperimentStaging

	select @sql='bulk insert  ABExperimentStaging from '''+@fetchfrom+@thefile+''' with (fieldterminator=''\t'')'
	exec(@sql)
	 
	 
	if @@ROWCOUNT>2 -- at least two rows, one row is headers. 
	begin 
		-- update it
		update ab set ab.flight_start_time=ss.flight_start_time
					, ab.flight_end_time=ss.flight_end_time
					, ab.completed=ss.completed 
					, ab.end_timestamp=ss.end_timestamp
					, ab.disN=ss.disN
					, ab.N=ss.N
					, ab.lastupdated=GETUTCDATE()
		from ABExperimentLegacyVolume ab join ABExperimentStaging ss 
		on  ab.experiment=ss.experiment 
			and isnull(ab.flight_id,'')=isnull(ss.flight_id, '')
			and isnull(ab.api_key,'')=isnull(ss.api_key, '')
			and isnull(ab.experiment_group, '')=isnull(ss.experiment_group, '')
			and isnull(ab.[type], '')=isnull(ss.[type], '')
			and isnull(ab.category, '')=isnull(ss.category, '')
			and isnull(ab.variant, '')=isnull(ss.variant, '')
			and isnull(ab.sub_category, '')=isnull(ss.sub_category, '')
			and ab.start_timestamp=ss.start_timestamp 
			and isnull(ab.app_version, '')=isnull(ss.app_version, '')
			   
		insert into ABExperimentLegacyVolume (api_key
			,app_version
			,type
			,experiment
			,experiment_group
			,flight_id
			,category
			,sub_category
			,variant
			,blob_owner
			,flight_start_time
			,flight_end_time
			,completed 
			, reformulated_experiment_group
			, start_timestamp
			, end_timestamp
			, disN 
			, N) 
		select api_key
			,app_version
			,type
			,experiment
			,experiment_group
			,flight_id
			,category
			,sub_category
			,variant
			,blob_owner
			,flight_start_time
			,flight_end_time
			,completed 
			,case when charindex(':', experiment_group,0)>0 then experiment_group
					else case when len(experiment_group)=1 or experiment_group='CONTROL' then experiment+':'+ experiment_group
					when 	experiment_group like '%Control' then experiment+':CONTROL' 
					else experiment+':' + right(experiment_group, 1) end end
			, start_timestamp
			, end_timestamp
			, disN 
			, N
			from ABExperimentStaging ss where N!='N' 
			and not exists(select 1 from ABExperimentLegacyVolume ab where 
			ab.experiment=ss.experiment 
			and isnull(ab.flight_id,'')=isnull(ss.flight_id, '')
			and isnull(ab.api_key,'')=isnull(ss.api_key, '')
			and isnull(ab.experiment_group, '')=isnull(ss.experiment_group, '')
			and isnull(ab.[type], '')=isnull(ss.[type], '')
			and ab.start_timestamp=ss.start_timestamp
			and isnull(ab.category, '')=isnull(ss.category, '')
			and isnull(ab.sub_category, '')=isnull(ss.sub_category, '') 
			and isnull(ab.app_version, '')=isnull(ss.app_version, '')  
			and isnull(ab.variant, '')=isnull(ss.variant, '')) 

		select @sql='master..xp_cmdshell ''move '+@fetchfrom+'aggregates__experimentvolume* '+@archieveto+''''
		exec(@sql) 
	end   
	 
 end 
  
-------------------------------------------------------- 3. for those with specific dates--------------------------------------------------------
-------------------------------------------------------- 3. for those with specific dates--------------------------------------------------------
if exists(select 1 from #thedatafile where thefile like 'aggregates__experimentbibo%')
begin
	select top 1 @thefile=thefile from #thedatafile where thefile like 'aggregates__experimentbibo%' order by thefile 
	truncate table ABExperimentStaging

	select @sql='bulk insert  ABExperimentStaging from '''+@fetchfrom+@thefile+''' with (fieldterminator=''\t'')'
	exec(@sql)

	if @@ROWCOUNT>2 -- at least two rows, one row is headers. 
	begin 
		-- update it
		update ab set ab.start_timestamp=ss.start_timestamp
					, ab.flight_end_time=ss.flight_end_time
					, ab.completed=ss.completed 
					, ab.end_timestamp=ss.end_timestamp
					, ab.disN=ss.disN
					, ab.N=ss.N
					, ab.lastupdated=GETUTCDATE()
		from ABExperimentBiboVolume ab join ABExperimentStaging ss 
		on  ab.experiment=ss.experiment 
			and isnull(ab.flight_id,'')=isnull(ss.flight_id, '')
			and isnull(ab.api_key,'')=isnull(ss.api_key, '')
			and isnull(ab.experiment_group, '')=isnull(ss.experiment_group, '')
			and isnull(ab.[type], '')=isnull(ss.[type], '')
			and isnull(ab.category, '')=isnull(ss.category, '')
			and isnull(ab.variant, '')=isnull(ss.variant, '')
			and isnull(ab.sub_category, '')=isnull(ss.sub_category, '') 
			and isnull(ab.app_version, '')=isnull(ss.app_version, '')
			and ab.flight_start_time=ss.flight_start_time
			  
		insert into ABExperimentBiboVolume (api_key
			,app_version
			,type
			,experiment
			,experiment_group
			,flight_id
			,category
			,sub_category
			,variant
			,blob_owner
			,flight_start_time
			,flight_end_time
			,completed 
			, reformulated_experiment_group
			, start_timestamp
			, end_timestamp
			, disN 
			, N) 
		select api_key
			,app_version
			,type
			,experiment
			,experiment_group
			,flight_id
			,category
			,sub_category
			,variant
			,blob_owner
			,flight_start_time
			,flight_end_time
			,completed 
			,case when charindex(':', experiment_group,0)>0 then experiment_group
					else case when len(experiment_group)=1 or experiment_group='CONTROL' then experiment+':'+ experiment_group
					when 	experiment_group like '%Control' then experiment+':CONTROL' 
					else experiment+':' + right(experiment_group, 1) end end
			, start_timestamp
			, end_timestamp
			, disN 
			, N
			from ABExperimentStaging ss where N!='N' 
			and not exists(select 1 from ABExperimentBiboVolume ab where 
			ab.experiment=ss.experiment 
			and isnull(ab.flight_id,'')=isnull(ss.flight_id, '')
			and isnull(ab.api_key,'')=isnull(ss.api_key, '')
			and ab.flight_start_time=ss.flight_start_time
			and isnull(ab.experiment_group, '')=isnull(ss.experiment_group, '')
			and isnull(ab.[type], '')=isnull(ss.[type], '')
			and isnull(ab.category, '')=isnull(ss.category, '')
			and isnull(ab.sub_category, '')=isnull(ss.sub_category, '') 
			and isnull(ab.app_version, '')=isnull(ss.app_version, '')  
			and isnull(ab.variant, '')=isnull(ss.variant, '')) 

		select @sql='master..xp_cmdshell ''move '+@fetchfrom+'aggregates__experimentbibo* '+@archieveto+''''
		exec(@sql) 
	end   
	 
 end 

 ---------------------------------------------- bibo with start_timestamp -------------------------------------------- 
-------------------------------------------------------- 4. for those with specific dates--------------------------------------------------------
-------------------------------------------------------- 4. for those with specific dates--------------------------------------------------------
if exists(select 1 from #thedatafile where thefile like 'aggregates__experimenttimedistr%')
begin
	select top 1 @thefile=thefile from #thedatafile where thefile like 'aggregates__experimenttimedistr%' order by thefile 
	truncate table ABExperimentStaging

	select @sql='bulk insert  ABExperimentStaging from '''+@fetchfrom+@thefile+''' with (fieldterminator=''\t'')'
	exec(@sql)

	if @@ROWCOUNT>2 -- at least two rows, one row is headers. 
	begin 
		-- update it
		update ab set ab.start_timestamp=ss.start_timestamp
					, ab.flight_end_time=ss.flight_end_time
					, ab.completed=ss.completed 
					, ab.end_timestamp=ss.end_timestamp
					, ab.disN=ss.disN
					, ab.N=ss.N
					, ab.lastupdated=GETUTCDATE()
		from ABExperimentBiboStartTimeStampVolume ab join ABExperimentStaging ss 
		on  ab.experiment=ss.experiment 
			and isnull(ab.flight_id,'')=isnull(ss.flight_id, '')
			and isnull(ab.api_key,'')=isnull(ss.api_key, '')
			and isnull(ab.experiment_group, '')=isnull(ss.experiment_group, '')
			and isnull(ab.[type], '')=isnull(ss.[type], '')
			and isnull(ab.category, '')=isnull(ss.category, '')
			and isnull(ab.variant, '')=isnull(ss.variant, '')
			and isnull(ab.sub_category, '')=isnull(ss.sub_category, '') 
			and isnull(ab.app_version, '')=isnull(ss.app_version, '')
			and ab.flight_start_time=ss.flight_start_time
			 		   
		insert into ABExperimentBiboStartTimeStampVolume (api_key
			,app_version
			,type
			,experiment
			,experiment_group
			,flight_id
			,category
			,sub_category
			,variant
			,blob_owner
			,flight_start_time
			,flight_end_time
			,completed 
			, reformulated_experiment_group
			, start_timestamp
			, end_timestamp
			, disN 
			, N) 
		select api_key
			,app_version
			,type
			,experiment
			,experiment_group
			,flight_id
			,category
			,sub_category
			,variant
			,blob_owner
			,flight_start_time
			,flight_end_time
			,completed 
			,case when charindex(':', experiment_group,0)>0 then experiment_group
					else case when len(experiment_group)=1 or experiment_group='CONTROL' then experiment+':'+ experiment_group
					when 	experiment_group like '%Control' then experiment+':CONTROL' 
					else experiment+':' + right(experiment_group, 1) end end
			, start_timestamp
			, end_timestamp
			, disN 
			, N
			from ABExperimentStaging ss where N!='N' 
			and not exists(select 1 from ABExperimentBiboStartTimeStampVolume ab where 
			ab.experiment=ss.experiment 
			and isnull(ab.flight_id,'')=isnull(ss.flight_id, '')
			and isnull(ab.api_key,'')=isnull(ss.api_key, '')
			and ab.flight_start_time=ss.flight_start_time
			and isnull(ab.experiment_group, '')=isnull(ss.experiment_group, '')
			and isnull(ab.[type], '')=isnull(ss.[type], '')
			and isnull(ab.category, '')=isnull(ss.category, '')
			and isnull(ab.sub_category, '')=isnull(ss.sub_category, '') 
			and isnull(ab.app_version, '')=isnull(ss.app_version, '')  
			and isnull(ab.variant, '')=isnull(ss.variant, '')) 

		select @sql='master..xp_cmdshell ''move '+@fetchfrom+'aggregates__experimenttimedistr* '+@archieveto+''''
		exec(@sql) 
	end   
	 
 end 

 
 ---------------------------------------------- bibo with start_timestamp -------------------------------------------- 
-------------------------------------------------------- 5. for experiment join group--------------------------------------------------------
--------------------------------------------------------  5. for experiment join group--------------------------------------------------------
if exists(select 1 from #thedatafile where thefile like 'core_experiment_group_joined_eventAgg%')
begin
	select top 1 @thefile=thefile from #thedatafile where thefile like 'core_experiment_group_joined_eventAgg%' order by thefile 
	truncate table ABJoinExpStaging
 
	select @sql='bulk insert  ABJoinExpStaging from '''+@fetchfrom+@thefile+''' with (fieldterminator=''\t'', maxerrors=200)'
	exec(@sql)
 
	if @@ROWCOUNT>2 -- at least two rows, one row is headers. 
	begin 
		-- update it
		update ab set ab.N=ss.N
					, ab.disN=ss.disN
					, ab.lastUpdated=GETUTCDATE()
		from ABJoinExp ab join ABJoinExpStaging ss 
		on  ab.experiment=ss.experiment  and ab.metadata_appVersion=ss.metadata_appVersion and ab.expgroup=ss.expgroup 
			 		   
		insert into ABJoinExp ( onUTC
			, experiment
			, expgroup 
			, metadata_appVersion 
			, disN 
			, N
			, lastupdated) 
		select  onUTC
			, experiment
			, expgroup 
			, metadata_appVersion 
			, disN 
			, N
			, GETUTCDATE()
			from ABJoinExpStaging ss where N!='N'  and len(experiment)<256 
			and experiment is not null 
			and not exists(select 1 from ABJoinExp ab where 
			 ab.experiment=ss.experiment  and ab.metadata_appVersion=ss.metadata_appVersion and ab.expgroup=ss.expgroup) 

		select @sql='master..xp_cmdshell ''move '+@fetchfrom+'core_experiment_group_joined_eventAgg* '+@archieveto+''''
		exec(@sql) 

		-- no matter changes, re-run quota sampling 
		exec dbo.p_Unattending_fileinjection_quota 'Legacy'
	end   
	 
 end 
  
  
-------------------------------------------------------- 6. for ABBiboModelEnableStaging -------------------------------------------------------
--------------------------------------------------------  6. for ABBiboModelEnableStaging ABBiboModelEnableStaging--------------------------------------------------------
if exists(select 1 from #thedatafile where thefile like 'sk_android_bibo_model_enabled_eventAgg%')
begin
	select top 1 @thefile=thefile from #thedatafile where thefile like 'sk_android_bibo_model_enabled_eventAgg%' order by thefile 
	truncate table ABBiboModelEnableStaging
	 
	select @sql='bulk insert  ABBiboModelEnableStaging from '''+@fetchfrom+@thefile+''' with (fieldterminator=''\t'', maxerrors=200)'
	exec(@sql)
  
	if @@ROWCOUNT>2 -- at least two rows, one row is headers. 
	begin 
		-- update it
		update ab set ab.N=ss.N
					, ab.disN=ss.disN
					, ab.lastUpdated=GETUTCDATE()
		from ABBiboModelEnable  ab join ABBiboModelEnableStaging ss 
		on  isnull(ab.flight_id, '')=isnull(ss.flight_id, '')  and ab.onUTC=ss.onUTC 
			and isnull(ab.flight_constraint, '')=isnull(ss.flight_constraint, '') 
			and isnull(ab.metadata_appversion, '')= isnull(ss.metadata_appversion, '')
			 	 
		insert into ABBiboModelEnable ( metadata_appversion
			, category
			, subcategory
			, flight_id
			,flight_constraint
			, onUTC
			, disN 
			, N
			, lastupdated) 
		select  metadata_appversion
			, category
			, subcategory
			, flight_id
			, left(flight_constraint, 128)
			, onUTC
			, disN 
			, N
			, GETUTCDATE()
			from ABBiboModelEnableStaging ss where N!='N'  and len(metadata_appversion)<256  
			and not exists(select 1 from ABBiboModelEnable  ab where 
			  isnull(ab.flight_id, '')=isnull(ss.flight_id, '')  and ab.onUTC=ss.onUTC 
			  and isnull(ab.flight_constraint, '')=isnull(ss.flight_constraint, '') 
			and isnull(ab.metadata_appversion, '')= isnull(ss.metadata_appversion, '')) 

		select @sql='master..xp_cmdshell ''move '+@fetchfrom+'sk_android_bibo_model_enabled_eventAgg* '+@archieveto+''''
		exec(@sql) 

		-- no matter changes, re-run quota sampling 
		exec dbo.p_Unattending_fileinjection_quota 'BIBO'
	end   
	 
 end 
  
-------------------------------------------------------- 7. for ABBiboModelValidationStaging -------------------------------------------------------
--------------------------------------------------------  7. for ABBiboModelValidationStaging --------------------------------------------------------
if exists(select 1 from #thedatafile where thefile like 'skandroid__sk_android_bibo_model_validation_eventAgg%')
begin
	select top 1 @thefile=thefile from #thedatafile where thefile like 'skandroid__sk_android_bibo_model_validation_eventAgg%' order by thefile 
	truncate table ABBiboModelEnableStaging
	 
	select @sql='bulk insert  ABBiboModelValidationStaging from '''+@fetchfrom+@thefile+''' with (fieldterminator=''\t'', maxerrors=200)'
	exec(@sql)
  
	if @@ROWCOUNT>2 -- at least two rows, one row is headers. 
	begin 
		-- update it
		update ab set ab.N=ss.N
					, ab.disN=ss.disN
					, ab.lastUpdated=GETUTCDATE()
		from ABBiboModelValidation  ab join ABBiboModelValidationStaging ss 
		on  isnull(ab.flight_id, '')=isnull(ss.flight_id, '')  and ab.onUTC=ss.onUTC 
			and isnull(ab.metadata_appversion, '')= isnull(ss.metadata_appversion, '')
			and isnull(ab.result, '')=isnull(ss.result, '')and isnull(ab.flight_constraint, '')=isnull(ss.flight_constraint, '') 
			 	  
		insert into ABBiboModelValidation ( metadata_appversion
			, category
			, subcategory
			, flight_id
			,flight_constraint
			, onUTC
			, result
			, disN 
			, N
			, lastupdated) 
		select  metadata_appversion
			, category
			, subcategory
			, flight_id
			, left(flight_constraint, 128)
			, onUTC
			, result
			, disN 
			, N
			, GETUTCDATE()
			from ABBiboModelValidationStaging ss where N!='N'  and len(metadata_appversion)<256  
			and not exists(select 1 from ABBiboModelValidation  ab 
			where  isnull(ab.flight_id, '')=isnull(ss.flight_id, '')  and ab.onUTC=ss.onUTC 
			and isnull(ab.metadata_appversion, '')= isnull(ss.metadata_appversion, '')
			and isnull(ab.result, '')=isnull(ss.result, '')
			and isnull(ab.flight_constraint, '')=isnull(ss.flight_constraint, '') ) 

		select @sql='master..xp_cmdshell ''move '+@fetchfrom+'skandroid__sk_android_bibo_model_validation_eventAgg* '+@archieveto+''''
		exec(@sql) 
	end   
	 
 end  

 
-------------------------------------------------------- 8. for ABBiboModelDownloadStaging -------------------------------------------------------
-------------------------------------------------------- 8. for ABBiboModelDownloadStaging --------------------------------------------------------
if exists(select 1 from #thedatafile where thefile like 'skandroid__sk_android_bibo_model_download_eventAgg%')
begin
	select top 1 @thefile=thefile from #thedatafile where thefile like 'skandroid__sk_android_bibo_model_download_eventAgg%' order by thefile 
	truncate table ABBiboModelDownloadStaging
	 
	select @sql='bulk insert  ABBiboModelDownloadStaging from '''+@fetchfrom+@thefile+''' with (fieldterminator=''\t'', maxerrors=200)'
	exec(@sql)
  
	if @@ROWCOUNT>2 -- at least two rows, one row is headers. 
	begin 
		-- update it
		update ab set ab.N=ss.N
					, ab.disN=ss.disN
					, ab.lastUpdated=GETUTCDATE()
		from ABBiboModelDownload  ab join ABBiboModelDownloadStaging ss 
		on  isnull(ab.flight_id, '')=isnull(ss.flight_id, '')  and ab.onUTC=ss.onUTC 
			and isnull(ab.metadata_appversion, '')= isnull(ss.metadata_appversion, '')
			and isnull(ab.result, '')=isnull(ss.result, '') and isnull(ab.flight_constraint, '')=isnull(ss.flight_constraint, '')
			 	 
		insert into ABBiboModelDownload ( metadata_appversion
			, category
			, subcategory
			, flight_id
			,flight_constraint
			, onUTC
			, result
			, disN 
			, N
			, lastupdated) 
		select  metadata_appversion
			, category
			, subcategory
			, flight_id
			, left(flight_constraint, 128)
			, onUTC
			, result
			, disN 
			, N
			, GETUTCDATE()
			from ABBiboModelDownloadStaging ss where N!='N'  and len(metadata_appversion)<256  
			and not exists(select 1 from ABBiboModelDownload  ab 
			where isnull(ab.flight_id, '')=isnull(ss.flight_id, '')  and ab.onUTC=ss.onUTC 
			and isnull(ab.metadata_appversion, '')= isnull(ss.metadata_appversion, '')
			and isnull(ab.result, '')=isnull(ss.result, '') and isnull(ab.flight_constraint, '')=isnull(ss.flight_constraint, ''))

		select @sql='master..xp_cmdshell ''move '+@fetchfrom+'skandroid__sk_android_bibo_model_download_eventAgg* '+@archieveto+''''
		exec(@sql) 
	end   
	 
 end  