USE [SKSS]
GO
/****** Object:  StoredProcedure [dbo].[p_Unattending_fileinjection_quota]    Script Date: 9/5/2017 8:22:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[p_Unattending_fileinjection_quota]
@exptype varchar(20)='Legacy'  ---- Legacy
as 
/* 
	Date		: Sept 1 2017
	author		: royma
	Notes		: use ABBiboModelEnable for BIBO, use ABJoinExp for Legacy. 
				  this procedure is executed right after file inject proc p_Unattending_fileinjection
*/  

set nocount on 
  
declare	@uniquecode varchar(20)='',			@flight_id varchar(50),				@minpocketsize int,
		@vers int,							@samplesize int,					@re float,	
		@maxday varchar(20),				@minday varchar(20),				@bibominimum int, 
		@lgcyuniquecode varchar(20)='',		@expname varchar(50),				@xplength int=7, 
		@descreasethreshold float,			@thresholdIdd int
		  
select @uniquecode='', @flight_id='' 
select @lgcyuniquecode='', @expname=''  

select @minpocketsize=val from ABConfig where config='Minimum Group Size' 
select @bibominimum=val from ABConfig where config='Minimum BIBO Version Size'  
select @samplesize=val from ABConfig where config='Default Sample Size' 
select @xplength=val from ABConfig where config='Experiment Duration'   
select @descreasethreshold=val from ABConfig where config='Decrease Threshold'   

------------------------------------------------------------ BIBO type------------------------------------------------------------ 
if @exptype='BIBO' 
begin
	declare @tab_flights table(f varchar(50) primary key)
	insert into @tab_flights(f)
	select distinct flight_id from ABBiboModelEnable where flight_id is not null order by flight_id 
  
	declare @tab_stats table(onutc datetime,	appver varchar(50),			gp varchar(128),		n int, 
							 ratio float,		reratio float,				quota int,				flag int, 
							 fromUtc date,		toUtc date) 
	declare @xp_tab table (idd int identity, flight_id varchar(20), groups int) 

	while 1=1 
	begin
		select top 1 @flight_id=f from @tab_flights where f>@flight_id order by f 
		if @@ROWCOUNT=0
		break; 

		delete from @tab_stats 
		;with alltogether (n) as (select sum(n) from ABBiboModelEnable   	
		where flight_id=@flight_id and flight_constraint is not null)
		insert into @tab_stats(onutc,n,ratio)
		select onutc, sum(aa.n), sum(aa.n)/1.0/bb.n from ABBiboModelEnable  aa join alltogether bb 
		on 1=1	where flight_id=@flight_id and aa.flight_constraint is not null 
		group by onutc, bb.n having  sum(aa.n)/1.0/bb.n>0.05 order by 1

		update @tab_stats set flag=1  
	 
		select @minday=convert(varchar(20), convert(date, min(onUTc)))
		, @maxday =convert(varchar(20), convert(date, max(onUTc))) from @tab_stats where flag=1 
	 
		insert into @tab_stats(appver, gp, n ,flag)
		select metadata_appversion, flight_constraint, sum(n), 2 from 
		ABBiboModelEnable WHERE flight_id =@flight_id and onutc>=@minday and onutc<=@maxday
		group by metadata_appversion, flight_constraint 
					
		select @uniquecode=''  
		if  exists(select 1 from ABExperimentQuota where flight_id=@flight_id and expstatus='New' and exptype='BIBO')
		begin
			select @uniquecode=uniquecode from ABExperimentQuota (nolock) where flight_id=@flight_id and expstatus='New' and  exptype='BIBO'
			delete from ABExperimentQuota where uniquecode=@uniquecode  
		end
		else
		begin
			select @uniquecode=max(uniquecode) from ABExperimentQuota where  exptype='BIBO'
			if @uniquecode is null or @uniquecode='' 
			select @uniquecode='BIBO100'
		
			select @uniquecode='BIBO'+convert(varchar(20), convert(int, right(@uniquecode, 3))+1)
		end 
		 
		select @vers=count(distinct gp) from @tab_stats where flag=2   
		;with howmany(app, c) as (select appver, count(distinct gp) from @tab_stats where n>@bibominimum and flag=2 
		group by appver)
		, mnn(mn) as (select min(n) from @tab_stats where n>1000 and flag=2 )
		, sums(lgs) as (  
		select sum( 1+convert(int, log(bb.n/1.0/nn.mn)))  from howmany aa join @tab_stats bb on aa.app=bb.appver join mnn 
		nn on 1=1 where c=@vers  ) 
		insert into ABExperimentQuota(	uniquecode,		flight_id,			exptype,		appver,			expgroup,		 
										gp,				appvermajor,
										inferredexpname, 
										expstatus,
										n,				quota,				fromutc,		toutc)
		select							@uniquecode,	@flight_id,			'BIBO',			app,			gp,
										case when charindex(':', gp, 0)>0 then substring(gp, charindex(':', gp, 0)+1, 128)
												else replace(replace(gp, '-', '_'), '.', '_') end, 
														reverse(substring(reverse(appver), charindex('.', reverse(appver), 0)+1, 20)),
										case when charindex(':', gp, 0)>0 then left(gp, charindex(':', gp, 0)-1) else @flight_id end, 
										'New',
										n,				case when  (1+convert(int, log(bb.n/1.0/nn.mn, 2)))*(@samplesize/1.0/ss.lgs)<@minpocketsize then @minpocketsize
										else  (1+convert(int, log(bb.n/1.0/nn.mn, 2)))*(@samplesize/1.0/ss.lgs) end ,
																			@minday,		@maxday 
		  from howmany aa join @tab_stats bb on aa.app=bb.appver join mnn 
		nn on 1=1 join sums ss on 1=1 where c=@vers
		order by n desc    
	end 
end 
-------------------------------------------------------------------------- Legacy -------------------------------------------------------------------------- 
else if @exptype='Legacy'
begin 
	declare @tab_flights2 table(f varchar(50) primary key)
	insert into @tab_flights2 (f)
	select   experiment from ABJoinExp  where  experiment  like '%[a-z][a-z]%' and metadata_appVersion is not null 
	group by experiment 
	having sum(n)>@samplesize  ----- in case of accidental experiment. 
   
	declare @num_tab table (idd int, onUtc date, n int)  
	declare @descing table(idd int, gp varchar(128), ver varchar(128), n int, descrease float, quota int, scaled float)

	select @lgcyuniquecode= isnull(max(uniquecode), 'LGCY100') from ABExperimentQuota (nolock) where  expstatus='New' and exptype='Legacy'
 
	while 1=1 
	begin
		select top 1 @expname=f from @tab_flights2 where f>@expname order by f 
		if @@ROWCOUNT=0
		break; 
	
		delete from @num_tab 
		insert into @num_tab(idd, onUtc,n)
		select ROW_NUMBER() over(order by onutc), onUtc, sum(n)  from ABJoinExp   (nolock)	
		where experiment=@expname and expgroup  is not null group by onutc  

		--- get the day with max bucket size 
		;with seek(idd, utc, n) as (select aa.idd, aa.onutc, sum(bb.n) 
		from @num_tab  aa join @num_tab  bb on bb.idd-aa.idd>=0 and bb.idd-aa.idd<@xplength group by aa.idd, aa.onUtc)
		select top 1 @minday=utc, @maxday=dateadd(day, @xplength-1, utc) from seek order by n desc  
	
		--------------- get the cut version/gp 
		delete from @descing 
		insert into @descing(idd, gp, ver, n) 	 
		select ROW_NUMBER() over(order by sum(n) desc), expgroup, metadata_appVersion, sum(n)  from ABJoinExp where experiment=@expname and onUTC>=@minday and onUTC<=@maxday 
		group by expgroup, metadata_appVersion  
	 
		update @descing set descrease=1.0 where idd=1
		update aa set aa.descrease=aa.n*1.0/bb.n from @descing aa join @descing bb on aa.idd=bb.idd-1 
		select top 1 @thresholdIdd=idd  from @descing  where descrease>=@descreasethreshold
	
		;with mininumIdd (n) as (select n from @descing where idd =@thresholdIdd ) 
		update aa set aa.scaled=1+log(aa.n/1.0/bb.n, 2)  from  @descing  aa join mininumIdd bb on 1=1 where idd<=@thresholdIdd 
		--update aa set aa.scaled= aa.n/1.0/bb.n  from  @descing  aa join mininumIdd bb on 1=1  where idd<=@thresholdIdd 
		;with portions(p) as (select @samplesize/sum(scaled) from @descing)
		update aa set aa.quota=case when aa.scaled*bb.p<@minpocketsize then @minpocketsize else aa.scaled*bb.p end 
		from @descing aa join portions bb on 1=1 
	
		select @lgcyuniquecode=''  
		if  exists(select 1 from ABExperimentQuota where inferredexpname =@expname and expstatus='New' and exptype='Legacy')
		begin
			select @lgcyuniquecode=uniquecode from ABExperimentQuota (nolock) where inferredexpname=@expname and expstatus='New' and exptype='Legacy'
			delete from ABExperimentQuota where uniquecode=@lgcyuniquecode  
		end
		else
		begin
			select @lgcyuniquecode=max(uniquecode) from ABExperimentQuota where  exptype='Legacy'
			if @lgcyuniquecode is null or @lgcyuniquecode='' 
			select @lgcyuniquecode='LGCY100'
		
			select @lgcyuniquecode='LGCY'+convert(varchar(20), convert(int, right(@lgcyuniquecode, 3))+1)
		end 
	    
		insert into ABExperimentQuota(	uniquecode,			inferredexpname,			exptype,		appver,			expgroup,		 
										gp,					appvermajor, 				expstatus,
										n,					quota,						fromutc,		toutc)

		select							@lgcyuniquecode,	@expname,					'Legacy',		ver,			gp,
										gp,				reverse(substring(reverse(ver), charindex('.', reverse(ver), 0)+1, 20)), 
										'New',
										n,				quota,						@minday,		@maxday  
		from @descing where idd<=@thresholdIdd  
	end  
 
end 
