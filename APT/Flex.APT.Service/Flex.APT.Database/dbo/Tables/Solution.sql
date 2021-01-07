CREATE TABLE [dbo].[Solution] (
    [SolutionId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [SolutionName] VARCHAR (100) NOT NULL,
    [RecordStatus] CHAR (1)      NOT NULL,
    PRIMARY KEY CLUSTERED ([SolutionId] ASC)
);

