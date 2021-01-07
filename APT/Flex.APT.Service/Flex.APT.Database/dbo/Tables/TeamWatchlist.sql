CREATE TABLE [dbo].[TeamWatchlist] (
    [TeamWatchlistId] BIGINT             IDENTITY (1, 1) NOT NULL,
    [ProjectDetailId] BIGINT             NOT NULL,
    [UserId]          BIGINT             NULL,
    [TypeName]        VARCHAR (100)      NOT NULL,
    [CreatedBy]       BIGINT             NOT NULL,
    [CreatedDate]     DATETIMEOFFSET (7) NOT NULL,
    [ModifiedBy]      BIGINT             NULL,
    [ModifiedDate]    DATETIMEOFFSET (7) NULL,
    [RecordStatus]    CHAR (1)           NOT NULL,
    PRIMARY KEY CLUSTERED ([TeamWatchlistId] ASC),
    CONSTRAINT [FK_TeamWatchlist_To_ProjectDetail] FOREIGN KEY ([ProjectDetailId]) REFERENCES [dbo].[ProjectDetail] ([ProjectDetailId]),
    CONSTRAINT [FK_TeamWatchlist_To_User_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserId]),
    CONSTRAINT [FK_TeamWatchlist_To_user_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserId]),
    CONSTRAINT [FK_TeamWatchlist_To_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([UserId])
);

