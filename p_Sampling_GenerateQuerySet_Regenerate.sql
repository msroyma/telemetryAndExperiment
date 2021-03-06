USE [SKSS]
GO
/****** Object:  StoredProcedure [dbo].[p_Sampling_GenerateQuerySet_Regenerate]    Script Date: 9/5/2017 8:44:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
ALTER PROCEDURE [dbo].[p_Sampling_GenerateQuerySet_Regenerate]
@uniquecode varchar(12)='LGCY102'  
, @regenerationOptions int =8 --- 1: all. 2: failed only. 4: chopped only. 8: unchopped only
WITH EXECUTE AS CALLER
AS
/* 
*/ 
set nocount on    
---------------------------------------------------- print out unexecuted ------------------------------------------------- 
declare @idd int =0,			@fetchquery varchar(max) 
while 1=1
begin
	select top 1 @idd=	idd from ABQueryLog where uniquecode=@uniquecode 
	and idd>@idd 
	and ((hasFileError=1 and @regenerationOptions&2=2)
			or @regenerationOptions&1=1
			or (isChopped=0 and @regenerationOptions&8=8)
			or (isChopped=1 and @regenerationOptions&4=4)) 
	order by idd 
	if @@ROWCOUNT=0
	break;
	select @fetchquery =  fetchquery from ABQueryLog where idd=@idd
	print(@fetchquery) 
	print(
'
')
end  