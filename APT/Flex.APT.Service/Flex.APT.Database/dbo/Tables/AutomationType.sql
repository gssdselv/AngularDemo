CREATE TABLE [dbo].[AutomationType] (
    [AutomationTypeId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [AutomationTypeName] VARCHAR (100) NOT NULL,
    [RecordStatus]       CHAR (1)      NOT NULL,
    PRIMARY KEY CLUSTERED ([AutomationTypeId] ASC)
);

