CREATE TABLE [dbo].[User] (
    [UserId]       BIGINT             IDENTITY (1, 1) NOT NULL,
    [UserADID]     VARCHAR (30)       NOT NULL,
    [Email]        VARCHAR (100)      NOT NULL,
    [Name]         VARCHAR (200)      NULL,
    [RegionId]     BIGINT             NOT NULL,
    [CreatedDate]  DATETIMEOFFSET (7) NULL,
    [RecordStatus] CHAR (1)           NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC),
    CONSTRAINT [FK_User_To_Region] FOREIGN KEY ([RegionId]) REFERENCES [dbo].[Region] ([RegionId]),
    UNIQUE NONCLUSTERED ([Email] ASC),
    UNIQUE NONCLUSTERED ([UserADID] ASC)
);

