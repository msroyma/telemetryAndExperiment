USE [SKSS]
GO
/****** Object:  StoredProcedure [dbo].[p_Unattending_fileinjection_exam]    Script Date: 9/5/2017 8:49:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
ALTER PROCEDURE [dbo].[p_Unattending_fileinjection_exam]
@uniquecode varchar(20)='LGCY102'  
WITH EXECUTE AS CALLER
AS
/*
	 Date		: Sep 2 2017
	 author		: royma
	 Notes		:	
				select * from ABDataExam (nolock)
				select * from ABDataLogDetail (nolock) 
				truncate table ABDataExam
				truncate table ABDataLogDetail
				update abquerylog set examedbitwise=0  

				examedbitwise: 1: volume examed. 2: ranking examed. 4: count examed, 8: pairing examed 
*/ 
set nocount on    

declare --  @uniquecode varchar(20)='LGCY102' ,
		@sql varchar(max)='',		
		@outputpath varchar(128)='\\rmz840\ASWRaw\FileIn\', 
		@archievepath varchar(128)='\\rmz840\ASWRaw\FileStay\',
		@idd int=0,					@localTab varchar(128)='',				@datasql varchar(max)='' , 
		@thecol varchar(128) ='' , 
		@db varchar(128),			@tab varchar(128) ,						@profiletab varchar(128), 
		@timestampcol varchar(50),	@installidcol varchar(128),				@todaybig varchar(128), 
		@mastertab varchar(128),	@bitwiseint int=0

select @mastertab=@uniquecode+'_InstallIdList'
if not exists(select 1 from sys.tables (nolock) where name=@mastertab)
return
 
--------------------------------------- generate the master view --------------------------------------- 
declare @tab_po table(idd int identity, db varchar(20),  tab varchar(128), localtab varchar(128), examedbitwise int )
insert into @tab_po(tab, db, localtab, examedbitwise)
select distinct tab, db, name, bb.examedbitwise from  sys.tables aa join abquerylog bb on aa.name=@uniquecode+'__'+db+'__'+tab  
where bb.examedbitwise<15 ---1+2+4+8
--or aa.name='LGCY102__state_machine__typing_summary'

update aa set aa.isexists=1 from ABDatalog aa join @tab_po bb on aa.localtab=bb.localtab 
 
declare @tab_columns table (idd int identity, col varchar(128) primary key) 
 
--------------------------------------- columns on fact table ---------------------------------------  
while 1=1 
begin
	select top 1 @localTab=localtab, @db=db, @tab=tab, @bitwiseint=examedbitwise from @tab_po   where localtab>@localTab order by localtab 
	if @@ROWCOUNT=0
	break; 
		delete from @tab_columns 
		insert into @tab_columns(col)
		select name from sys.columns where object_name(object_id)=  @localTab  
		 
		select @timestampcol='', @installidcol=''
		select top 1 @installidcol=col from @tab_columns where col like '%meta%installId%'
		if @installidcol='' 
			select  top 1 @installidcol=col from @tab_columns where col like '%%install%Id%'

		select top 1 @timestampcol=col from @tab_columns where col like '%meta%utcTimestamp%' 
		if @timestampcol=''
			select top 1 @timestampcol=col from @tab_columns where col like '%event%time%' 

		delete from ABDataLogDetail where uniquecode=@uniquecode and localtab=@localtab 
		  
		-------------------------------------- volume info ---------------------------------------------
		if @bitwiseint&1=0
		begin 
			select @datasql='
			;insert into ABDataLogDetail(uniquecode, expgroup, localtab, distN, N, position) select '''+@uniquecode+''',  bb.expgroup,'''
			+@localtab+''',	count(distinct aa.'+@installidcol+'), count(1), 
			case when aa.'+@timestampcol+'>bb.metadata_timestamp_utcTimestamp
			then ''After'' else ''Before'' end 
			from '+@localTab+' aa (nolock)
			join '+@mastertab+' bb (nolock) on aa.'+@installidcol+' = bb.metadata_installid   
			group by  bb.expgroup,
			case when aa.'+@timestampcol+'>bb.metadata_timestamp_utcTimestamp
			then ''After'' else ''Before'' end ' 
			
			exec(@datasql)  
			update abquerylog set examedbitwise=isnull(examedbitwise, 0)+1 where UniqueCode=@uniquecode and @uniquecode+'__'+db+'__'+tab =@localTab;
			
		end   
		-------------------------------- counts info -------------------------------------------------------------- 
		if @bitwiseint&4=0
		begin 
			select @thecol=''
			delete from @tab_columns where col   like 'metadata%'  or col like 'date_received%' or col like 'last_merge'
			while 1=1
			begin
				select top 1 @thecol=col from @tab_columns where col>@thecol order by col asc 
				if @@rowcount=0
				break; 
				delete from ABDataExam where localtab=@localtab and datacategory='Counts' and columnName=@thecol and uniquecode=@uniquecode
				select @datasql='insert into ABDataExam(uniquecode,		db,						tab,					localtab,
				datacategory,					BIA,					inGroup,				hasRows,
				columnName,						numVals,				strVals,				nullVals,
				distinctVals)
				select '''+@uniquecode+''','''+@db+''','''+ @tab+''','''+ @localtab+''','+
				'''Counts'',						case when aa.'+@timestampcol+'>bb.metadata_timestamp_utcTimestamp
				then ''After'' else ''Before'' end,					bb.expgroup,				count(1),			
				'''+@thecol+''',				
				count(case when isnumeric(aa.['+@thecol+'])=1 and aa.['+@thecol+'] not in (''.'','','') and aa.['+@thecol+'] is not null then 1 end),
				count(case when (isnumeric(aa.['+@thecol+'])=0 or aa.['+@thecol+']  in (''.'','','')) and aa.['+@thecol+'] is not null  then 1 end),
				count(case when aa.['+@thecol+'] is null then 1 end) ,
				count(distinct aa.['+@thecol+']) 
				from '+@localTab+' aa (nolock)
				join '+@mastertab+' bb (nolock) on aa.'+@installidcol+' = bb.metadata_installid   
				group by  bb.expgroup,
				case when aa.'+@timestampcol+'>bb.metadata_timestamp_utcTimestamp
				then ''After'' else ''Before'' end ' 
				exec(@datasql) 
			end 
			update abquerylog set examedbitwise=isnull(examedbitwise, 0)+4 where UniqueCode=@uniquecode and @uniquecode+'__'+db+'__'+tab =@localTab;
		end   
		---------------------------------- ValRanking value ---------------------------------- 
		if @bitwiseint&2=0
		begin 
			select @thecol='' 
			while 1=1
			begin
				select top 1 @thecol=col from @tab_columns where col>@thecol order by col asc 
				if @@rowcount=0
				break; 
				delete from ABDataExam where localtab=@localtab and datacategory='ValRanking' and columnName=@thecol and uniquecode=@uniquecode
			
				----- data category strvalues 
				select @datasql=''
				select @datasql=' 
				;with ranking(val,n,rn) as (select ['+@thecol+'],count(1),ROW_NUMBER() over(order by count(1) desc)
				from   '+@localtab+' aa (nolock)  group by ['+@thecol+']) 
				,allcount(n,abovetweenty) as (select sum(n),isnull(sum(case when rn>19 then n end),0) from ranking)
				insert into ABDataExam(uniquecode, db,tab,localtab,datacategory,columnName,strVal,strValN,strValRatio,strValRank) 
				select '''+@uniquecode+''','''+@db+''','''+ @tab+''','''+@localtab+''',''ValRanking'','''
				+@thecol+''',aa.val,aa.n,aa.n*1.0/bb.n,aa.rn from ranking aa join allcount bb on 1=1 where aa.rn<20
				union all select '''+@uniquecode+''','''+@db+''','''+ @tab+''', '''+@localtab+''',''ValRanking'','''
				+@thecol+''',  ''(above 20)'',abovetweenty,abovetweenty*1.0/n,20 from allcount where abovetweenty>0 '
				exec(@datasql)
	
			end 
			update abquerylog set examedbitwise=isnull(examedbitwise, 0)+2 where UniqueCode=@uniquecode and @uniquecode+'__'+db+'__'+tab =@localTab;
		end 
		 
		---------------------------------- Pairing value ---------------------------------- 
		if @bitwiseint&8=0
		begin 
			select @thecol='' 
			while 1=1
			begin
				select top 1 @thecol=col from @tab_columns where col>@thecol order by col asc 
				if @@rowcount=0
				break; 
				delete from ABDataExam where localtab=@localtab and datacategory='Pairing' and columnName=@thecol and uniquecode=@uniquecode
			
				----- data category strvalues 
				select @datasql=''
				select @datasql=';with poool(install_id,bia,ab) as (  
				select aa.'+@installidcol+',  case when aa.'+@timestampcol+'>bb.metadata_timestamp_utcTimestamp
				then ''After'' else ''Before'' end,expgroup
				from   '+@localTab+' aa (nolock)
				join '+@mastertab+' bb (nolock) on aa.'+@installidcol+' = bb.metadata_installid    )
				,candi(install_id,ab,n) as (select install_id,ab,count(distinct bia) from poool  group by install_id,ab )
				insert into ABDataExam(uniquecode,db,tab,localtab,datacategory,columnName,inGroup,pairs) 
				select  '''+@uniquecode+''','''+@db+''','''+ @tab+''','''+@localtab+''',''Pairing'','''
				+@thecol+''',  ab,count(1) from candi where n=2  group by ab'		 
				exec(@datasql)   
				
			end  
			update abquerylog set examedbitwise=isnull(examedbitwise, 0)+8 where UniqueCode=@uniquecode and @uniquecode+'__'+db+'__'+tab =@localTab;  
		end    
end  
if object_id('tempdb..#tmpcol') is not null 
drop table #tmpcol 

  