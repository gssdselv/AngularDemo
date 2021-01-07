CREATE TABLE [dbo].[Supplier] (
    [SupplierId]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [SupplierCompanyName] VARCHAR (200) NULL,
    [SupplierScore]       DECIMAL (18)  NULL,
    [SupplierContactCode] VARCHAR (50)  NOT NULL,
    [RecordStatus]        CHAR (1)      NOT NULL,
    PRIMARY KEY CLUSTERED ([SupplierId] ASC)
);

