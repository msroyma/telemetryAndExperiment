USE [SKSS]
GO
/****** Object:  StoredProcedure [dbo].[p_Inspection_housework]    Script Date: 9/5/2017 8:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[p_Inspection_housework] 
as 
/*	
	Date		: Aug 2017
	author		: royma
	Notes		: 
					This compares schement change: new/delete/change
*/   
set nocount on 

declare @topN int=2 

if object_id('tempdb..#addedonTab') is not null 
drop table  #addedonTab
create  table #addedonTab(added varchar(20), col varchar(32), colval varchar(128),  idd int identity)

;with topN(addedon, rn) as (select  addedon,ROW_NUMBER() over(order by addedon desc) from PRTable (nolock)group by addedon  )
insert #addedonTab(added, col)
select   addedon,  'See_'+addedon from topN  where rn<=@topN order by rn desc 
 
declare @cols varchar(8000)='db varchar(50), eventName varchar(128) ',		@sql varchar(max)='' , 
		@onecolval varchar(128)='',											@idd int =1, 
		@maxidd int,														@onecol varchar(32), 
		@added varchar(20) 
 
select @sql=@cols 

select @sql=case when @sql='' then '' else @sql +',' end +col +' varchar(32)'
from #addedonTab order by idd 

------------------------------------------------- table change  ------------------------------------------------- 
select @sql= 'create table PRSchemaChange('+@sql+')' 

if object_id('dbo.PRSchemaChange') is not null 
drop table PRSchemaChange  
exec(@sql) 
 
select @sql=' insert into PRSchemaChange(db, eventName)' 
+' select distinct db, tab from PRTable (nolock)  aa join #addedonTab tt on aa.addedon=tt.added'
exec(@sql)
  
select @maxidd=max(idd) from #addedonTab 
  
while @idd<=@maxidd and 1=1
begin
	select @onecol=''
	select @onecol=col, @added=added from #addedonTab where idd=@idd

	select @sql='; with lists(db, tab) as (select distinct db,tab from PRTable (nolock) '+
	'where addedon ='''+@added+''')'+
	' update ch set ch.'+@onecol+'=''y'' from PRSchemaChange ch join lists bb '+
	' on ch.db=bb.db and ch.eventName=bb.tab'
	exec(@sql)
	select @idd=@idd+1 
end 

------------------------------------------------- content change  ------------------------------------------------- 
 
truncate table #addedonTab  
;with topN(addedon, rn) as (select  addedon,ROW_NUMBER() over(order by addedon desc) from PRSchema (nolock)group by addedon  )
insert #addedonTab(added, col, colval)
select   addedon,  'See_'+addedon, 'See_'+addedon+'_sampleVaue' from topN  where rn<=@topN order by rn desc 
  
select @cols=''  
select @sql='db varchar(50), eventName varchar(128), attributeName varchar(128)  '
    
select @sql=case when @sql='' then '' else @sql +',' end +col +' varchar(128), '+ colval+'  varchar(512)'
from #addedonTab order by idd 
 
select @sql= 'create table PRContentChange('+@sql+')' 

if object_id('dbo.PRContentChange') is not null 
drop table PRContentChange  
exec(@sql) 
 
select @sql=' insert into PRContentChange(db, eventName, attributeName)' 
+' select distinct db, tab, aa.col from PRSchema (nolock) aa join #addedonTab tt on aa.addedon=tt.added'
exec(@sql)

select @idd=1, @maxidd=max(idd) from #addedonTab
 
while @idd<=@maxidd  
begin
	select @onecol=''
	select @onecol=col, @onecolval=colval,  @added=added from #addedonTab where idd=@idd

	select @sql='; with lists(db, tab, col, samplevalue) as (select distinct db,tab, col, samplevalue from PRSchema (nolock) '+
	'where addedon ='''+@added+''')'+
	' update ch set ch.'+@onecol+'=''y'', ch.'+@onecolval+'='+'isnull(bb.samplevalue, ''(null)'')'+' from PRContentChange ch join lists bb '+
	' on ch.db=bb.db and ch.eventName=bb.tab and ch.attributename=bb.col'
 
	exec(@sql)
	select @idd=@idd+1 
end  
  