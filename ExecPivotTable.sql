USE CLBPlancheckJd7g;

---------------------------------
-- Run pivot table
---------------------------------
declare @PivotTableID int = 24
declare @XColId int = null
declare @YColId int = null
declare @SummaryColId int = null
declare @XColFormat varchar(50) = null
declare @YColFormat varchar(50) = null
declare @SumFunc varchar(50) = null
declare @BaseQuery nvarchar(max) = null

select @XColId=P.ColID
	,@YColId=P.RowID
	,@SummaryColId=P.SumColID
	,@XColFormat=P.ColFormat
	,@YColFormat=P.RowFormat
	,@SumFunc=REPLACE(P.SumType, 'WAVG', 'AVG') -- For weighted average, pass the normal average func as it's not recognized by TSQL
	,@BaseQuery=Q.SQLStatement
from s_PivotTables P 
left outer join s_s5a Q on Q.Query_ID=P.QueryID
where PivotTableID=@PivotTableId

exec SpPivotQuery @YColId, @XColId, @SummaryColId, @SumFunc, 'E', @YColFormat, @XColFormat, @BaseQuery, 1


----------------------------------------------------
--declare @RowIDTable int = dbo.GetTableID(@YColId)
--declare @ColIDTable int = dbo.GetTableID(@XColId)
--declare @sql nvarchar(MAX)
--exec SP_GetRelatedValues_QueryAsString @RowIDTable, @ColIDTable, @sql OUTPUT
--select @sql
--RETURN

--select * from Questions;

--Select  avg(points)   FROM [Survey_Responses] , [Counter_Sign_In] , [Contacts]  
--WHERE [Counter_Sign_In].[Counter_Sign_InID] = [Survey_Responses].[Counter_Sign_InID] 
--AND [Contacts].[ContactsID] = [Counter_Sign_In].[Name] 
--and question=1

--;WITH R AS (
--select  Question, avg(points) over (partition by Question order by Question) as AVERAGES  FROM [Survey_Responses] , [Counter_Sign_In] , [Contacts]  
--where [Counter_Sign_In].[Counter_Sign_InID] = [Survey_Responses].[Counter_Sign_InID] 
--and [Contacts].[ContactsID] = [Counter_Sign_In].[Name]) select distinct * from R;
---------------------------------------------------
declare @base nvarchar(MAX)
declare @FromPart varchar(MAX)
declare @Table1ID int = dbo.GetTableID(@YColId)
declare @Table2ID int = dbo.GetTableID(@XColId)

if @BaseQuery is NULL
begin
	exec  dbo.SP_GetRelatedValues_QueryAsString @Table1ID, @Table2ID, @base OUTPUT --, 'P'  --,-1,NULL,0,'',0,'',0,NULL,NULL, )
end
else
begin
	set @base = @BaseQuery
end

if( CHARINDEX(' Order by',@base) > 0)
begin
	set @FromPart  = SUBSTRING(@base, CHARINDEX(' From',@base), CHARINDEX(' Order by',@base) - CHARINDEX(' From',@base)+1)
end
else
begin
	set @FromPart  = SUBSTRING(@base, CHARINDEX(' From',@base), LEN(@base) - CHARINDEX(' From',@base)+1)
end

declare @colExp nvarchar(MAX) = Case when @XColFormat is not NULL AND dbo.IsColumnDateTime(@XColId) = 1 then ' [dbo].[ufsFormat](' + dbo.GetColumnName(@XColId) + ',''' + @XColFormat + ''')' else ' ' + dbo.GetColumnName(@XColId) end 
--declare @colExp nvarchar(MAX) = Case when @YColFormat is not NULL AND dbo.IsColumnDateTime(@YColId) = 1 then ' [dbo].[ufsFormat](' + dbo.GetColumnName(@YColId) + ',''' + @YColFormat + ''')' else ' ' + dbo.GetColumnName(@YColId) end 
declare @query nvarchar(MAX) = ';WITH R AS ( select ' + @colExp + ' AS X, AVG(' + dbo.GetColumnName(@SummaryColId) + ') over (partition by ' + @colExp + ') as AVERAGES ' + @FromPart + ') select distinct * from R'
execute sp_executesql @query
