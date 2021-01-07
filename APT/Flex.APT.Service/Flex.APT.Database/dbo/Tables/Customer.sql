CREATE TABLE [dbo].[Customer] (
    [CustomerId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [CustomerName] NVARCHAR (100) NOT NULL,
    [CustomerCode] NVARCHAR (50)  NULL,
    [RecordStatus] CHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([CustomerId] ASC)
);

