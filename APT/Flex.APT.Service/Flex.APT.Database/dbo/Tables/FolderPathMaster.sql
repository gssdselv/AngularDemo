CREATE TABLE [dbo].[FolderPathMaster] (
    [FolderPathMasterId]   BIGINT             IDENTITY (1, 1) NOT NULL,
    [FolderPathMasterName] VARCHAR (100)      NULL,
    [Path]                 VARCHAR (100)      NULL,
    [CreatedBy]            BIGINT             NULL,
    [CreatedDate]          DATETIMEOFFSET (7) NOT NULL,
    [ModifiedBy]           BIGINT             NULL,
    [ModifiedDate]         DATETIMEOFFSET (7) NULL,
    [RecordStatus]         CHAR (1)           NOT NULL,
    PRIMARY KEY CLUSTERED ([FolderPathMasterId] ASC),
    CONSTRAINT [FK_ProjectTechEvalDetails_To_User_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserId]),
    CONSTRAINT [FK_ProjectTechEvalDetails_To_user_ModiifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserId])
);

