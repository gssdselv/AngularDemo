CREATE TABLE [dbo].[ProjectDecision] (
    [ProjectDecisionId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [ProjectDecisionName] VARCHAR (100) NOT NULL,
    [RecordStatus]        CHAR (1)      NOT NULL,
    PRIMARY KEY CLUSTERED ([ProjectDecisionId] ASC)
);

