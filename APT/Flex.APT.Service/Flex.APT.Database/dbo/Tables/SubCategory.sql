CREATE TABLE [dbo].[SubCategory] (
    [SubCategoryId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [SubCategoryName] NVARCHAR (100) NOT NULL,
    [RecordStatus]    CHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([SubCategoryId] ASC)
);

