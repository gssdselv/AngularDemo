CREATE TABLE [dbo].[QuoteRevision] (
    [QuoteRevisionId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [QuoteRevisionName] VARCHAR (100) NOT NULL,
    [RecordStatus]      CHAR (1)      NOT NULL,
    PRIMARY KEY CLUSTERED ([QuoteRevisionId] ASC)
);

