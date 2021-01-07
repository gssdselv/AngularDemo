CREATE TABLE [dbo].[ProjectTechEvalDetail] (
    [ProjectTechEvalDetailId] BIGINT             IDENTITY (1, 1) NOT NULL,
    [ProjectDetailId]         BIGINT             NOT NULL,
    [TechDescription]         VARCHAR (500)      NOT NULL,
    [Amount]                  DECIMAL (18)       NOT NULL,
    [TechEvalOpenDate]        DATETIMEOFFSET (7) NOT NULL,
    [TechEvalCloseDate]       DATETIMEOFFSET (7) NULL,
    [Report]                  VARCHAR (100)      NOT NULL,
    [RecordStatus]            CHAR (1)           NOT NULL,
    [CreatedBy]               BIGINT             NOT NULL,
    [CreatedDate]             DATETIMEOFFSET (7) NOT NULL,
    [ModifiedBy]              BIGINT             NOT NULL,
    [ModifiedDate]            DATETIMEOFFSET (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([ProjectTechEvalDetailId] ASC),
    CONSTRAINT [FK_ProjectTechEvalDetail_To_ProjectDetail] FOREIGN KEY ([ProjectDetailId]) REFERENCES [dbo].[ProjectDetail] ([ProjectDetailId]),
    CONSTRAINT [FK_ProjectTechEvalDetail_To_User_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserId]),
    CONSTRAINT [FK_ProjectTechEvalDetail_To_user_ModiifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserId])
);

