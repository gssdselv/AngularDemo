CREATE TABLE [dbo].[Stage] (
    [StageId]      BIGINT         IDENTITY (1, 1) NOT NULL,
    [StageName]    NVARCHAR (100) NOT NULL,
    [RecordStatus] CHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([StageId] ASC)
);

