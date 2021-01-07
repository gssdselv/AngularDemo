CREATE TABLE [dbo].[Role] (
    [RoleId]       BIGINT        IDENTITY (1, 1) NOT NULL,
    [RoleName]     VARCHAR (100) NOT NULL,
    [Description]  VARCHAR (100) NULL,
    [RecordStatus] CHAR (1)      NOT NULL,
    PRIMARY KEY CLUSTERED ([RoleId] ASC)
);

