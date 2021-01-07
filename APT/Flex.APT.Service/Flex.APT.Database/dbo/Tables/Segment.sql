CREATE TABLE [dbo].[Segment] (
    [SegmentId]    BIGINT         IDENTITY (1, 1) NOT NULL,
    [SegmentName]  NVARCHAR (100) NOT NULL,
    [RecordStatus] CHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([SegmentId] ASC)
);

