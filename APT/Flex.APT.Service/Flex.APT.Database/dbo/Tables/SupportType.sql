CREATE TABLE [dbo].[SupportType] (
    [SupportTypeId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [SupportTypeName] NVARCHAR (100) NOT NULL,
    [RecordStatus]    CHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([SupportTypeId] ASC)
);

