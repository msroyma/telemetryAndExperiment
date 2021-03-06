USE [SKSS]
GO
/****** Object:  StoredProcedure [dbo].[p_Sampling_experimentbirdview]    Script Date: 9/5/2017 8:45:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[p_Sampling_experimentbirdview]
WITH EXECUTE AS CALLER
AS 
/*
	1. manually run this to get the aggregation. copy and paste result to beekeeper
	2. a sql job will pick the results and insert into table ABExperiment
	3. ideal frequency: weekly or when new experiment is deployed. 
*/
set nocount on  
  
declare @outputpath varchar(1024)='\\rmz840\aswraw\FileIn\'
declare @timestamp varchar(128)
declare @beginning varchar(50)='2013-01-01' 

select @timestamp=datename(year, GETUTCDATE())
				+case when datepart(month, GETUTCDATE())>9 then '' else '0' end +convert(varchar(20), datepart(month, GETUTCDATE())) 
				+case when datepart(day, GETUTCDATE())>9 then '' else '0' end +convert(varchar(20), datepart(DAY, GETUTCDATE()))
				+case when datepart(HOUR, GETUTCDATE())>9 then '' else '0' end +convert(varchar(20), datepart(HOUR, GETUTCDATE()))
				+'00' 

declare @filename varchar(1024)='aggregates__experiments'+@timestamp+'.csv'

declare @printout varchar(max)=
'wbexport 
-type=text
-file='''+@outputpath+@filename+'''
-lineEnding=''crlf''
-delimiter=''\t''; 
select api_key
,app_version
, type
, experiment
, experiment_group
, flight_id
, category
, sub_category
, variant
, blob_owner
, min(flight_start_time) as flight_start_time
, max(flight_end_time) as flight_end_time
, min(start_timestamp) as start_timestamp
, max(end_timestamp) as end_timestamp 
, max(completed) as completed
, count(distinct install_id) as disN
, count(1) as N 
from aggregates.experiments where start_timestamp is null or start_timestamp>'''+@beginning+'''
 group by api_key,app_version, type
, experiment, experiment_group
, flight_id, category, sub_category
, variant, blob_owner ; 
' 
print(@printout)

--- get the time range for those without flight start-end time  
select @filename  ='aggregates__experimentvolume'+@timestamp+'.csv'
select  @printout  = 
'wbexport 
-type=text
-file='''+@outputpath+@filename+'''
-lineEnding=''crlf''
-delimiter=''\t''; 
select api_key
,app_version
, type
, experiment
, experiment_group
, flight_id
, category
, sub_category
, variant
, blob_owner
, min(flight_start_time) as flight_start_time
, max(flight_end_time) as flight_end_time
,  cast( start_timestamp as date) as start_timestamp
, max(end_timestamp) as end_timestamp 
, max(completed) as completed
, count(distinct install_id) as disN
, count(1) as N 
from aggregates.experiments where flight_start_time is null and start_timestamp>'''+@beginning+'''
 group by api_key,app_version, type
, experiment, experiment_group
, flight_id, category, sub_category
, variant, blob_owner
, CAST(start_timestamp AS DATE) ; 
' 
print(@printout)
 

--- get the time range for those with flight start-end time  
select @filename  ='aggregates__experimentbibo'+@timestamp+'.csv'
select  @printout  = 
'wbexport 
-type=text
-file='''+@outputpath+@filename+'''
-lineEnding=''crlf''
-delimiter=''\t''; 
select api_key
,app_version
, type
, experiment
, experiment_group
, flight_id
, category
, sub_category
, variant
, blob_owner
,  cast( flight_start_time as date) as flight_start_time
, max(flight_end_time) as flight_end_time
, min(start_timestamp) as start_timestamp
, max(end_timestamp) as end_timestamp 
, max(completed) as completed
, count(distinct install_id) as disN
, count(1) as N 
from aggregates.experiments where flight_start_time is not null 
 group by api_key,app_version, type
, experiment, experiment_group
, flight_id, category, sub_category
, variant, blob_owner
, CAST(flight_start_time AS DATE) ; 
' 
print(@printout)


--- get the time range for those with flight start-end time but agg by start_timestamp  
select @filename  ='aggregates__experimenttimedistr'+@timestamp+'.csv'
select  @printout  = 
'wbexport 
-type=text
-file='''+@outputpath+@filename+'''
-lineEnding=''crlf''
-delimiter=''\t''; 
select api_key
,app_version
, type
, experiment
, experiment_group
, flight_id
, category
, sub_category
, variant
, blob_owner
,  cast( flight_start_time as date) as flight_start_time
, max(flight_end_time) as flight_end_time
,  cast( start_timestamp as date) as start_timestamp 
, max(end_timestamp) as end_timestamp 
, max(completed) as completed
, count(distinct install_id) as disN
, count(1) as N 
from aggregates.experiments where flight_start_time is not null 
 group by api_key,app_version, type
, experiment, experiment_group
, flight_id, category, sub_category
, variant, blob_owner
, CAST(flight_start_time AS DATE) 
,  cast( start_timestamp as date) ; 
' 
print(@printout)


select @printout=
'
WBexport 
-type=text
-file=''\\rmz840\ASWRaw\FileIn\core_experiment_group_joined_eventAgg.txt''
-lineEnding=''crlf''
-delimiter=''\t'';  
select date(from_unixtime(metadata_timestamp_utcTimestamp/1000)) as onUTC, count(1) as N, count(distinct metadata_installId) as disN, experiment, group, metadata_appVersion  
from skandroid.core_experiment_group_joined_event  group by experiment, group, metadata_appVersion, date(from_unixtime(metadata_timestamp_utcTimestamp/1000));
 '
 print(@printout)
 
 select @printout=
'
 WBexport 
-type=text
-file=''\\rmz840\ASWRaw\FileIn\sk_android_bibo_model_enabled_eventAgg.txt''
-lineEnding=''crlf''
-delimiter=''\t'';  
select metadata_appversion, category, subcategory, flight_id, flight_constraint, 
date(from_unixtime(metadata_timestamp_utcTimestamp/1000)) as onUTC, 
count(1) as N, count(distinct metadata_installId) as disN
from skandroid.sk_android_bibo_model_enabled_event group by 
 metadata_appversion, category, subcategory, flight_id, flight_constraint, 
date(from_unixtime(metadata_timestamp_utcTimestamp/1000));
 '
 print(@printout)
/*
 drop table ABBiboModelEnableStaging
 drop table ABBiboModelEnable
 create table ABBiboModelEnableStaging(metadata_appversion varchar(20), category varchar(20), subcategory varchar(20), flight_id  varchar(50), 
 flight_constraint varchar(128),  onUTC varchar(50), N varchar(20), disN varchar(20))
 
create table ABBiboModelEnable (metadata_appversion varchar(20), category varchar(20), subcategory varchar(20), flight_id  varchar(50), 
flight_constraint varchar(128),  onUTC varchar(50), N int, disN int, lastupdated datetime default getutcdate() )
 
create clustered index c_i_ABBiboModelDownload on ABBiboModelEnable(flight_id)
*/
select @printout=
' 
WBexport 
-type=text
-file=''\\rmz840\ASWRaw\FileIn\skandroid__sk_android_bibo_model_validation_eventAgg.txt''
-lineEnding=''crlf''
-delimiter=''\t'';  
select metadata_appversion, category, subcategory, flight_id, flight_constraint, 
date(from_unixtime(metadata_timestamp_utcTimestamp/1000)) as onUTC, 
result,
count(1) as N, count(distinct metadata_installId) as disN
from skandroid.sk_android_bibo_model_validation_event group by 
 metadata_appversion, category, subcategory, flight_id, flight_constraint, 
date(from_unixtime(metadata_timestamp_utcTimestamp/1000)), result;
 '
 print(@printout)
 /*
  drop table ABBiboModelValidationStaging
 drop table ABBiboModelValidation
  create table ABBiboModelValidationStaging(metadata_appversion varchar(20),  category varchar(20), subcategory varchar(20), flight_id  varchar(50), 
 flight_constraint varchar(128),  onUTC varchar(50),result varchar(20), N varchar(20), disN varchar(20))
 
create table ABBiboModelValidation (metadata_appversion varchar(20),  category varchar(20), subcategory varchar(20), flight_id  varchar(50), 
 flight_constraint varchar(128),  onUTC varchar(50), result varchar(20), N int, disN int, lastupdated datetime default getutcdate())
 
 create clustered index c_i_ABBiboModelValidation on ABBiboModelValidation(onUTC)
 */ 

select @printout=
' 
WBexport 
-type=text
-file=''\\rmz840\ASWRaw\FileIn\skandroid__sk_android_bibo_model_download_eventAgg.txt''
-lineEnding=''crlf''
-delimiter=''\t'';  
select metadata_appversion, category, subcategory, flight_id, flight_constraint, 
date(from_unixtime(metadata_timestamp_utcTimestamp/1000)) as onUTC, 
result,
count(1) as N, count(distinct metadata_installId) as disN
from skandroid.sk_android_bibo_model_download_event group by 
metadata_appversion, category, subcategory, flight_id, flight_constraint, 
date(from_unixtime(metadata_timestamp_utcTimestamp/1000)), result;
 '
 print(@printout)
 /*
  drop table ABBiboModelDownloadStaging
 drop table ABBiboModelDownload
  create table ABBiboModelDownloadStaging( metadata_appversion varchar(20), category varchar(20), subcategory varchar(20), flight_id  varchar(50), 
 flight_constraint varchar(128),  onUTC varchar(50),result varchar(20), N varchar(20), disN varchar(20))
 
create table ABBiboModelDownload( metadata_appversion varchar(20), category varchar(20), subcategory varchar(20), flight_id  varchar(50), 
 flight_constraint varchar(128),  onUTC varchar(50), result varchar(20), N int, disN int, lastupdated datetime default getutcdate())

 create clustered index c_i_ABBiboModelDownload on ABBiboModelDownload(onUTC) 
 */