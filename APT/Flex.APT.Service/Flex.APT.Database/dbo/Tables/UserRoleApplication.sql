CREATE TABLE [dbo].[UserRoleApplication] (
    [UserRoleApplicationId] BIGINT             IDENTITY (1, 1) NOT NULL,
    [UserId]                BIGINT             NOT NULL,
    [RoleId]                BIGINT             NOT NULL,
    [ApplicationId]         BIGINT             NOT NULL,
    [RecordStatus]          CHAR (1)           NOT NULL,
    [CreatedBy]             BIGINT             NOT NULL,
    [CreatedDate]           DATETIMEOFFSET (7) NOT NULL,
    [ModifiedBy]            BIGINT             NOT NULL,
    [ModifiedDate]          DATETIMEOFFSET (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([UserRoleApplicationId] ASC),
    CONSTRAINT [FK_UserRoleApplication_To_Application] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Application] ([ApplicationId]),
    CONSTRAINT [FK_UserRoleApplication_To_Role] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Role] ([RoleId]),
    CONSTRAINT [FK_UserRoleApplication_To_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([UserId])
);

