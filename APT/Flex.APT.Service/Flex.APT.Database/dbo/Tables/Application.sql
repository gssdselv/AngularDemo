CREATE TABLE [dbo].[Application] (
    [ApplicationId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [ApplicationName] VARCHAR (100) NOT NULL,
    [ApplicationCode] VARCHAR (50)  NOT NULL,
    [RecordStatus]    CHAR (1)      NOT NULL,
    PRIMARY KEY CLUSTERED ([ApplicationId] ASC)
);

