CREATE TABLE [dbo].[TB_PT_PE_EMAIL_EXECEPTIONS]
(
    [PU_USUARIO] VARCHAR(8),
    CONSTRAINT [PK_TB_PT_PE_EMAIL_EXECEPTIONS]
        PRIMARY KEY([PU_USUARIO]),
    CONSTRAINT [FK_TB_PT_PE_EMAIL_EXECEPTIONS_TB_PT_PU_USERS]
        FOREIGN KEY([PU_USUARIO])
        REFERENCES dbo.[TB_PT_PU_USERS] ([PU_USUARIO])
)
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


CREATE FUNCTION [dbo].[SplitVarchar](
    @text VARCHAR(max), 
	@delimiter VARCHAR(max) = ','
) RETURNS @result TABLE (item VARCHAR(8000)) 

BEGIN 

	DECLARE @part VARCHAR(8000)

	WHILE CHARINDEX(@delimiter,@text,0) <> 0
	BEGIN

		SELECT
		  @part=RTRIM(LTRIM(SUBSTRING(@text,1,CHARINDEX(@delimiter,@text,0)-1))),
		  @text=RTRIM(LTRIM(SUBSTRING(@text,CHARINDEX(@delimiter,@text,0)+LEN(@delimiter),LEN(@text))))

		IF LEN(@part) > 0
		BEGIN
		  INSERT INTO @result SELECT @part
		END

	END 

	IF LEN(@text) > 0
	BEGIN
		INSERT INTO @result SELECT @text
	END

	RETURN

END
GO


CREATE FUNCTION [dbo].[SplitInt](
    @text VARCHAR(max), 
	@delimiter VARCHAR(max) = ','
) RETURNS @result TABLE (item int) 

BEGIN 

	DECLARE @part VARCHAR(8000)

	WHILE CHARINDEX(@delimiter,@text,0) <> 0
	BEGIN

		SELECT
		  @part=RTRIM(LTRIM(SUBSTRING(@text,1,CHARINDEX(@delimiter,@text,0)-1))),
		  @text=RTRIM(LTRIM(SUBSTRING(@text,CHARINDEX(@delimiter,@text,0)+LEN(@delimiter),LEN(@text))))

		IF LEN(@part) > 0
		BEGIN
		  INSERT INTO @result SELECT CONVERT(int, @part)
		END

	END 

	IF LEN(@text) > 0
	BEGIN
		INSERT INTO @result SELECT CONVERT(int, @text)
	END

	RETURN

END
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

/*
EXEC [sp_FIT_CHART_BY_CATEGORY]
	@Region			= 0,
	@Customer		= 0,
	@Location		= 0,
	@Responsible	= 'memaqasi',
	@Status			= 0,
	@Actual_Date	= '',
	@StartWeek		= '2009-06-01',
	@EndWeek		= '2010-07-01',
	@Segment		= 0,
	@UserName		= 'saofmich',
	@SavingCategory	= 0
*/

ALTER Procedure [dbo].[sp_FIT_CHART_BY_CATEGORY]
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS
DECLARE
	@NumDaysOfYear	int,
	@Month			int, 
	@WeekDay		int,
	@Year			int,
	@TotalValue		numeric(18,0)
--DECLARE
--	@Region			INT,
--	@Customer		INT,
--	@Location		INT,
--	@Responsible	VARCHAR(8),
--	@Status			INT,
--	@Actual_Date	VARCHAR(255),
--	@StartWeek		datetime,
--	@EndWeek		datetime,
--	@Segment		INT,
--	@UserName		VARCHAR(8),
--	@SavingCategory	INT
--
--drop table #DaysOfYear
--drop table #CategoryData
--drop table #CategoryWeek
--drop table #SummaryDataByYearWeekDay
--
--SET	@Region			= 0
--SET	@Customer		= 0
--SET	@Location		= 0
--SET	@Responsible	= '%'
--SET	@Status			= 0
--SET	@Actual_Date	= ''
--SET	@StartWeek		= '2009-06-01'
--SET	@EndWeek		= '2010-07-01'
--SET	@Segment		= 0
--SET	@UserName		= 'saofmich'
--SET	@SavingCategory	= 0

set @NumDaysOfYear = datediff(dd, @StartWeek, @EndWeek)+1

--drop table #DaysOfYear
--Criando tabela temporária para trazer todos os dias da semana do periodo indicado
SELECT
	--DATEADD(dd, M.number - 1, @StartWeek)					[Day],
	YEAR(DATEADD(dd, M.number - 1, @StartWeek))				[Year],
	DATEPART(wk, DATEADD(dd, M.number - 1, @StartWeek))		[WeekDay],
	DATEPART(month, DATEADD(dd, M.number - 1, @StartWeek))	[Month],
	DATENAME(month, DATEADD(dd, M.number - 1, @StartWeek))	[MonthName]
INTO
	#DaysOfYear
FROM
	master..spt_values AS M
WHERE
	M.type = 'P'
	AND M.number BETWEEN 1 AND @NumDaysOfYear

--By Category
--drop table #CategoryData
SELECT
	A.PN_CODIGO							CategoryCode,
	DATEPART(wk, A.PN_SAVINGDATE)		[WeekDay], 
	YEAR(A.PN_SAVINGDATE)				[Year],
	isnull(SUM(A.PN_SAVINGAMOUNT), 0)	Saving
INTO #CategoryData
FROM 
	TB_PT_PJ_PROJECTS P INNER JOIN TB_PT_PO_COSTSAVING A 
		ON P.PJ_CODIGO = A.PJ_CODIGO
WHERE
	CAST(P.PRE_CODIGO as varchar) LIKE CASE WHEN @Region <= 0 THEN '%' ELSE CAST(@Region AS VARCHAR) END
	AND CAST(P.PC_CODIGO as varchar) LIKE CASE WHEN @Customer <= 0 THEN '%' ELSE CAST(@Customer as varchar) END
	AND CAST(P.PL_CODIGO as varchar) LIKE CASE WHEN @Location <= 0 THEN '%' ELSE CAST(@Location as varchar) END	
	AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
	AND CAST(P.PS_CODIGO as varchar) LIKE CASE WHEN @Status <= 0 THEN '%' ELSE CAST(@Status as varchar) END										
	AND A.PN_SAVINGDATE BETWEEN @StartWeek AND @EndWeek --Mandatary 
	AND CAST(P.PG_CODIGO as varchar) LIKE CASE WHEN @Segment <= 0 THEN '%' ELSE CAST(@Segment as varchar) END	
	AND P.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@UserName))
	AND CAST(A.PN_CODIGO as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
GROUP BY
	A.PN_CODIGO,
	DATEPART(wk, A.PN_SAVINGDATE),
	YEAR(A.PN_SAVINGDATE)

--Valor total de SAVING
SELECT
	@TotalValue = sum(Saving)
FROM
	#CategoryData
print @TotalValue


SELECT 
	B.PN_CODIGO CategoryCode,
	a.[WeekDay], /*a.[MonthName], a.[Month],*/ a.[Year]
INTO #CategoryWeek
FROM 
	(SELECT DISTINCT [WeekDay], /*[MonthName], [Month],*/ [Year] FROM #DaysOfYear) A, 
	TB_PT_PN_SAVINGCATEGORY b
ORDER BY A.[Year], /*A.[Month],*/ A.[WeekDay], B.PN_CODIGO

--drop table #CategoryWeek

SELECT
	A.CategoryCode, A.WeekDay, A.[Year], isnull(sum(Saving), 0) Saving
INTO #SummaryDataByYearWeekDay
FROM
	#CategoryWeek A LEFT JOIN #CategoryData B
		ON A.CategoryCode = B.CategoryCode
			and A.WeekDay = B.WeekDay
			--and A.[Month] = B.[Month]
			and A.[Year] = B.[Year]
GROUP BY
	A.CategoryCode, A.WeekDay, A.[Year]
ORDER BY
	A.[Year], A.WeekDay, A.CategoryCode

--Obtendo todas as semanas que aparecem em mais de um mês
DECLARE RepeatWeekDay CURSOR FOR 
	SELECT MAX([Month]) [Month] , [WeekDay], [Year]
	FROM 
	(
		SELECT DISTINCT 
			[WeekDay], [MonthName], [Month], [Year]
		FROM #DaysOfYear
	) A
	GROUP BY [WeekDay], [Year]
	HAVING COUNT(*) > 1

OPEN RepeatWeekDay

FETCH NEXT FROM RepeatWeekDay INTO @Month, @WeekDay, @Year

--Apagando as linhas onde a semana aparece em mais de um mês.
WHILE @@FETCH_STATUS = 0
begin
	DELETE FROM #DaysOfYear WHERE [Month] = @Month AND [WeekDay] = @WeekDay AND [Year] = @Year

	FETCH NEXT FROM RepeatWeekDay INTO @Month, @WeekDay, @Year
end

CLOSE RepeatWeekDay
DEALLOCATE RepeatWeekDay

--SELECT * FROM #SummaryDataByYearWeekDay
--SELECT distinct [Year], [Month], [MonthName], [WeekDay] FROM #DaysOfYear order by [Year], [Month], [WeekDay] 
--SELECT * FROM TB_PT_PN_SAVINGCATEGORY

SELECT 
	A.[WeekDay], B.[MonthName], B.[Month], A.[Year],
	isnull(C.PN_Description, '-') CategoryDescription,
	isnull(A.Saving, 0) Saving,
	cast(isnull(A.Saving, 0)/isnull(@TotalValue,1) * 100 as numeric(18,2)) SavingPercent
FROM 
	#SummaryDataByYearWeekDay A LEFT JOIN (SELECT distinct [Year], [Month], [MonthName], [WeekDay] FROM #DaysOfYear) B
		ON A.[Year] = B.[Year]
			and A.[WeekDay] = B.[WeekDay]
	LEFT JOIN TB_PT_PN_SAVINGCATEGORY C
		ON A.CategoryCode = C.PN_Codigo
ORDER BY
	--A.[Year], B.[Month], A.[WeekDay]
	a.[Year], B.[Month], a.WeekDay, isnull(C.PN_Description, '-') desc



GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


/*
EXEC [sp_FIT_CHART_BY_CATEGORY_CUMULATE]
	@Region			= 0,
	@Customer		= 0,
	@Location		= 0,
	@Responsible	= 'memaqasi',
	@Status			= 0,
	@Actual_Date	= '',
	@StartWeek		= '2009-06-01',
	@EndWeek		= '2010-07-01',
	@Segment		= 0,
	@UserName		= 'saofmich',
	@SavingCategory	= 0
*/

ALTER Procedure [dbo].[sp_FIT_CHART_BY_CATEGORY_CUMULATE]
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS
DECLARE
	@NumDaysOfYear	int,
	@Month			int, 
	@WeekDay		int,
	@Year			int,
	@TotalValue		numeric(18,0)
--DECLARE
--	@Region			INT,
--	@Customer		INT,
--	@Location		INT,
--	@Responsible	VARCHAR(8),
--	@Status			INT,
--	@Actual_Date	VARCHAR(255),
--	@StartWeek		datetime,
--	@EndWeek		datetime,
--	@Segment		INT,
--	@UserName		VARCHAR(8),
--	@SavingCategory	INT
--
--drop table #DaysOfYear
--drop table #CategoryData
--drop table #CategoryWeek
--drop table #SummaryDataByYearWeekDay
--drop table #SummarizedCategoryData
--
--SET	@Region			= 0
--SET	@Customer		= 0
--SET	@Location		= 0
--SET	@Responsible	= '%'
--SET	@Status			= 0
--SET	@Actual_Date	= ''
--SET	@StartWeek		= '2009-06-01'
--SET	@EndWeek		= '2010-07-01'
--SET	@Segment		= 0
--SET	@UserName		= 'saofmich'
--SET	@SavingCategory	= 0

set @NumDaysOfYear = datediff(dd, @StartWeek, @EndWeek)+1

--drop table #DaysOfYear
--Criando tabela temporária para trazer todos os dias da semana do periodo indicado
SELECT
	--DATEADD(dd, M.number - 1, @StartWeek)					[Day],
	YEAR(DATEADD(dd, M.number - 1, @StartWeek))				[Year],
	DATEPART(wk, DATEADD(dd, M.number - 1, @StartWeek))		[WeekDay],
	DATEPART(month, DATEADD(dd, M.number - 1, @StartWeek))	[Month],
	DATENAME(month, DATEADD(dd, M.number - 1, @StartWeek))	[MonthName]
INTO
	#DaysOfYear
FROM
	master..spt_values AS M
WHERE
	M.type = 'P'
	AND M.number BETWEEN 1 AND @NumDaysOfYear

--By Category
--drop table #CategoryData
SELECT
	A.PN_CODIGO							CategoryCode,
	DATEPART(wk, A.PN_SAVINGDATE)		[WeekDay], 
	YEAR(A.PN_SAVINGDATE)				[Year],
	isnull(SUM(A.PN_SAVINGAMOUNT), 0)	Saving
INTO #CategoryData
FROM 
	TB_PT_PJ_PROJECTS P INNER JOIN TB_PT_PO_COSTSAVING A 
		ON P.PJ_CODIGO = A.PJ_CODIGO
WHERE
	CAST(P.PRE_CODIGO as varchar) LIKE CASE WHEN @Region <= 0 THEN '%' ELSE CAST(@Region AS VARCHAR) END
	AND CAST(P.PC_CODIGO as varchar) LIKE CASE WHEN @Customer <= 0 THEN '%' ELSE CAST(@Customer as varchar) END
	AND CAST(P.PL_CODIGO as varchar) LIKE CASE WHEN @Location <= 0 THEN '%' ELSE CAST(@Location as varchar) END	
	AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
	--AND P.PU_USUARIO LIKE @Responsible
	AND CAST(P.PS_CODIGO as varchar) LIKE CASE WHEN @Status <= 0 THEN '%' ELSE CAST(@Status as varchar) END										
	AND A.PN_SAVINGDATE BETWEEN @StartWeek AND @EndWeek --Mandatary 
	AND CAST(P.PG_CODIGO as varchar) LIKE CASE WHEN @Segment <= 0 THEN '%' ELSE CAST(@Segment as varchar) END	
	AND P.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@UserName))
	AND CAST(A.PN_CODIGO as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
GROUP BY
	A.PN_CODIGO,
	DATEPART(wk, A.PN_SAVINGDATE),
	YEAR(A.PN_SAVINGDATE)

--Valor total de SAVING
SELECT
	@TotalValue = sum(Saving)
FROM
	#CategoryData
print @TotalValue


SELECT 
	B.PN_CODIGO CategoryCode,
	a.[WeekDay], /*a.[MonthName], a.[Month],*/ a.[Year]
INTO #CategoryWeek
FROM 
	(SELECT DISTINCT [WeekDay], /*[MonthName], [Month],*/ [Year] FROM #DaysOfYear) A, 
	TB_PT_PN_SAVINGCATEGORY b
ORDER BY A.[Year], /*A.[Month],*/ A.[WeekDay], B.PN_CODIGO

--drop table #CategoryWeek

SELECT
	A.CategoryCode, A.WeekDay, A.[Year], isnull(sum(Saving), 0) Saving
INTO #SummaryDataByYearWeekDay
FROM
	#CategoryWeek A LEFT JOIN #CategoryData B
		ON A.CategoryCode = B.CategoryCode
			and A.WeekDay = B.WeekDay
			--and A.[Month] = B.[Month]
			and A.[Year] = B.[Year]
GROUP BY
	A.CategoryCode, A.WeekDay, A.[Year]
ORDER BY
	A.[Year], A.WeekDay, A.CategoryCode

--Obtendo todas as semanas que aparecem em mais de um mês
DECLARE RepeatWeekDay CURSOR FOR 
	SELECT MAX([Month]) [Month] , [WeekDay], [Year]
	FROM 
	(
		SELECT DISTINCT 
			[WeekDay], [MonthName], [Month], [Year]
		FROM #DaysOfYear
	) A
	GROUP BY [WeekDay], [Year]
	HAVING COUNT(*) > 1

OPEN RepeatWeekDay

FETCH NEXT FROM RepeatWeekDay INTO @Month, @WeekDay, @Year

--Apagando as linhas onde a semana aparece em mais de um mês.
WHILE @@FETCH_STATUS = 0
begin
	DELETE FROM #DaysOfYear WHERE [Month] = @Month AND [WeekDay] = @WeekDay AND [Year] = @Year

	FETCH NEXT FROM RepeatWeekDay INTO @Month, @WeekDay, @Year
end

CLOSE RepeatWeekDay
DEALLOCATE RepeatWeekDay

--SELECT * FROM #SummaryDataByYearWeekDay
--SELECT distinct [Year], [Month], [MonthName], [WeekDay] FROM #DaysOfYear order by [Year], [Month], [WeekDay] 
--SELECT * FROM TB_PT_PN_SAVINGCATEGORY

SELECT 
	A.[WeekDay], B.[MonthName], B.[Month], A.[Year],
	isnull(C.PN_Description, '-') CategoryDescription,
	isnull(A.Saving, 0) Saving,
	cast(isnull(A.Saving, 0)/isnull(@TotalValue,1) * 100 as numeric(18,2)) SavingPercent
INTO #SummarizedCategoryData
FROM 
	#SummaryDataByYearWeekDay A LEFT JOIN (SELECT distinct [Year], [Month], [MonthName], [WeekDay] FROM #DaysOfYear) B
		ON A.[Year] = B.[Year]
			and A.[WeekDay] = B.[WeekDay]
	LEFT JOIN TB_PT_PN_SAVINGCATEGORY C
		ON A.CategoryCode = C.PN_Codigo
ORDER BY
	A.[Year], B.[Month], A.[WeekDay]

SELECT
	a.WeekDay,
	a.MonthName,
	a.[Month],
	a.[Year],
	a.CategoryDescription,
	SUM(b.Saving)			Saving,
	SUM(b.SavingPercent)	SavingPercent
FROM 
	#SummarizedCategoryData a CROSS JOIN #SummarizedCategoryData b
WHERE
	b.WeekDay <= a.WeekDay--) AS RunningTotal
	and b.[Month] <= a.[Month]
	and b.[Year] <= a.[Year]
	and a.CategoryDescription = b.CategoryDescription
GROUP BY
	a.WeekDay,
	a.MonthName,
	a.[Month],
	a.[Year],
	a.CategoryDescription
ORDER BY
	a.[Year],
	a.[Month],
	a.WeekDay,
	a.CategoryDescription desc


GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


/*
EXEC [sp_FIT_CHART_BY_CATEGORY_CUMULATE_ALL]
	@Region			= 0,
	@Customer		= 0,
	@Location		= 0,
	@Responsible	= '%',
	@Status			= 0,
	@Actual_Date	= '',
	@StartWeek		= '2009-06-01',
	@EndWeek		= '2010-07-01',
	@Segment		= 0,
	@UserName		= 'saofmich',
	@SavingCategory	= 0
*/

ALTER Procedure [dbo].[sp_FIT_CHART_BY_CATEGORY_CUMULATE_ALL]
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS
DECLARE
	@NumDaysOfYear	int,
	@Month			int, 
	@WeekDay		int,
	@Year			int,
	@TotalValue		numeric(18,0)
--DECLARE
--	@Region			INT,
--	@Customer		INT,
--	@Location		INT,
--	@Responsible	VARCHAR(8),
--	@Status			INT,
--	@Actual_Date	VARCHAR(255),
--	@StartWeek		datetime,
--	@EndWeek		datetime,
--	@Segment		INT,
--	@UserName		VARCHAR(8),
--	@SavingCategory	INT
--
--drop table #DaysOfYear
--drop table #CategoryData
--drop table #CategoryWeek
--drop table #SummaryDataByYearWeekDay
--drop table #SummarizedCategoryData
--
--SET	@Region			= 0
--SET	@Customer		= 0
--SET	@Location		= 0
--SET	@Responsible	= '%'
--SET	@Status			= 0
--SET	@Actual_Date	= ''
--SET	@StartWeek		= '2009-06-01'
--SET	@EndWeek		= '2010-07-01'
--SET	@Segment		= 0
--SET	@UserName		= 'saofmich'
--SET	@SavingCategory	= 0

set @NumDaysOfYear = datediff(dd, @StartWeek, @EndWeek)+1

--drop table #DaysOfYear
--Criando tabela temporária para trazer todos os dias da semana do periodo indicado
SELECT
	DATEADD(dd, M.number - 1, @StartWeek)					[Day],
	YEAR(DATEADD(dd, M.number - 1, @StartWeek))				[Year],
	DATEPART(wk, DATEADD(dd, M.number - 1, @StartWeek))		[WeekDay],
	DATEPART(month, DATEADD(dd, M.number - 1, @StartWeek))	[Month],
	DATENAME(month, DATEADD(dd, M.number - 1, @StartWeek))	[MonthName]
INTO
	#DaysOfYear
FROM
	master..spt_values AS M
WHERE
	M.type = 'P'
	AND M.number BETWEEN 1 AND @NumDaysOfYear

--By Category
--drop table #CategoryData
SELECT
	A.PN_CODIGO							CategoryCode,
	DATEPART(wk, A.PN_SAVINGDATE)		[WeekDay], 
	YEAR(A.PN_SAVINGDATE)				[Year],
	isnull(SUM(A.PN_SAVINGAMOUNT), 0)	Saving
INTO #CategoryData
FROM 
	TB_PT_PJ_PROJECTS P INNER JOIN TB_PT_PO_COSTSAVING A 
		ON P.PJ_CODIGO = A.PJ_CODIGO
WHERE
	CAST(P.PRE_CODIGO as varchar) LIKE CASE WHEN @Region <= 0 THEN '%' ELSE CAST(@Region AS VARCHAR) END
	AND CAST(P.PC_CODIGO as varchar) LIKE CASE WHEN @Customer <= 0 THEN '%' ELSE CAST(@Customer as varchar) END
	AND CAST(P.PL_CODIGO as varchar) LIKE CASE WHEN @Location <= 0 THEN '%' ELSE CAST(@Location as varchar) END	
	AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
	--AND P.PU_USUARIO LIKE @Responsible
	AND CAST(P.PS_CODIGO as varchar) LIKE CASE WHEN @Status <= 0 THEN '%' ELSE CAST(@Status as varchar) END										
	AND A.PN_SAVINGDATE BETWEEN @StartWeek AND @EndWeek --Mandatary 
	AND CAST(P.PG_CODIGO as varchar) LIKE CASE WHEN @Segment <= 0 THEN '%' ELSE CAST(@Segment as varchar) END	
	AND P.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@UserName))
	AND CAST(A.PN_CODIGO as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
GROUP BY
	A.PN_CODIGO,
	DATEPART(wk, A.PN_SAVINGDATE),
	YEAR(A.PN_SAVINGDATE)

--Valor total de SAVING
SELECT
	@TotalValue = sum(Saving)
FROM
	#CategoryData
print @TotalValue


SELECT 
	B.PN_CODIGO CategoryCode,
	a.[WeekDay], /*a.[MonthName], a.[Month],*/ a.[Year]
INTO #CategoryWeek
FROM 
	(SELECT DISTINCT [WeekDay], /*[MonthName], [Month],*/ [Year] FROM #DaysOfYear) A, 
	TB_PT_PN_SAVINGCATEGORY b
ORDER BY A.[Year], /*A.[Month],*/ A.[WeekDay], B.PN_CODIGO

--drop table #CategoryWeek

SELECT
	A.CategoryCode, A.WeekDay, A.[Year], isnull(sum(Saving), 0) Saving
INTO #SummaryDataByYearWeekDay
FROM
	#CategoryWeek A LEFT JOIN #CategoryData B
		ON A.CategoryCode = B.CategoryCode
			and A.WeekDay = B.WeekDay
			--and A.[Month] = B.[Month]
			and A.[Year] = B.[Year]
GROUP BY
	A.CategoryCode, A.WeekDay, A.[Year]
ORDER BY
	A.[Year], A.WeekDay, A.CategoryCode

--Obtendo todas as semanas que aparecem em mais de um mês
DECLARE RepeatWeekDay CURSOR FOR 
	SELECT MAX([Month]) [Month] , [WeekDay], [Year]
	FROM 
	(
		SELECT DISTINCT 
			[WeekDay], [MonthName], [Month], [Year]
		FROM #DaysOfYear
	) A
	GROUP BY [WeekDay], [Year]
	HAVING COUNT(*) > 1

OPEN RepeatWeekDay

FETCH NEXT FROM RepeatWeekDay INTO @Month, @WeekDay, @Year

--Apagando as linhas onde a semana aparece em mais de um mês.
WHILE @@FETCH_STATUS = 0
begin
	DELETE FROM #DaysOfYear WHERE [Month] = @Month AND [WeekDay] = @WeekDay AND [Year] = @Year

	FETCH NEXT FROM RepeatWeekDay INTO @Month, @WeekDay, @Year
end

CLOSE RepeatWeekDay
DEALLOCATE RepeatWeekDay

--select * from #DaysOfYear
--SELECT [Year], [Month], [MonthName], [WeekDay], min([Day]) FROM #DaysOfYear group by [Year], [Month], [MonthName], [WeekDay]
--SELECT distinct [Year], [Month], [MonthName], [WeekDay] FROM #DaysOfYear

--SELECT * FROM #SummaryDataByYearWeekDay
--SELECT distinct [Year], [Month], [MonthName], [WeekDay] FROM #DaysOfYear order by [Year], [Month], [WeekDay] 
--SELECT * FROM TB_PT_PN_SAVINGCATEGORY

SELECT 
	A.[WeekDay], B.[MonthName], B.[Month], A.[Year], minDay,
	isnull(C.PN_Description, '-') CategoryDescription,
	isnull(A.Saving, 0) Saving,
	cast(isnull(A.Saving, 0)/isnull(@TotalValue,1) * 100 as numeric(18,2)) SavingPercent
INTO #SummarizedCategoryData
FROM 
	--#SummaryDataByYearWeekDay A LEFT JOIN (SELECT distinct [Year], [Month], [MonthName], [WeekDay] FROM #DaysOfYear) B
	#SummaryDataByYearWeekDay A LEFT JOIN (SELECT [Year], [Month], [MonthName], [WeekDay], min([Day]) minDay FROM #DaysOfYear group by [Year], [Month], [MonthName], [WeekDay]) B
		ON A.[Year] = B.[Year]
			and A.[WeekDay] = B.[WeekDay]
	LEFT JOIN TB_PT_PN_SAVINGCATEGORY C
		ON A.CategoryCode = C.PN_Codigo
ORDER BY
	A.[Year], B.[Month], A.[WeekDay]

--select * from #SummarizedCategoryData where CategoryDescription = 'Total Material Loss'

SELECT
	a.WeekDay,
	a.MonthName,
	a.[Month],
	a.[Year],
	--a.MinDay,
	a.CategoryDescription,
	SUM(b.Saving)			Saving,
	SUM(b.SavingPercent)	SavingPercent
FROM 
	#SummarizedCategoryData a CROSS JOIN #SummarizedCategoryData b
WHERE
	--b.[Year] <= a.[Year]
	--and b.[Month] <= a.[Month]
	--and b.WeekDay <= a.WeekDay
	b.MinDay <= a.MinDay
	and a.CategoryDescription = b.CategoryDescription
GROUP BY
	a.WeekDay,
	a.MonthName,
	a.[Month],
	a.[Year],
	--a.MinDay,
	a.CategoryDescription
ORDER BY
	a.[Year], a.[Month], a.WeekDay, a.CategoryDescription desc


GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


/*
EXEC [sp_FIT_CHART_BY_REGION]
	@Region			= 0,
	@Customer		= 0,
	@Location		= 0,
	@Responsible	= '%',
	@Status			= 0,
	@Actual_Date	= '',
	@StartWeek		= '2010-05-01',
	@EndWeek		= '2010-07-31',
	@Segment		= 0,
	@UserName		= 'SAOMMONT',
	@SavingCategory	= 0
*/

ALTER PROCEDURE [dbo].[sp_FIT_CHART_BY_REGION]
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS
DECLARE
	@NumDaysOfYear	int,
	@Month			int, 
	@WeekDay		int,
	@Year			int,
	@TotalValue		numeric(18,0)
--DECLARE
--	@Region			INT,
--	@Customer		INT,
--	@Location		INT,
--	@Responsible	VARCHAR(8),
--	@Status			INT,
--	@Actual_Date	VARCHAR(255),
--	@StartWeek		datetime,
--	@EndWeek		datetime,
--	@Segment		INT,
--	@UserName		VARCHAR(8),
--	@SavingCategory	INT
--drop table #DaysOfYear
--drop table #CategoryData
--SET	@Region			= 0
--SET	@Customer		= 0
--SET	@Location		= 0
--SET	@Responsible	= '%'
--SET	@Status			= 0
--SET	@Actual_Date	= ''
--SET	@StartWeek		= '2010-05-01'
--SET	@EndWeek		= '2010-07-31'
--SET	@Segment		= 0
--SET	@UserName		= 'SAOMMONT'
--SET	@SavingCategory	= 0

--set @StartWeek = '2010-05-01'
--set @EndWeek = '2010-07-31'
set @NumDaysOfYear = datediff(dd, @StartWeek, @EndWeek)+1

--drop table #DaysOfYear
--Criando tabela temporária para trazer todos os dias da semana
SELECT
	DATEADD(dd, M.number - 1, @StartWeek)					[Day],
	DATEPART(wk, DATEADD(dd, M.number - 1, @StartWeek))		[WeekDay], 
	DATENAME(month, DATEADD(dd, M.number - 1, @StartWeek))	[MonthName], 
	DATEPART(month, DATEADD(dd, M.number - 1, @StartWeek))	[Month],
	YEAR(DATEADD(dd, M.number - 1, @StartWeek))				[Year]
INTO
	#DaysOfYear
FROM
	master..spt_values AS M
WHERE
	M.type = 'P'
	AND M.number BETWEEN 1 AND @NumDaysOfYear

--Obtendo todas as semanas que aparecem em mais de um mê
DECLARE RepeatWeekDay CURSOR FOR 
	SELECT MAX([Month]) [Month] , [WeekDay], [Year]
	FROM 
	(
		SELECT DISTINCT 
			[WeekDay], [MonthName], [Month], [Year]
		FROM #DaysOfYear
	) A
	GROUP BY [WeekDay], [Year]
	HAVING COUNT(*) > 1

OPEN RepeatWeekDay

FETCH NEXT FROM RepeatWeekDay INTO @Month, @WeekDay, @Year

--Apagando as linhas onde a semana aparece em mais de um mês.
WHILE @@FETCH_STATUS = 0
begin
	DELETE FROM #DaysOfYear WHERE [Month] = @Month AND [WeekDay] = @WeekDay AND [Year] = @Year

	FETCH NEXT FROM RepeatWeekDay INTO @Month, @WeekDay, @Year
end

CLOSE RepeatWeekDay
DEALLOCATE RepeatWeekDay

--By Category
--drop table #CategoryData
SELECT
	D.PRE_DESCRICAO						RegionDescription,
	SUM(A.PN_SAVINGAMOUNT)				Saving,
	DATEPART(wk, A.PN_SAVINGDATE)		[WeekDay], 
	DATENAME(month, A.PN_SAVINGDATE)	[MonthName], 
	DATEPART(month, A.PN_SAVINGDATE)	[Month],
	YEAR(A.PN_SAVINGDATE)				[Year]
INTO #CategoryData
FROM 
	TB_PT_PJ_PROJECTS P INNER JOIN TB_PT_PO_COSTSAVING A 
		ON P.PJ_CODIGO = A.PJ_CODIGO
	INNER JOIN TB_PT_PV_SAVINGTYPE B
		ON A.PV_CODIGO = B.PV_CODIGO
	INNER JOIN TB_PT_PN_SAVINGCATEGORY C
		ON A.PN_CODIGO = C.PN_CODIGO
	INNER JOIN TB_PT_PRE_REGIONS D
		ON P.PRE_CODIGO = D.PRE_CODIGO
WHERE
	CAST(P.PRE_CODIGO as varchar) LIKE CASE WHEN @Region <= 0 THEN '%' ELSE CAST(@Region AS VARCHAR) END
	AND CAST(P.PC_CODIGO as varchar) LIKE CASE WHEN @Customer <= 0 THEN '%' ELSE CAST(@Customer as varchar) END
	AND CAST(P.PL_CODIGO as varchar) LIKE CASE WHEN @Location <= 0 THEN '%' ELSE CAST(@Location as varchar) END	
	AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
	--AND P.PU_USUARIO LIKE @Responsible
	AND CAST(P.PS_CODIGO as varchar) LIKE CASE WHEN @Status <= 0 THEN '%' ELSE CAST(@Status as varchar) END										
	AND A.PN_SAVINGDATE BETWEEN @StartWeek AND @EndWeek --Mandatary 
	AND CAST(P.PG_CODIGO as varchar) LIKE CASE WHEN @Segment <= 0 THEN '%' ELSE CAST(@Segment as varchar) END	
	AND P.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@UserName))
	AND CAST(C.PN_CODIGO as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
GROUP BY
	D.PRE_DESCRICAO,
	DATEPART(wk, PN_SAVINGDATE), 
	DATENAME(month, PN_SAVINGDATE), 
	DATEPART(month, PN_SAVINGDATE),
	YEAR(PN_SAVINGDATE)

SELECT
	@TotalValue = sum(Saving)
FROM
	#CategoryData

SELECT
	RegionDescription,
	Saving,
	cast(Saving / isnull(@TotalValue,1) * 100	as numeric(18,2)) SavingPercent,
	[WeekDay],
	[MonthName],
	[Month],
	[Year]
FROM 
	#CategoryData


----select * from #CategoryData
--SELECT DISTINCT
--	a.[WeekDay], a.[MonthName], a.[Month], a.[Year], 
--	--b.CategoryDescription,
--	isnull(b.CategoryDescription, '-') CategoryDescription, 
--	isnull(b.Saving, 0) Saving
--	--c.TotalSaving
--FROM 
--	#DaysOfYear a LEFT JOIN #CategoryData b
--		ON a.[WeekDay] = b.[WeekDay]
--			AND a.[Month] = b.[Month]
--			AND a.[Year] = b.[Year]
--	--LEFT JOIN (SELECT SUM(Saving) TotalSaving, [WeekDay], [Month], [Year] FROM #CategoryData GROUP BY [WeekDay], [Month], [Year]) c
--	--	ON a.[WeekDay] = c.[WeekDay]
--	--		AND a.[Month] = c.[Month]
--	--		AND a.[Year] = c.[Year]
--ORDER BY a.[Year], a.[WeekDay], a.[Month], a.[MonthName]




GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


/*
EXEC[sp_FIT_CHART_BY_TYPE]
	@Region			= 0,
	@Customer		= 0,
	@Location		= 0,
	@Responsible	= '%',
	@Status			= 0,
	@Actual_Date	= '',
	@StartWeek		= '2010-05-01',
	@EndWeek		= '2010-07-31',
	@Segment		= 0,
	@UserName		= 'SAOMMONT',
	@SavingCategory	= 0
*/

ALTER PROCEDURE [dbo].[sp_FIT_CHART_BY_TYPE]
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS
DECLARE
	@NumDaysOfYear	int,
	@Month			int, 
	@WeekDay		int,
	@Year			int,
	@TotalValue		numeric(18,0)
--DECLARE
--	@Region			INT,
--	@Customer		INT,
--	@Location		INT,
--	@Responsible	VARCHAR(8),
--	@Status			INT,
--	@Actual_Date	VARCHAR(255),
--	@StartWeek		datetime,
--	@EndWeek		datetime,
--	@Segment		INT,
--	@UserName		VARCHAR(8),
--	@SavingCategory	INT
--drop table #DaysOfYear
--drop table #CategoryData
--SET	@Region			= 0
--SET	@Customer		= 0
--SET	@Location		= 0
--SET	@Responsible	= '%'
--SET	@Status			= 0
--SET	@Actual_Date	= ''
--SET	@StartWeek		= '2010-05-01'
--SET	@EndWeek		= '2010-07-31'
--SET	@Segment		= 0
--SET	@UserName		= 'SAOMMONT'
--SET	@SavingCategory	= 0

--set @StartWeek = '2010-05-01'
--set @EndWeek = '2010-07-31'
set @NumDaysOfYear = datediff(dd, @StartWeek, @EndWeek)+1

--drop table #DaysOfYear
--Criando tabela temporária para trazer todos os dias da semana
SELECT
	DATEADD(dd, M.number - 1, @StartWeek)					[Day],
	DATEPART(wk, DATEADD(dd, M.number - 1, @StartWeek))		[WeekDay], 
	DATENAME(month, DATEADD(dd, M.number - 1, @StartWeek))	[MonthName], 
	DATEPART(month, DATEADD(dd, M.number - 1, @StartWeek))	[Month],
	YEAR(DATEADD(dd, M.number - 1, @StartWeek))				[Year]
INTO
	#DaysOfYear
FROM
	master..spt_values AS M
WHERE
	M.type = 'P'
	AND M.number BETWEEN 1 AND @NumDaysOfYear

--Obtendo todas as semanas que aparecem em mais de um mê
DECLARE RepeatWeekDay CURSOR FOR 
	SELECT MAX([Month]) [Month] , [WeekDay], [Year]
	FROM 
	(
		SELECT DISTINCT 
			[WeekDay], [MonthName], [Month], [Year]
		FROM #DaysOfYear
	) A
	GROUP BY [WeekDay], [Year]
	HAVING COUNT(*) > 1

OPEN RepeatWeekDay

FETCH NEXT FROM RepeatWeekDay INTO @Month, @WeekDay, @Year

--Apagando as linhas onde a semana aparece em mais de um mês.
WHILE @@FETCH_STATUS = 0
begin
	DELETE FROM #DaysOfYear WHERE [Month] = @Month AND [WeekDay] = @WeekDay AND [Year] = @Year

	FETCH NEXT FROM RepeatWeekDay INTO @Month, @WeekDay, @Year
end

CLOSE RepeatWeekDay
DEALLOCATE RepeatWeekDay

--By Category
--drop table #CategoryData
SELECT
	B.PV_DESCRIPTION					CategoryDescription,
	SUM(A.PN_SAVINGAMOUNT)				Saving,
	DATEPART(wk, A.PN_SAVINGDATE)		[WeekDay], 
	DATENAME(month, A.PN_SAVINGDATE)	[MonthName], 
	DATEPART(month, A.PN_SAVINGDATE)	[Month],
	YEAR(A.PN_SAVINGDATE)				[Year]
INTO #CategoryData
FROM 
	TB_PT_PJ_PROJECTS P INNER JOIN TB_PT_PO_COSTSAVING A 
		ON P.PJ_CODIGO = A.PJ_CODIGO
	INNER JOIN TB_PT_PV_SAVINGTYPE B
		ON A.PV_CODIGO = B.PV_CODIGO
	INNER JOIN TB_PT_PN_SAVINGCATEGORY C
		ON A.PN_CODIGO = C.PN_CODIGO
WHERE
	CAST(P.PRE_CODIGO as varchar) LIKE CASE WHEN @Region <= 0 THEN '%' ELSE CAST(@Region AS VARCHAR) END
	AND CAST(P.PC_CODIGO as varchar) LIKE CASE WHEN @Customer <= 0 THEN '%' ELSE CAST(@Customer as varchar) END
	AND CAST(P.PL_CODIGO as varchar) LIKE CASE WHEN @Location <= 0 THEN '%' ELSE CAST(@Location as varchar) END	
	AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
	--AND P.PU_USUARIO LIKE @Responsible
	AND CAST(P.PS_CODIGO as varchar) LIKE CASE WHEN @Status <= 0 THEN '%' ELSE CAST(@Status as varchar) END										
	AND A.PN_SAVINGDATE BETWEEN @StartWeek AND @EndWeek --Mandatary 
	AND CAST(P.PG_CODIGO as varchar) LIKE CASE WHEN @Segment <= 0 THEN '%' ELSE CAST(@Segment as varchar) END	
	AND P.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@UserName))
	AND CAST(C.PN_CODIGO as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
GROUP BY
	B.PV_DESCRIPTION,
	DATEPART(wk, PN_SAVINGDATE), 
	DATENAME(month, PN_SAVINGDATE), 
	DATEPART(month, PN_SAVINGDATE),
	YEAR(PN_SAVINGDATE)

SELECT
	@TotalValue = sum(Saving)
FROM
	#CategoryData

SELECT
	CategoryDescription,
	Saving,
	cast(Saving / isnull(@TotalValue,1) * 100	as numeric(18,2)) SavingPercent,
	[WeekDay],
	[MonthName],
	[Month],
	[Year]
FROM 
	#CategoryData


----select * from #CategoryData
--SELECT DISTINCT
--	a.[WeekDay], a.[MonthName], a.[Month], a.[Year], 
--	--b.CategoryDescription,
--	isnull(b.CategoryDescription, '-') CategoryDescription, 
--	isnull(b.Saving, 0) Saving
--	--c.TotalSaving
--FROM 
--	#DaysOfYear a LEFT JOIN #CategoryData b
--		ON a.[WeekDay] = b.[WeekDay]
--			AND a.[Month] = b.[Month]
--			AND a.[Year] = b.[Year]
--	--LEFT JOIN (SELECT SUM(Saving) TotalSaving, [WeekDay], [Month], [Year] FROM #CategoryData GROUP BY [WeekDay], [Month], [Year]) c
--	--	ON a.[WeekDay] = c.[WeekDay]
--	--		AND a.[Month] = c.[Month]
--	--		AND a.[Year] = c.[Year]
--ORDER BY a.[Year], a.[WeekDay], a.[Month], a.[MonthName]




GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[sp_FIT_CLOSED_PROJECTS]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS	
	-- CORRIGIR VALOR DO ACTUAL_DATE
	IF (@ACTUAL_DATE = '%')
		SET @ACTUAL_DATE = NULL

	DECLARE @QUANTITY_TABLE TABLE
	(
		CODE INT,
		QUANTITY INT		
	)

	INSERT INTO @QUANTITY_TABLE
		-- TOTAL FECHADOS
		SELECT 
			X.PS_CODIGO,
			COUNT(*)
		FROM
		(
		SELECT DISTINCT --P.*, A.*
			P.PS_CODIGO,
			P.PJ_CODIGO
			--COUNT(*)
		FROM
			TB_PT_PJ_PROJECTS P left JOIN TB_PT_PO_COSTSAVING A 
				ON P.PJ_CODIGO = A.PJ_CODIGO
			left JOIN TB_PT_PN_SAVINGCATEGORY B
				ON A.PN_CODIGO = B.PN_CODIGO 
		WHERE
			P.PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek
				--ISNULL(CAST(CAST(DATEPART(YEAR, CAST(@ACTUAL_DATE AS DATETIME)) AS VARCHAR) + '-01-01' AS DATETIME), CAST('1753-01-01'AS DATETIME))
				--AND ISNULL(CAST(CAST(DATEPART(YEAR, CAST(@ACTUAL_DATE AS DATETIME)) AS VARCHAR) + '-12-31' AS DATETIME), CAST('9999-12-31' AS DATETIME))
			AND cast(P.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
			AND cast(P.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
			AND cast(P.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
	        AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
			--AND P.PU_USUARIO LIKE @RESPONSIBLE
			AND CAST(P.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
			AND P.PRE_CODIGO IN ( SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME) )
			AND CAST(isnull(B.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
		) X
		GROUP BY 
			PS_CODIGO

	SELECT 
		ISNULL((SELECT QUANTITY FROM @QUANTITY_TABLE WHERE CODE = 20), 0) AS TOTAL_CLOSED,
		ISNULL((SELECT QUANTITY FROM @QUANTITY_TABLE WHERE CODE = 21), 0) AS TOTAL_OPEN,
		ISNULL((SELECT QUANTITY FROM @QUANTITY_TABLE WHERE CODE = 22), 0) AS TOTAL_DROPPED,
		ISNULL((SELECT QUANTITY FROM @QUANTITY_TABLE WHERE CODE = 23), 0) AS TOTAL_HOLD




GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer		Comments
-------------------------------------------------------------------------------
06/01/2010		Marco Montebello	Adicinando os paramentros @StartWeek e @EndWeek, 
									além de alterar as respectivas ordens
*******************************************************************************
*/

ALTER               PROCEDURE [dbo].[sp_FIT_CLOSED_PROJECTS_BY_MONTH]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS	

	-- CORRIGIR VALOR DO ACTUAL_DATE
	IF (@ACTUAL_DATE = '%')
		SET @ACTUAL_DATE = GETDATE()
	
	-- VARIAVEIS --
	DECLARE	@COUNT	INT
	SET 	@COUNT = 1

	-- TABELA TEMPORARIA DE TOTAL DE PROJETOS FECHADOS
	DECLARE @TT_PC_PROJECT_CLOSED TABLE
	(
		PC_USUARIO 		VARCHAR(9),
		PC_MONTH		INT,
		PC_TOTAL_CLOSED	INT
	)

	-- TABELA TEMPORÁRIA POR MES --
	DECLARE @TT_PS_PROJECT_SUMMARY TABLE
	(
		PU_USUARIO 		VARCHAR(8),
		PU_NOME 		VARCHAR(255),
		PS_MONTH 		INT,
		PS_TOTAL_CLOSED	INT
	)

	-- TABELA TEMPORARIA PIVOT --
	DECLARE @TT_PT_PROJECTS_TOTAL TABLE
	(
		PT_USUARIO 		VARCHAR(9),
		PT_NOME			VARCHAR(255),	
		PT_TOTAL_JAN	INT,	
		PT_TOTAL_FEB	INT,
		PT_TOTAL_MAR	INT,
		PT_TOTAL_APR	INT,
		PT_TOTAL_MAY	INT,
		PT_TOTAL_JUN	INT,
		PT_TOTAL_JUL	INT,
		PT_TOTAL_AUG	INT,
		PT_TOTAL_SEP	INT,
		PT_TOTAL_OCT	INT,
		PT_TOTAL_NOV	INT,
		PT_TOTAL_DEC	INT
	)

	-- ALIMENTAR A TABELA TEMPORARIA COM TODOS OS MESES --
	-- VARIÁVEL QUE ARMAZENA OS MESES --
	DECLARE @TT_PM_PROJECT_MONTHS TABLE
	(
		PM_MONTH	INT
	)

	-- MONTAR TODOS OS MESES SUBSQUEQUENTES AO ATUAL
	WHILE (@COUNT < 13)
	BEGIN
		INSERT INTO @TT_PM_PROJECT_MONTHS (PM_MONTH) VALUES (@COUNT)

		SET @COUNT = @COUNT + 1
	END

	-- INSERIR TODOS OS MESES PARA OS USUARIOS
	INSERT INTO @TT_PS_PROJECT_SUMMARY
	SELECT 
		PU.PU_USUARIO, 
		PU.PU_NAME,
		PM.PM_MONTH,
		(0)
	FROM 
		TB_PT_PU_USERS PU INNER JOIN @TT_PM_PROJECT_MONTHS PM
			ON PU_USUARIO LIKE @RESPONSIBLE

	-- TOTAL FECHADOS
	INSERT INTO @TT_PC_PROJECT_CLOSED
	SELECT
		PU_USUARIO PC_USUARIO,
		PT_MONTH PC_MONTH,
		SUM(PT_CLOSED) PC_TOTAL_CLOSED
	FROM
	(
		SELECT 
			-- COUNT(*) AS TOTAL_CLOSED
			X.PU_USUARIO,
			DATEPART(MONTH, X.PJ_OPEN_DATE) PT_MONTH,
			(1) PT_CLOSED
		FROM
		(
		SELECT DISTINCT
			PU_USUARIO,
			PJ_OPEN_DATE,
			P.PJ_CODIGO
		FROM 
			TB_PT_PJ_PROJECTS P left JOIN TB_PT_PO_COSTSAVING A 
				ON P.PJ_CODIGO = A.PJ_CODIGO
			left JOIN TB_PT_PN_SAVINGCATEGORY B
				ON A.PN_CODIGO = B.PN_CODIGO
		WHERE 
			P.PJ_CLOSED_DATE IS NOT NULL 
			AND GETDATE() > P.PJ_CLOSED_DATE
			AND cast(P.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%'ELSE cast(@STATUS as varchar) END										
			AND cast(P.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
			AND cast(P.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
			AND cast(P.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
	        AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
			--AND P.PU_USUARIO LIKE @RESPONSIBLE
			AND P.PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek
				--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-01-' + '01' AS DATETIME) AND
				--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-12-' + '31' AS DATETIME)
			AND CAST(P.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
			AND P.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME))
			AND CAST(isnull(B.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
		)X
    ) AS TABELA
	GROUP BY
		PU_USUARIO,
		PT_MONTH

	-- UPDATE NA TABELA TEMPORARIA PARA MONTAR A SAIDA --
	UPDATE @TT_PS_PROJECT_SUMMARY
	SET 
		PS_TOTAL_CLOSED	= PC_TOTAL_CLOSED
	FROM 
		@TT_PS_PROJECT_SUMMARY INNER JOIN @TT_PC_PROJECT_CLOSED
			ON PU_USUARIO = PC_USUARIO
	WHERE 
		PS_MONTH = PC_MONTH

	-- SELECT * FROM @TT_PS_PROJECT_SUMMARY ORDER BY PU_NOME, PS_MONTH

	-- MONTAR TABELA PIVOT --
	INSERT INTO @TT_PT_PROJECTS_TOTAL
	SELECT
		PS.PU_USUARIO,
		PS.PU_NOME,
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 1 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 2 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 3 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 4 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 5 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 6 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 7 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 8 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 9 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 10 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 11 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 12 AND PSI.PU_USUARIO = PS.PU_USUARIO)
	FROM
		@TT_PS_PROJECT_SUMMARY PS
	GROUP BY
		PS.PU_USUARIO,
		PS.PU_NOME

	-- PREENCHER COM ZERO VALORES NULOS
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_JAN = 0 WHERE PT_TOTAL_JAN IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_FEB = 0 WHERE PT_TOTAL_FEB IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_MAR = 0 WHERE PT_TOTAL_MAR IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_APR = 0 WHERE PT_TOTAL_APR IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_MAY = 0 WHERE PT_TOTAL_MAY IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_JUN = 0 WHERE PT_TOTAL_JUN IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_JUL = 0 WHERE PT_TOTAL_JUL IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_AUG = 0 WHERE PT_TOTAL_AUG IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_SEP = 0 WHERE PT_TOTAL_SEP IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_OCT = 0 WHERE PT_TOTAL_OCT IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_NOV = 0 WHERE PT_TOTAL_NOV IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_DEC = 0 WHERE PT_TOTAL_DEC IS NULL

	-- EXIBIR TABELA --
	SELECT * FROM @TT_PT_PROJECTS_TOTAL 
	WHERE 
		PT_TOTAL_JAN <> 0 
		OR PT_TOTAL_FEB <> 0 
		OR PT_TOTAL_MAR <> 0 
		OR PT_TOTAL_APR <> 0 
		OR PT_TOTAL_MAY <> 0 
		OR PT_TOTAL_JUN <> 0 
		OR PT_TOTAL_JUL <> 0 
		OR PT_TOTAL_AUG <> 0 
		OR PT_TOTAL_SEP <> 0 
		OR PT_TOTAL_OCT <> 0 
		OR PT_TOTAL_NOV <> 0 
		OR PT_TOTAL_DEC <> 0 
	ORDER BY PT_NOME




GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer		Comments
-------------------------------------------------------------------------------
06/01/2010		Marco Montebello	Adicinando os paramentros @StartWeek e @EndWeek, 
									além de alterar as respectivas ordens
*******************************************************************************
*/

ALTER PROCEDURE [dbo].[SP_FIT_CLOSED_PROJECTS_BY_MONTH_GRAPH]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS	

	-- CORRIGIR VALOR DO ACTUAL_DATE
	IF (@ACTUAL_DATE = '%')
		SET @ACTUAL_DATE = GETDATE()
	
	-- VARIAVEIS --
	DECLARE	@COUNT	INT
	SET 	@COUNT = 1

	-- TABELA TEMPORARIA DE TOTAL DE PROJETOS FECHADOS
	DECLARE @TT_PC_PROJECT_CLOSED TABLE
	(
		PC_USUARIO 		VARCHAR(9),
		PC_MONTH		INT,
		PC_TOTAL_CLOSED	INT
	)

	-- TABELA TEMPORÁRIA POR MES --
	DECLARE @TT_PS_PROJECT_SUMMARY TABLE
	(
		PU_USUARIO 		VARCHAR(8),
		PU_NOME 		VARCHAR(255),
		PS_MONTH 		INT,
		PS_TOTAL_CLOSED	INT
	)

	-- ALIMENTAR A TABELA TEMPORARIA COM TODOS OS MESES --
	-- VARIÁVEL QUE ARMAZENA OS MESES --
	DECLARE @TT_PM_PROJECT_MONTHS TABLE
	(
		PM_MONTH	INT
	)

	-- MONTAR TODOS OS MESES SUBSQUEQUENTES AO ATUAL
	WHILE (@COUNT < 13)
	BEGIN
		INSERT INTO @TT_PM_PROJECT_MONTHS (PM_MONTH) VALUES (@COUNT)

		SET @COUNT = @COUNT + 1
	END

	-- INSERIR TODOS OS MESES PARA OS USUARIOS
	INSERT INTO @TT_PS_PROJECT_SUMMARY
	SELECT 
		PU.PU_USUARIO, 
		PU.PU_NAME,
		PM.PM_MONTH,
		(0)
	FROM 
		TB_PT_PU_USERS PU INNER JOIN @TT_PM_PROJECT_MONTHS PM
			ON PU_USUARIO LIKE @RESPONSIBLE

	-- TOTAL FECHADOS
	INSERT INTO @TT_PC_PROJECT_CLOSED
	SELECT
		PU_USUARIO PC_USUARIO,
		PT_MONTH PC_MONTH,
		SUM(PT_CLOSED) PC_TOTAL_CLOSED
	FROM
	(
		SELECT 
			-- COUNT(*) AS TOTAL_CLOSED
			PU_USUARIO,
			DATEPART(MONTH, PJ_OPEN_DATE) PT_MONTH,
			(1) PT_CLOSED
		FROM
		(
		SELECT
			PU_USUARIO,
			PJ_OPEN_DATE,
			P.PJ_CODIGO
		FROM 
			TB_PT_PJ_PROJECTS  P left JOIN TB_PT_PO_COSTSAVING A 
				ON P.PJ_CODIGO = A.PJ_CODIGO
			left JOIN TB_PT_PN_SAVINGCATEGORY B
				ON A.PN_CODIGO = B.PN_CODIGO
		WHERE 
			PJ_CLOSED_DATE IS NOT NULL 
			AND GETDATE() > PJ_CLOSED_DATE
			AND cast(PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
			AND cast(PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
			AND cast(PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
			AND cast(PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
	        AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
			--AND PU_USUARIO LIKE @RESPONSIBLE
			AND PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek
				--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-01-' + '01' AS DATETIME) AND
				--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-12-' + '31' AS DATETIME)
			AND CAST(PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
			AND PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME))
			AND CAST(isnull(B.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
		) X
	) AS TABELA
	GROUP BY
		PU_USUARIO,
		PT_MONTH

	-- UPDATE NA TABELA TEMPORARIA PARA MONTAR A SAIDA --
	UPDATE @TT_PS_PROJECT_SUMMARY
	SET 
		PS_TOTAL_CLOSED	= PC_TOTAL_CLOSED
	FROM 
		@TT_PS_PROJECT_SUMMARY INNER JOIN @TT_PC_PROJECT_CLOSED
			ON PU_USUARIO = PC_USUARIO
	WHERE 
		PS_MONTH = PC_MONTH

	-- INSERIR UM REGISTRO DE SUMARIZAÇÃO --
	INSERT INTO @TT_PS_PROJECT_SUMMARY
	SELECT
		PU_USUARIO,
		PU_NOME,
		0,
		SUM(PS_TOTAL_CLOSED)
	FROM
		@TT_PS_PROJECT_SUMMARY
	GROUP BY
		PU_USUARIO,
		PU_NOME

	SELECT * FROM @TT_PS_PROJECT_SUMMARY WHERE PS_TOTAL_CLOSED <> 0 ORDER BY PS_MONTH, PU_NOME




GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer		Comments
-------------------------------------------------------------------------------
06/01/2010		Marco Montebello	Adicinando os paramentros @StartWeek e @EndWeek, 
									além de alterar as respectivas ordens

*******************************************************************************
*/

ALTER PROCEDURE [dbo].[sp_FIT_CLOSED_PROJECTS_BY_TRIMESTER]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS	

	-- CORRIGIR VALOR DO ACTUAL_DATE
	IF (@ACTUAL_DATE = '%')
		SET @ACTUAL_DATE = GETDATE()
	
	-- VARIAVEIS --
	DECLARE	@COUNT	INT
	SET 	@COUNT = 1

	-- TABELA TEMPORARIA DE TOTAL DE PROJETOS FECHADOS
	DECLARE @TT_PC_PROJECT_CLOSED TABLE
	(
		PC_USUARIO 		VARCHAR(9),
		PC_MONTH		INT,
		PC_TOTAL_CLOSED	INT
	)

	-- TABELA TEMPORÁRIA POR MES --
	DECLARE @TT_PS_PROJECT_SUMMARY TABLE
	(
		PU_USUARIO 		VARCHAR(8),
		PU_NOME 		VARCHAR(255),
		PS_MONTH 		INT,
		PS_TOTAL_CLOSED	INT
	)

	-- TABELA TEMPORARIA PIVOT --
	DECLARE @TT_PT_PROJECTS_TOTAL TABLE
	(
		PT_USUARIO 		VARCHAR(9),
		PT_NOME			VARCHAR(255),	
		PT_TOTAL_JAN	INT,	
		PT_TOTAL_FEB	INT,
		PT_TOTAL_MAR	INT,
		PT_TOTAL_APR	INT,
		PT_TOTAL_MAY	INT,
		PT_TOTAL_JUN	INT,
		PT_TOTAL_JUL	INT,
		PT_TOTAL_AUG	INT,
		PT_TOTAL_SEP	INT,
		PT_TOTAL_OCT	INT,
		PT_TOTAL_NOV	INT,
		PT_TOTAL_DEC	INT
	)

	-- ALIMENTAR A TABELA TEMPORARIA COM TODOS OS MESES --
	-- VARIÁVEL QUE ARMAZENA OS MESES --
	DECLARE @TT_PM_PROJECT_MONTHS TABLE
	(
		PM_MONTH	INT
	)

	-- MONTAR TODOS OS MESES SUBSQUEQUENTES AO ATUAL
	WHILE (@COUNT < 13)
	BEGIN
		INSERT INTO @TT_PM_PROJECT_MONTHS (PM_MONTH) VALUES (@COUNT)

		SET @COUNT = @COUNT + 1
	END

	-- INSERIR TODOS OS MESES PARA OS USUARIOS
	INSERT INTO @TT_PS_PROJECT_SUMMARY
	SELECT 
		PU.PU_USUARIO, 
		PU.PU_NAME,
		PM.PM_MONTH,
		(0)
	FROM 
		TB_PT_PU_USERS PU INNER JOIN @TT_PM_PROJECT_MONTHS PM
			ON PU_USUARIO LIKE @RESPONSIBLE

	-- TOTAL FECHADOS
	INSERT INTO @TT_PC_PROJECT_CLOSED
	SELECT
		PU_USUARIO PC_USUARIO,
		PT_MONTH PC_MONTH,
		SUM(PT_CLOSED) PC_TOTAL_CLOSED
	FROM
	(
		SELECT 
			-- COUNT(*) AS TOTAL_CLOSED
			X.PU_USUARIO,
			DATEPART(MONTH, X.PJ_CLOSED_DATE) PT_MONTH,
			(1) PT_CLOSED
		FROM
		(
		SELECT DISTINCT
			PU_USUARIO,
			PJ_CLOSED_DATE,
			P.PJ_CODIGO
		FROM 
			TB_PT_PJ_PROJECTS P left JOIN TB_PT_PO_COSTSAVING A 
				ON P.PJ_CODIGO = A.PJ_CODIGO
			left JOIN TB_PT_PN_SAVINGCATEGORY B
				ON A.PN_CODIGO = B.PN_CODIGO
		WHERE 
			P.PJ_CLOSED_DATE IS NOT NULL 
			AND GETDATE() > P.PJ_CLOSED_DATE
			AND cast(P.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
			AND cast(P.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
			AND cast(P.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
			AND cast(P.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
	        AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
			--AND P.PU_USUARIO LIKE @RESPONSIBLE
			AND P.PJ_CLOSED_DATE BETWEEN @StartWeek and @EndWeek
				--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-01-' + '01' AS DATETIME) AND
				--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-12-' + '31' AS DATETIME)
			AND CAST(PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
			AND P.PRE_CODIGO IN ( SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME) )
			AND CAST(isnull(B.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
		) X
	) AS TABELA
	GROUP BY
		PU_USUARIO,
		PT_MONTH

	-- UPDATE NA TABELA TEMPORARIA PARA MONTAR A SAIDA --
	UPDATE @TT_PS_PROJECT_SUMMARY
	SET 
		PS_TOTAL_CLOSED	= PC_TOTAL_CLOSED
	FROM
		@TT_PS_PROJECT_SUMMARY INNER JOIN @TT_PC_PROJECT_CLOSED
			ON PU_USUARIO = PC_USUARIO
	WHERE 
		PS_MONTH = PC_MONTH

	-- SELECT * FROM @TT_PS_PROJECT_SUMMARY ORDER BY PU_NOME, PS_MONTH

	-- MONTAR TABELA PIVOT --
	INSERT INTO @TT_PT_PROJECTS_TOTAL
	SELECT
		PS.PU_USUARIO,
		PS.PU_NOME,
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 1 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 2 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 3 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 4 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 5 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 6 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 7 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 8 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 9 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 10 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 11 AND PSI.PU_USUARIO = PS.PU_USUARIO),
		(SELECT SUM(PS_TOTAL_CLOSED) FROM @TT_PS_PROJECT_SUMMARY PSI WHERE PSI.PS_MONTH = 12 AND PSI.PU_USUARIO = PS.PU_USUARIO)
	FROM
		@TT_PS_PROJECT_SUMMARY PS
	GROUP BY
		PS.PU_USUARIO,
		PS.PU_NOME

	-- PREENCHER COM ZERO VALORES NULOS
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_JAN = 0 WHERE PT_TOTAL_JAN IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_FEB = 0 WHERE PT_TOTAL_FEB IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_MAR = 0 WHERE PT_TOTAL_MAR IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_APR = 0 WHERE PT_TOTAL_APR IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_MAY = 0 WHERE PT_TOTAL_MAY IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_JUN = 0 WHERE PT_TOTAL_JUN IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_JUL = 0 WHERE PT_TOTAL_JUL IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_AUG = 0 WHERE PT_TOTAL_AUG IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_SEP = 0 WHERE PT_TOTAL_SEP IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_OCT = 0 WHERE PT_TOTAL_OCT IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_NOV = 0 WHERE PT_TOTAL_NOV IS NULL
	UPDATE @TT_PT_PROJECTS_TOTAL SET PT_TOTAL_DEC = 0 WHERE PT_TOTAL_DEC IS NULL

	-- EXIBIR TABELA --
	SELECT
		PT_USUARIO,
		PT_NOME,
		(PT_TOTAL_JAN + PT_TOTAL_FEB + PT_TOTAL_MAR) AS PT_TOTAL_TRI_1,
		(PT_TOTAL_APR + PT_TOTAL_MAY + PT_TOTAL_JUN) AS PT_TOTAL_TRI_2,
		(PT_TOTAL_JUL + PT_TOTAL_AUG + PT_TOTAL_SEP) AS PT_TOTAL_TRI_3,
		(PT_TOTAL_OCT + PT_TOTAL_NOV + PT_TOTAL_DEC) AS PT_TOTAL_TRI_4
	FROM 
		@TT_PT_PROJECTS_TOTAL	
	WHERE 
		PT_TOTAL_JAN <> 0 
		OR PT_TOTAL_FEB <> 0 
		OR PT_TOTAL_MAR <> 0 
		OR PT_TOTAL_APR <> 0 
		OR PT_TOTAL_MAY <> 0 
		OR PT_TOTAL_JUN <> 0 
		OR PT_TOTAL_JUL <> 0 
		OR PT_TOTAL_AUG <> 0 
		OR PT_TOTAL_SEP <> 0 
		OR PT_TOTAL_OCT <> 0 
		OR PT_TOTAL_NOV <> 0 
		OR PT_TOTAL_DEC <> 0 
	ORDER BY PT_NOME




GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer		Comments
-------------------------------------------------------------------------------
06/01/2010		Marco Montebello	Adicinando os paramentros @StartWeek e @EndWeek, 
									além de alterar as respectivas ordens
*******************************************************************************
*/

ALTER PROCEDURE [dbo].[SP_FIT_CLOSED_PROJECTS_BY_TRIMESTER_GRAPH]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS	
	-- CORRIGIR VALOR DO ACTUAL_DATE
	IF (@ACTUAL_DATE = '%')
		SET @ACTUAL_DATE = GETDATE()
	
	-- VARIAVEIS --
	DECLARE	@COUNT	INT
	SET 	@COUNT = 1

	-- TABELA TEMPORARIA DE TOTAL DE PROJETOS FECHADOS
	DECLARE @TT_PC_PROJECT_CLOSED TABLE
	(
		PC_USUARIO 		VARCHAR(9),
		PC_MONTH		INT,
		PC_TOTAL_CLOSED	INT
	)

	-- TABELA TEMPORÁRIA POR MES --
	DECLARE @TT_PS_PROJECT_SUMMARY TABLE
	(
		PU_USUARIO 		VARCHAR(8),
		PU_NOME 		VARCHAR(255),
		PS_MONTH 		INT,
		PS_TOTAL_CLOSED	INT
	)

	-- ALIMENTAR A TABELA TEMPORARIA COM TODOS OS MESES --
	-- VARIÁVEL QUE ARMAZENA OS MESES --
	DECLARE @TT_PM_PROJECT_MONTHS TABLE
	(
		PM_MONTH	INT
	)

	-- MONTAR TODOS OS MESES SUBSQUEQUENTES AO ATUAL
	WHILE (@COUNT < 13)
	BEGIN
		INSERT INTO @TT_PM_PROJECT_MONTHS (PM_MONTH) VALUES (@COUNT)

		SET @COUNT = @COUNT + 1
	END

	-- INSERIR TODOS OS MESES PARA OS USUARIOS
	INSERT INTO @TT_PS_PROJECT_SUMMARY
	SELECT 
		PU.PU_USUARIO, 
		PU.PU_NAME,
		PM.PM_MONTH,
		(0)
	FROM 
		TB_PT_PU_USERS PU INNER JOIN @TT_PM_PROJECT_MONTHS PM
			ON PU_USUARIO LIKE @RESPONSIBLE

	-- TOTAL FECHADOS
	INSERT INTO @TT_PC_PROJECT_CLOSED
	SELECT
		PU_USUARIO PC_USUARIO,
		PT_MONTH PC_MONTH,
		SUM(PT_CLOSED) PC_TOTAL_CLOSED
	FROM
	(
		SELECT 
			-- COUNT(*) AS TOTAL_CLOSED
			X.PU_USUARIO,
			DATEPART(MONTH, X.PJ_CLOSED_DATE) PT_MONTH,
			(1) PT_CLOSED
		FROM 
		(
		SELECT DISTINCT
			PU_USUARIO,
			PJ_CLOSED_DATE,
			P.PJ_CODIGO
		FROM 
			TB_PT_PJ_PROJECTS P left JOIN TB_PT_PO_COSTSAVING A 
				ON P.PJ_CODIGO = A.PJ_CODIGO
			left JOIN TB_PT_PN_SAVINGCATEGORY B
				ON A.PN_CODIGO = B.PN_CODIGO
		WHERE 
			PJ_CLOSED_DATE IS NOT NULL 
			AND GETDATE() > PJ_CLOSED_DATE
			AND cast(PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
			AND cast(PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
			AND cast(PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
			AND cast(PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
	        AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
			--AND PU_USUARIO LIKE @RESPONSIBLE
			AND PJ_CLOSED_DATE BETWEEN @StartWeek and @EndWeek
				--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-01-' + '01' AS DATETIME) AND
				--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-12-' + '31' AS DATETIME)
			AND CAST(PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
			AND PRE_CODIGO IN ( SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME) )
			AND CAST(isnull(B.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
		)X
	) AS TABELA
	GROUP BY
		PU_USUARIO,
		PT_MONTH

	-- UPDATE NA TABELA TEMPORARIA PARA MONTAR A SAIDA --
	UPDATE @TT_PS_PROJECT_SUMMARY
	SET 
		PS_TOTAL_CLOSED	= PC_TOTAL_CLOSED
	FROM 
		@TT_PS_PROJECT_SUMMARY INNER JOIN @TT_PC_PROJECT_CLOSED
			ON PU_USUARIO = PC_USUARIO
	WHERE 
		PS_MONTH = PC_MONTH

	-- UPDATE NOS VALORES DO MESES PARA MONTAR O GROUP BY
	UPDATE @TT_PS_PROJECT_SUMMARY SET PS_MONTH = 1 WHERE PS_MONTH IN (1,2,3)
	UPDATE @TT_PS_PROJECT_SUMMARY SET PS_MONTH = 2 WHERE PS_MONTH IN (4,5,6)
	UPDATE @TT_PS_PROJECT_SUMMARY SET PS_MONTH = 3 WHERE PS_MONTH IN (7,8,9)
	UPDATE @TT_PS_PROJECT_SUMMARY SET PS_MONTH = 4 WHERE PS_MONTH IN (10,11,12)

	-- INSERIR UM REGISTRO DE SUMARIZAÇÃO --
	INSERT INTO @TT_PS_PROJECT_SUMMARY
	SELECT
		PU_USUARIO,
		PU_NOME,
		0,
		SUM(PS_TOTAL_CLOSED)
	FROM
		@TT_PS_PROJECT_SUMMARY
	GROUP BY
		PU_USUARIO,
		PU_NOME		

	SELECT 
		PU_USUARIO,
		PU_NOME,
		PS_MONTH,
		SUM(PS_TOTAL_CLOSED) AS PS_TOTAL_CLOSED
	FROM 
		@TT_PS_PROJECT_SUMMARY 
	WHERE 
		PS_TOTAL_CLOSED <> 0 
	GROUP BY
		PU_USUARIO,
		PU_NOME,
		PS_MONTH
	ORDER BY 
		PS_MONTH, PU_NOME




GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer			Comments
-------------------------------------------------------------------------------
07-06-2007		Marcos Fernandes	Correção de quantidade de dados no relatório
06/01/2010		Marco Montebello	Adicinando os paramentros @StartWeek e @EndWeek, 
									além de alterar as respectivas ordens
*******************************************************************************
*/

ALTER PROCEDURE [dbo].[SP_FIT_CLOSED_PROJECTS_BY_YEAR]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT

AS	

	DECLARE @QUANTITY_TABLE TABLE
	(
		CODE INT,
		QUANTITY INT		
	)

	INSERT INTO @QUANTITY_TABLE
	
		-- TOTAL FECHADOS
		SELECT 
			X.PS_CODIGO,
			COUNT(*)
		FROM
		(
		SELECT DISTINCT
			P.PS_CODIGO,
			P.PJ_CODIGO
		FROM
			TB_PT_PJ_PROJECTS P left JOIN TB_PT_PO_COSTSAVING A 
				ON P.PJ_CODIGO = A.PJ_CODIGO
			left JOIN TB_PT_PN_SAVINGCATEGORY B
				ON A.PN_CODIGO = B.PN_CODIGO
		WHERE
			P.PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek
				--ISNULL(CAST(CAST(DATEPART(YEAR, CAST(GETDATE() AS DATETIME)) AS VARCHAR) + '-01-01' AS DATETIME), CAST('1753-01-01'AS DATETIME))
				--AND ISNULL(CAST(CAST(DATEPART(YEAR, CAST(GETDATE() AS DATETIME)) AS VARCHAR) + '-12-31' AS DATETIME), CAST('9999-12-31' AS DATETIME))
			AND cast(P.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
			AND cast(P.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
			AND cast(P.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
	        AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
			--AND P.PU_USUARIO LIKE @RESPONSIBLE
			AND CAST(P.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
			AND P.PRE_CODIGO IN ( SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME))
			AND CAST(isnull(B.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
		) X
		GROUP BY 
			X.PS_CODIGO


	SELECT 
		ISNULL((SELECT QUANTITY FROM @QUANTITY_TABLE WHERE CODE = 20), 0) AS TOTAL_CLOSED,
		ISNULL((SELECT QUANTITY FROM @QUANTITY_TABLE WHERE CODE = 21), 0) AS TOTAL_OPEN,
		ISNULL((SELECT QUANTITY FROM @QUANTITY_TABLE WHERE CODE = 22), 0) AS TOTAL_DROPPED,
		ISNULL((SELECT QUANTITY FROM @QUANTITY_TABLE WHERE CODE = 23), 0) AS TOTAL_HOLD




GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer		Comments
-------------------------------------------------------------------------------

*******************************************************************************
*/

ALTER      PROCEDURE [dbo].[SP_FIT_COSTING_SAVE]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS	
	
	SELECT
		DATEPART(year,P. PJ_CLOSED_DATE) AS COST_SAVING_YEAR, 
		--CAST(ISNULL(SUM(P.PJ_COST_SAVING), 0) AS INT) AS TOTAL_COST_SAVING
		CAST(ISNULL(SUM(A.PN_SAVINGAMOUNT), 0) AS INT) AS TOTAL_COST_SAVING
	FROM 
		TB_PT_PJ_PROJECTS P left JOIN TB_PT_PO_COSTSAVING A 
				ON P.PJ_CODIGO = A.PJ_CODIGO
			left JOIN TB_PT_PN_SAVINGCATEGORY B
				ON A.PN_CODIGO = B.PN_CODIGO 
	WHERE 
		cast(P.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
		AND cast(P.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
		AND cast(P.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
	    AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
		--AND P.PU_USUARIO LIKE @RESPONSIBLE
		AND P.PJ_CLOSED_DATE IS NOT NULL
		AND CAST(P.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
		AND cast(P.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
		AND P.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME))
		AND CAST(isnull(B.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	GROUP BY 
		DATEPART(year, PJ_CLOSED_DATE)




GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer		Comments
-------------------------------------------------------------------------------
06/01/2010		Marco Montebello	Adicinando os paramentros @StartWeek e @EndWeek, 
									além de alterar as respectivas ordens

*******************************************************************************
*/

ALTER PROCEDURE [dbo].[sp_FIT_COSTING_SAVE_BY_YEAR]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS	
	-- CORRIGIR VALOR DO ACTUAL_DATE
	IF (@ACTUAL_DATE = '%')
		SET @ACTUAL_DATE = GETDATE()
	
	SELECT
		DATEPART(year, P.PJ_OPEN_DATE) AS COST_SAVING_YEAR, 
		--ISNULL(SUM(P.PJ_COST_SAVING), 0) AS TOTAL_COST_SAVING
		ISNULL(SUM(A.PN_SAVINGAMOUNT), 0) AS TOTAL_COST_SAVING
	FROM 
		TB_PT_PJ_PROJECTS P left JOIN TB_PT_PO_COSTSAVING A 
			ON P.PJ_CODIGO = A.PJ_CODIGO
		left JOIN TB_PT_PN_SAVINGCATEGORY B
			ON A.PN_CODIGO = B.PN_CODIGO
	WHERE 
		cast(P.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
		AND cast(P.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
		AND cast(P.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
		AND cast(P.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
	    AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
		--AND P.PU_USUARIO LIKE @RESPONSIBLE
		AND P.PJ_CLOSED_DATE BETWEEN @StartWeek and @EndWeek
			--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-01-' + '01' AS DATETIME) AND
			--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-12-' + '31' AS DATETIME)
		AND CAST(P.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
		AND P.PRE_CODIGO IN ( SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME) )
		AND CAST(isnull(B.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	GROUP BY 
		DATEPART(year, P.PJ_OPEN_DATE)


GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer		Comments
-------------------------------------------------------------------------------
06/01/2010		Marco Montebello	Adicinando os paramentros @StartWeek e @EndWeek, 
									além de alterar as respectivas ordens
*******************************************************************************
*/


/*
[dbo].[sp_FIT_LIST_OF_PROJECTS]
  	@Region			=0,
	@Customer		=0,
	@Location		=0,
	@Responsible	='saofmich,memaqasi',
	@Status			=0,
	@Actual_Date	='%',
	@StartWeek		='2009-06-01',
	@EndWeek		='2010-07-01',
	@Segment		=0,
	@UserName		='saofmich',
	@SavingCategory	=0  
*/

ALTER              PROCEDURE [dbo].[sp_FIT_LIST_OF_PROJECTS]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS
	-- CORRIGIR VALOR DO ACTUAL_DATE
	IF (@ACTUAL_DATE = '%')
		SET @ACTUAL_DATE = NULL

	SELECT
		a.PJ_CODIGO AS CODE,
		b.PA_DESCRICAO AS CATEGORY,
		a.PJ_DESCRIPTION AS DESCRIPTION,
		c.PU_NAME AS RESPONSIBLE_NAME,
		d.PC_DESCRICAO AS CUSTOMER,
		e.PL_DESCRICAO AS LOCATION,
		a.PJ_OPEN_DATE AS OPEN_DATE,
		a.PJ_COMMIT_DATE AS COMMIT_DATE,
		a.PJ_CLOSED_DATE AS CLOSED_DATE,
		f.PS_DESCRICAO AS STATUS,
		ISNULL(SUM(H.PN_SAVINGAMOUNT), 0)  AS COST_SAVING, --CAST(a.PJ_COST_SAVING AS INT) AS COST_SAVING,
		a.PJ_REMARKS AS REMARKS,
		DATEDIFF(DAY,a.PJ_COMMIT_DATE, a.PJ_CLOSED_DATE) AS PERFORMANCE_PLAIN,
		isnull(g.PG_DESCRICAO, '-') AS SEGMENT,
		R.PRE_DESCRICAO AS REGION,
		A.PJ_PERCENT_COMPLETION AS PROGRESS
	FROM
		TB_PT_PJ_PROJECTS a INNER JOIN TB_PT_PA_CATEGORY b
			ON a.PA_CODIGO = b.PA_CODIGO
		INNER JOIN TB_PT_PU_USERS c
			ON a.PU_USUARIO = c.PU_USUARIO
		INNER JOIN TB_PT_PC_CUSTOMER d
			ON a.PC_CODIGO = d.PC_CODIGO
		INNER JOIN TB_PT_PL_LOCATION e
			ON a.PL_CODIGO = e.PL_CODIGO
		INNER JOIN TB_PT_ST_STATUS f
			ON a.PS_CODIGO = f.PS_CODIGO
		LEFT JOIN TB_PT_PG_SEGMENTOS g
			ON a.PG_CODIGO = g.PG_CODIGO
		left JOIN TB_PT_PO_COSTSAVING H 
			ON A.PJ_CODIGO = H.PJ_CODIGO
		left JOIN TB_PT_PN_SAVINGCATEGORY I
			ON H.PN_CODIGO = I.PN_CODIGO
		LEFT JOIN dbo.TB_PT_PRE_REGIONS R
			ON A.PRE_CODIGO = R.PRE_CODIGO
	WHERE
		cast(a.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
		AND cast(a.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
		AND cast(a.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
		AND cast(a.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
		--AND a.PU_USUARIO LIKE @RESPONSIBLE
	    AND ((@RESPONSIBLE = '%') OR (a.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ','))))
		AND (a.PJ_CLOSED_DATE BETWEEN @StartWeek and @EndWeek OR (a.PJ_CLOSED_DATE IS NULL AND YEAR(GETDATE()) <= YEAR(@EndWeek)))
			--a.PJ_CLOSED_DATE BETWEEN
			--ISNULL(CAST(CAST(DATEPART(YEAR, CAST(@ACTUAL_DATE AS DATETIME)) AS VARCHAR) + '-01-' + '01' AS DATETIME), CAST('1753-01-01'AS DATETIME))
			--AND ISNULL(CAST(CAST(DATEPART(YEAR, CAST(@ACTUAL_DATE AS DATETIME)) AS VARCHAR) + '-12-' + '31' AS DATETIME), CAST('9999-12-31' AS DATETIME))
		AND  CAST(A.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
		AND A.PRE_CODIGO IN ( SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME) )
		AND CAST(isnull(I.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	GROUP BY
		a.PJ_CODIGO, -- AS CODE,
		b.PA_DESCRICAO, -- AS CATEGORY,
		a.PJ_DESCRIPTION, -- AS DESCRIPTION,
		c.PU_NAME, -- AS RESPONSIBLE_NAME,
		d.PC_DESCRICAO, -- AS CUSTOMER,
		e.PL_DESCRICAO, -- AS LOCATION,
		a.PJ_OPEN_DATE, -- AS OPEN_DATE,
		a.PJ_COMMIT_DATE, -- AS COMMIT_DATE,
		a.PJ_CLOSED_DATE, -- AS CLOSED_DATE,
		f.PS_DESCRICAO, -- AS STATUS,
		a.PJ_REMARKS, -- AS REMARKS,
		DATEDIFF(DAY,a.PJ_COMMIT_DATE, a.PJ_CLOSED_DATE), -- AS PERFORMANCE_PLAIN,
		isnull(g.PG_DESCRICAO, '-'), -- AS SEGMENT,
		R.PRE_DESCRICAO, -- AS REGION,
		A.PJ_PERCENT_COMPLETION --AS PROGRESS
	ORDER BY
		c.PU_NAME,
		a.PJ_CODIGO DESC




GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer			Comments
-------------------------------------------------------------------------------
07-06-2007		Marcos Fernandes	Correção de quantidade de dados no relatório
06/01/2010		Marco Montebello	Adicinando os paramentros @StartWeek e @EndWeek, 
									além de alterar as respectivas ordens
*******************************************************************************
*/
ALTER       PROCEDURE [dbo].[SP_FIT_LIST_PROJECTS_GRAPH]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS	
	DECLARE @SUM_TOTAL	DECIMAL(30,2)
	IF (@ACTUAL_DATE = '%')
		SET @ACTUAL_DATE = NULL

	SELECT
		@SUM_TOTAL = COUNT(*)
	FROM
	(
	SELECT DISTINCT 
		a.PJ_CODIGO
	FROM
		TB_PT_PJ_PROJECTS a INNER JOIN TB_PT_PA_CATEGORY b
			ON a.PA_CODIGO = b.PA_CODIGO
		left JOIN TB_PT_PO_COSTSAVING C 
			ON A.PJ_CODIGO = C.PJ_CODIGO
		left JOIN TB_PT_PN_SAVINGCATEGORY D
			ON C.PN_CODIGO = D.PN_CODIGO
	WHERE
		cast(a.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
		AND cast(a.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
		AND cast(a.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
		AND cast(a.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
	    AND (@Responsible = '%' OR a.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
		--AND a.PU_USUARIO LIKE @RESPONSIBLE
		AND CAST(a.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
		AND a.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME))
		AND CAST(isnull(D.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	) x

	SELECT
		X.PA_DESCRICAO AS CATEGORY,
		COUNT(*) AS TOTAL,
		CAST(((COUNT(*) / @SUM_TOTAL) * 100) AS DECIMAL(30,2)) AS PERCENTAGE
	FROM
	(
	SELECT DISTINCT
		a.PJ_CODIGO,
		b.PA_CODIGO,
		b.PA_DESCRICAO
	FROM
		TB_PT_PJ_PROJECTS a INNER JOIN TB_PT_PA_CATEGORY b
			ON a.PA_CODIGO = b.PA_CODIGO
		left JOIN TB_PT_PO_COSTSAVING C 
			ON A.PJ_CODIGO = C.PJ_CODIGO
		left JOIN TB_PT_PN_SAVINGCATEGORY D
			ON C.PN_CODIGO = D.PN_CODIGO
	WHERE
		cast(a.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
		AND cast(a.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
		AND cast(a.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END
		AND a.PU_USUARIO LIKE @RESPONSIBLE
		AND PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek
			--ISNULL(CAST(CAST(DATEPART(YEAR, CAST(@ACTUAL_DATE AS DATETIME)) AS VARCHAR) + '-01-01' AS DATETIME), CAST('1753-01-01'AS DATETIME))
			--AND ISNULL(CAST(CAST(DATEPART(YEAR, CAST(@ACTUAL_DATE AS DATETIME)) AS VARCHAR) + '-12-31' AS DATETIME), CAST('9999-12-31' AS DATETIME))		
		AND CAST(a.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
		AND a.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME))
		AND CAST(isnull(D.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	) X
	GROUP BY
		X.PA_CODIGO,
		X.PA_DESCRICAO



GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer			Comments
-------------------------------------------------------------------------------
07-06-2007		Marcos Fernandes	Correção de quantidade de dados no relatório
06/01/2010		Marco Montebello	Adicinando os paramentros @StartWeek e @EndWeek, 
									além de alterar as respectivas ordens
*******************************************************************************
*/

ALTER PROCEDURE [dbo].[sp_FIT_LIST_PROJECTS_GRAPH_BY_YEAR]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS	

	DECLARE @SUM_TOTAL	DECIMAL(30,2)

	SELECT
		@SUM_TOTAL = COUNT(*)
	FROM
	(
	SELECT DISTINCT
		a.PA_CODIGO,
		A.PJ_CODIGO
	FROM
		TB_PT_PJ_PROJECTS a INNER JOIN TB_PT_PA_CATEGORY b
			ON a.PA_CODIGO = b.PA_CODIGO
		left JOIN TB_PT_PO_COSTSAVING C 
			ON A.PJ_CODIGO = C.PJ_CODIGO
		left JOIN TB_PT_PN_SAVINGCATEGORY D
			ON C.PN_CODIGO = D.PN_CODIGO
	WHERE
		a.PJ_CLOSED_DATE IS NOT NULL 
		AND GETDATE() > PJ_CLOSED_DATE
		AND cast(a.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
		AND cast(a.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
		AND cast(a.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
		AND cast(a.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
	    AND (@Responsible = '%' OR a.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
		--AND a.PU_USUARIO LIKE @RESPONSIBLE
		AND PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek
			--CAST(CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR) + '-01-' + '01' AS DATETIME) AND
			--CAST(CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR) + '-12-' + '31' AS DATETIME)
		AND CAST(a.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
		AND a.PRE_CODIGO IN ( SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME) )
		AND CAST(isnull(D.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	) X

	SELECT
		X.PA_DESCRICAO AS CATEGORY,
		COUNT(*) AS TOTAL,
		CAST(((COUNT(*) / CASE @SUM_TOTAL WHEN 0 THEN 1 ELSE @SUM_TOTAL END) * 100) AS DECIMAL(30,2)) AS PERCENTAGE
	FROM
	(
	SELECT DISTINCT
		A.PJ_CODIGO,
		b.PA_CODIGO,
		b.PA_DESCRICAO
	FROM
		TB_PT_PJ_PROJECTS a INNER JOIN TB_PT_PA_CATEGORY b
			ON a.PA_CODIGO = b.PA_CODIGO
		left JOIN TB_PT_PO_COSTSAVING C 
			ON A.PJ_CODIGO = C.PJ_CODIGO
		left JOIN TB_PT_PN_SAVINGCATEGORY D
			ON C.PN_CODIGO = D.PN_CODIGO
	WHERE
		cast(a.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
		AND cast(a.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
		AND cast(a.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
		AND a.PU_USUARIO LIKE @RESPONSIBLE
		AND PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek 
			--CAST(CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR) + '-01-' + '01' AS DATETIME) AND
			--CAST(CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR) + '-12-' + '31' AS DATETIME)
		AND CAST(a.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
		AND a.PRE_CODIGO IN ( SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME) )
		AND CAST(isnull(D.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	) X
	GROUP BY
		X.PA_CODIGO,
		X.PA_DESCRICAO



GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer		Comments
-------------------------------------------------------------------------------
06/01/2010		Marco Montebello	Adicinando os paramentros @StartWeek e @EndWeek, 
									além de alterar as respectivas ordens
*******************************************************************************
*/

ALTER PROCEDURE [dbo].[sp_FIT_LIST_PROJECTS_GRAPH_BY_YEAR_AND_OPEN]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS	

	-- CORRIGIR VALOR DO ACTUAL_DATE
	IF (@ACTUAL_DATE = '%')
		SET @ACTUAL_DATE = GETDATE()

	DECLARE @SUM_TOTAL	DECIMAL(30,2)

	SELECT
		@SUM_TOTAL = COUNT(*)
	FROM
	(
	SELECT DISTINCT 
		A.PJ_CODIGO,
		a.PA_CODIGO
	FROM
		TB_PT_PJ_PROJECTS a INNER JOIN TB_PT_PA_CATEGORY b
			ON a.PA_CODIGO = b.PA_CODIGO
		left JOIN TB_PT_PO_COSTSAVING C 
			ON A.PJ_CODIGO = C.PJ_CODIGO
		left JOIN TB_PT_PN_SAVINGCATEGORY D
			ON C.PN_CODIGO = D.PN_CODIGO
	WHERE
		PJ_CLOSED_DATE IS NOT NULL 
		AND GETDATE() > PJ_CLOSED_DATE
		AND cast(a.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
		AND cast(a.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
		AND cast(a.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
		AND cast(a.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
	    AND (@Responsible = '%' OR a.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
		--AND a.PU_USUARIO LIKE @RESPONSIBLE
		AND PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek
			--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-01-' + '01' AS DATETIME) AND
			--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-12-' + '31' AS DATETIME)
		AND CAST(a.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
		AND a.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME))
		AND CAST(isnull(D.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	) X

	SELECT
		X.PA_DESCRICAO AS CATEGORY,
		COUNT(*) AS TOTAL,
		CAST(((COUNT(*) / @SUM_TOTAL) * 100) AS DECIMAL(30,2)) AS PERCENTAGE
	FROM
	(
	SELECT DISTINCT
		b.PA_CODIGO,
		b.PA_DESCRICAO,
		A.PJ_CODIGO
	FROM
		TB_PT_PJ_PROJECTS a INNER JOIN TB_PT_PA_CATEGORY b
			ON a.PA_CODIGO = b.PA_CODIGO
		left JOIN TB_PT_PO_COSTSAVING C 
			ON A.PJ_CODIGO = C.PJ_CODIGO
		left JOIN TB_PT_PN_SAVINGCATEGORY D
			ON C.PN_CODIGO = D.PN_CODIGO
	WHERE
		PJ_CLOSED_DATE IS NOT NULL 
		AND GETDATE() > PJ_CLOSED_DATE
		AND cast(a.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
		AND cast(a.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
		AND cast(a.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
	    AND (@Responsible = '%' OR A.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
		--AND a.PU_USUARIO LIKE @RESPONSIBLE
		AND PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek
			--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-01-' + '01' AS DATETIME) AND
			--CAST(CAST(DATEPART(YEAR, @ACTUAL_DATE) AS VARCHAR) + '-12-' + '31' AS DATETIME)
		AND CAST(a.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
		AND a.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME))
		AND CAST(isnull(D.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	)X
	GROUP BY
		X.PA_CODIGO,
		X.PA_DESCRICAO




GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer			Comments
-------------------------------------------------------------------------------
07-06-2007		Marcos Fernandes	Correção de quantidade de dados no relatório
06/01/2010		Marco Montebello	Adicinando os paramentros @StartWeek e @EndWeek, 
									além de alterar as respectivas ordens

*******************************************************************************
*/

ALTER      PROCEDURE [dbo].[sp_FIT_TOTAL_PROJECTS]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS	
	DECLARE
		@TOTAL INT
	-- TOTAL PROJETOS
	IF (@ACTUAL_DATE = '%')
		SET @ACTUAL_DATE = NULL

	SELECT	
		@TOTAL = COUNT(*)
	FROM
	(
	SELECT DISTINCT 
		P.PJ_CODIGO
	FROM
		TB_PT_PJ_PROJECTS P left JOIN TB_PT_PO_COSTSAVING A 
			ON P.PJ_CODIGO = A.PJ_CODIGO
		left JOIN TB_PT_PN_SAVINGCATEGORY B
			ON A.PN_CODIGO = B.PN_CODIGO
	WHERE 
		cast(P.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
		AND cast(P.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
		AND cast(P.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
		AND cast(P.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
	    AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
		--AND P.PU_USUARIO LIKE @RESPONSIBLE
		AND P.PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek
				--ISNULL(CAST(CAST(DATEPART(YEAR, CAST(@ACTUAL_DATE AS DATETIME)) AS VARCHAR) + '-01-01' AS DATETIME), CAST('1753-01-01'AS DATETIME))
				--AND ISNULL(CAST(CAST(DATEPART(YEAR, CAST(@ACTUAL_DATE AS DATETIME)) AS VARCHAR) + '-12-31' AS DATETIME), CAST('9999-12-31' AS DATETIME))
		AND CAST(P.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END 
		AND P.PRE_CODIGO IN ( SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME) )
		AND CAST(isnull(B.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	) X

	SELECT @TOTAL  AS TOTAL_PROJECTS
	RETURN @TOTAL



GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



/*
***************************************************************************
Author:			Elton Souza
Creation Date:	05/16/2007
Description:	
      
Script Version:	1.0
Parameter:	
		
Output:		
Is used: 
ModifiedHistory: 
Date			Developer			Comments
-------------------------------------------------------------------------------
07/10/2007		Marcos Fernandes	Corrigindo quantidades incorretas
06/01/2010		Marco Montebello	Adicinando os paramentros @StartWeek e @EndWeek, 
									além de alterar as respectivas ordens
*******************************************************************************
*/

ALTER PROCEDURE [dbo].[SP_FIT_TOTAL_PROJECTS_BY_YEAR]
	/*
	@STATUS			INT,
	@RESPONSIBLE	VARCHAR(8),
	@CUSTOMER		INT,
	@LOCATION		INT,
	@ACTUAL_DATE	VARCHAR(255),
	@REGION			INT,
	@SEGMENT		INT,
	@USERNAME		VARCHAR(8)
	*/
	@Region			INT,
	@Customer		INT,
	@Location		INT,
	@Responsible	VARCHAR(MAX),
	@Status			INT,
	@Actual_Date	VARCHAR(255),
	@StartWeek		datetime,
	@EndWeek		datetime,
	@Segment		INT,
	@UserName		VARCHAR(8),
	@SavingCategory	INT
AS	

	-- CORRIGIR VALOR DO ACTUAL_DATE
	IF (@ACTUAL_DATE = '%')
		SET @ACTUAL_DATE = GETDATE()

	DECLARE
		@TOTAL INT
	-- TOTAL PROJETOS
	SELECT
		@TOTAL = COUNT(*)
	FROM 
	(
	SELECT DISTINCT 
		P.PJ_CODIGO
	FROM
		TB_PT_PJ_PROJECTS P left JOIN TB_PT_PO_COSTSAVING A 
			ON P.PJ_CODIGO = A.PJ_CODIGO
		left JOIN TB_PT_PN_SAVINGCATEGORY B
			ON A.PN_CODIGO = B.PN_CODIGO
	WHERE 
		cast(P.PS_CODIGO as varchar) LIKE CASE WHEN @STATUS <= 0 THEN '%' ELSE cast(@STATUS as varchar) END										
		AND cast(P.PC_CODIGO as varchar) LIKE CASE WHEN @CUSTOMER <= 0 THEN '%' ELSE cast(@CUSTOMER as varchar) END
		AND cast(P.PL_CODIGO as varchar) LIKE CASE WHEN @LOCATION <= 0 THEN '%' ELSE cast(@LOCATION as varchar) END	
		AND cast(P.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
	    AND (@Responsible = '%' OR P.PU_USUARIO IN (SELECT item FROM dbo.SplitVarchar(@Responsible, ',')))
		--AND P.PU_USUARIO LIKE @RESPONSIBLE
		AND P.PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek
			--CAST(CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR) + '-01-' + '01' AS DATETIME) AND
			--CAST(CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR) + '-12-' + '31' AS DATETIME)
		AND CAST(P.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
		AND P.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME))
		AND CAST(isnull(B.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	)x

	SELECT @TOTAL AS TOTAL_PROJECTS
	RETURN @TOTAL


GO