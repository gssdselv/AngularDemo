CREATE TABLE [dbo].[FinancialCategory] (
    [FinancialCategoryId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [FinancialCategoryName] VARCHAR (100) NOT NULL,
    [RecordStatus]          CHAR (1)      NOT NULL,
    PRIMARY KEY CLUSTERED ([FinancialCategoryId] ASC)
);

