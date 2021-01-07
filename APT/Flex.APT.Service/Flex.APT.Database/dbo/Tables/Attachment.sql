CREATE TABLE [dbo].[Attachment] (
    [AttachmentId]       BIGINT             IDENTITY (1, 1) NOT NULL,
    [AttachmentName]     VARCHAR (500)      NOT NULL,
    [FilePath]           VARCHAR (500)      NOT NULL,
    [FolderPathMasterId] BIGINT             NOT NULL,
    [ProjectDetailId]    BIGINT             NOT NULL,
    [CreatedBy]          BIGINT             NOT NULL,
    [CreatedDate]        DATETIMEOFFSET (7) NOT NULL,
    [ModifiedBy]         BIGINT             NULL,
    [ModifiedDate]       DATETIMEOFFSET (7) NULL,
    [RecordStatus]       CHAR (1)           NOT NULL,
    [Comment]            VARCHAR (500)      NULL,
    PRIMARY KEY CLUSTERED ([AttachmentId] ASC),
    CONSTRAINT [FK_Attachment_To_FolderPathMaster] FOREIGN KEY ([FolderPathMasterId]) REFERENCES [dbo].[FolderPathMaster] ([FolderPathMasterId]),
    CONSTRAINT [FK_Attachment_To_ProjectDetail] FOREIGN KEY ([ProjectDetailId]) REFERENCES [dbo].[ProjectDetail] ([ProjectDetailId]),
    CONSTRAINT [FK_Attachment_To_User_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserId]),
    CONSTRAINT [FK_Attachment_To_user_ModiifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserId])
);

