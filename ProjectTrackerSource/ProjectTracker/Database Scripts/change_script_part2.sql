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
	@Responsible	VARCHAR(8),
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
		AND a.PU_USUARIO LIKE @RESPONSIBLE
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

USE [Engr]
GO
/****** Object:  StoredProcedure [dbo].[SP_FIT_LIST_PROJECTS_GRAPH]    Script Date: 07/06/2010 14:16:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	@Responsible	VARCHAR(8),
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
		AND a.PU_USUARIO LIKE @RESPONSIBLE
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
		--AND PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek
		AND (PJ_CLOSED_DATE BETWEEN @StartWeek and @EndWeek OR (PJ_CLOSED_DATE IS NULL AND YEAR(GETDATE()) <= YEAR(@EndWeek)))
			--ISNULL(CAST(CAST(DATEPART(YEAR, CAST(@ACTUAL_DATE AS DATETIME)) AS VARCHAR) + '-01-01' AS DATETIME), CAST('1753-01-01'AS DATETIME))
			--AND ISNULL(CAST(CAST(DATEPART(YEAR, CAST(@ACTUAL_DATE AS DATETIME)) AS VARCHAR) + '-12-31' AS DATETIME), CAST('9999-12-31' AS DATETIME))		
		AND CAST(a.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
		AND a.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME))
		AND CAST(isnull(D.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	) X
	GROUP BY
		X.PA_CODIGO,
		X.PA_DESCRICAO

Go


USE [Engr]
GO
/****** Object:  StoredProcedure [dbo].[sp_FIT_LIST_PROJECTS_GRAPH_BY_YEAR]    Script Date: 07/06/2010 14:19:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	@Responsible	VARCHAR(8),
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
		AND a.PU_USUARIO LIKE @RESPONSIBLE
		AND (PJ_CLOSED_DATE BETWEEN @StartWeek and @EndWeek OR (PJ_CLOSED_DATE IS NULL AND YEAR(GETDATE()) <= YEAR(@EndWeek)))
		--AND PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek
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
		AND (PJ_CLOSED_DATE BETWEEN @StartWeek and @EndWeek OR (PJ_CLOSED_DATE IS NULL AND YEAR(GETDATE()) <= YEAR(@EndWeek)))
		--AND PJ_OPEN_DATE BETWEEN @StartWeek and @EndWeek 
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
	@Responsible	VARCHAR(8),
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
		AND P.PU_USUARIO LIKE @RESPONSIBLE
		AND (PJ_CLOSED_DATE BETWEEN @StartWeek and @EndWeek OR (PJ_CLOSED_DATE IS NULL AND YEAR(GETDATE()) <= YEAR(@EndWeek)))
		AND CAST(P.PRE_CODIGO AS VARCHAR) LIKE CASE WHEN @REGION <= 0 THEN '%' ELSE CAST(@REGION AS VARCHAR) END
		AND cast(P.PG_CODIGO as varchar) LIKE CASE WHEN @SEGMENT <= 0 THEN '%' ELSE cast(@SEGMENT as varchar) END	
		AND P.PRE_CODIGO IN (SELECT PRE_CODIGO FROM dbo.SP_FIT_PT_GET_USER_REGIONS(@USERNAME))
		AND CAST(isnull(B.PN_CODIGO, '') as varchar) LIKE CASE WHEN @SavingCategory <= 0 THEN '%' ELSE CAST(@SavingCategory as varchar) END	
	GROUP BY 
		DATEPART(year, PJ_CLOSED_DATE)


