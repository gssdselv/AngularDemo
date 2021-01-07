CREATE TABLE [dbo].[SupplierScoreCard] (
    [SupplierScoreCardId]    BIGINT         IDENTITY (1, 1) NOT NULL,
    [SupplierScoreCardName]  NVARCHAR (200) NOT NULL,
    [SupplierScoreCardScore] INT            NOT NULL,
    [SupplierScoreCardType]  NVARCHAR (200) NOT NULL,
    [RecordStatus]           CHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([SupplierScoreCardId] ASC)
);

