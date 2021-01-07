CREATE TABLE [dbo].[ProjectFinancialJustification] (
    [ProjectFinancialJustificationId] BIGINT             IDENTITY (1, 1) NOT NULL,
    [FinancialCategoryId]             BIGINT             NOT NULL,
    [Amount]                          DECIMAL (18)       NOT NULL,
    [ProjectDetailId]                 BIGINT             NOT NULL,
    [CreatedBy]                       BIGINT             NOT NULL,
    [CreatedDate]                     DATETIMEOFFSET (7) NOT NULL,
    [ModifiedBy]                      BIGINT             NULL,
    [ModifiedDate]                    DATETIMEOFFSET (7) NULL,
    [RecordStatus]                    CHAR (1)           NOT NULL,
    PRIMARY KEY CLUSTERED ([ProjectFinancialJustificationId] ASC),
    CONSTRAINT [FK_ProjectFinancialJustification_To_FinancialCategory] FOREIGN KEY ([FinancialCategoryId]) REFERENCES [dbo].[FinancialCategory] ([FinancialCategoryId]),
    CONSTRAINT [FK_ProjectFinancialJustification_To_ProjectDetail] FOREIGN KEY ([ProjectDetailId]) REFERENCES [dbo].[ProjectDetail] ([ProjectDetailId]),
    CONSTRAINT [FK_ProjectFinancialJustification_To_User_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User] ([UserId]),
    CONSTRAINT [FK_ProjectFinancialJustification_To_user_ModiifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[User] ([UserId])
);

