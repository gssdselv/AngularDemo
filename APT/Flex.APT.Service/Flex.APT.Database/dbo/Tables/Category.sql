CREATE TABLE [dbo].[Category] (
    [CategoryId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [CategoryName] NVARCHAR (100) NOT NULL,
    [RecordStatus] CHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([CategoryId] ASC)
);

