CREATE PROCEDURE [dbo].[GET_ALL_CUSTOMER]
AS
	
	SELECT 
	[CustomerId]
	,[CustomerName]
	FROM [dbo].[Customer]
	WHERE RecordStatus = 'A'

RETURN 0
