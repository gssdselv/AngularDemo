CREATE TABLE [dbo].[PaidBy] (
    [PaidById]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [PaidByName]   NVARCHAR (100) NOT NULL,
    [RecordStatus] CHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([PaidById] ASC)
);

