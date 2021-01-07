CREATE TABLE [dbo].[ProjectHistory] (
    [ProjectHistoryId] BIGINT             IDENTITY (1, 1) NOT NULL,
    [ProjectDetailId]  BIGINT             NOT NULL,
    [StageId]          BIGINT             NOT NULL,
    [CreatedBy]        BIGINT             NOT NULL,
    [CreatedDate]      DATETIMEOFFSET (7) NOT NULL,
    [ModifiedBy]       BIGINT             NULL,
    [ModifiedDate]     DATETIMEOFFSET (7) NULL,
    [RecordStatus]     CHAR (1)           NOT NULL,
    [Comment]          VARCHAR (500)      NULL,
    PRIMARY KEY CLUSTERED ([ProjectHistoryId] ASC),
    CONSTRAINT [FK_ProjectHistory_To_ProjectDetail] FOREIGN KEY ([ProjectDetailId]) REFERENCES [dbo].[ProjectDetail] ([ProjectDetailId]),
    CONSTRAINT [FK_ProjectHistory_To_Stage] FOREIGN KEY ([StageId]) REFERENCES [dbo].[Stage] ([StageId]),
    CONSTRAINT [FK_ProjectHistory_To_User_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserId]),
    CONSTRAINT [FK_ProjectHistory_To_user_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserId])
);

