-- Physical SQL Server warehouse schema, exported from metadata on 2026-11-24.

-- Run in an empty development database. Loading is performed by SSIS.

SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER ON;

GO

CREATE TABLE [dbo].[dim_client] (
    [Company_Id] int NOT NULL,
    [Nom] nvarchar(200) NULL,
    [TypeClient] nvarchar(30) NOT NULL,
    [EstClientIdentifie] bit NOT NULL,
    [Client_SK] int IDENTITY(1,1) NOT NULL
);
GO

ALTER TABLE dbo.[dim_client] ADD CONSTRAINT [PK_dim_client] PRIMARY KEY ([Client_SK]);
GO

ALTER TABLE dbo.[dim_client] ADD CONSTRAINT [UQ_dim_client_business] UNIQUE ([Company_Id]);
GO

CREATE TABLE [dbo].[dim_fournisseur] (
    [Fournisseur_Id] int NOT NULL,
    [Nom] nvarchar(200) NULL,
    [Fournisseur_SK] int IDENTITY(1,1) NOT NULL
);
GO

ALTER TABLE dbo.[dim_fournisseur] ADD CONSTRAINT [PK_dim_fournisseur] PRIMARY KEY ([Fournisseur_SK]);
GO

ALTER TABLE dbo.[dim_fournisseur] ADD CONSTRAINT [UQ_dim_fournisseur_business] UNIQUE ([Fournisseur_Id]);
GO

CREATE TABLE [dbo].[dim_paiement] (
    [PaymentMode_Id] int NOT NULL,
    [PaymentModeName] nvarchar(50) NOT NULL,
    [Paiement_SK] int IDENTITY(1,1) NOT NULL
);
GO

ALTER TABLE dbo.[dim_paiement] ADD CONSTRAINT [PK_dim_paiement] PRIMARY KEY ([Paiement_SK]);
GO

ALTER TABLE dbo.[dim_paiement] ADD CONSTRAINT [UQ_dim_paiement_business] UNIQUE ([PaymentMode_Id]);
GO

CREATE TABLE [dbo].[dim_produit] (
    [Product_Id] int NOT NULL,
    [Libelle] nvarchar(255) NULL,
    [Famille] nvarchar(100) NOT NULL,
    [Marque] nvarchar(100) NOT NULL,
    [Produit_SK] int IDENTITY(1,1) NOT NULL
);
GO

ALTER TABLE dbo.[dim_produit] ADD CONSTRAINT [PK_dim_produit] PRIMARY KEY ([Produit_SK]);
GO

ALTER TABLE dbo.[dim_produit] ADD CONSTRAINT [UQ_dim_produit_business] UNIQUE ([Product_Id]);
GO

CREATE TABLE [dbo].[dim_temps] (
    [DateKey] int NOT NULL,
    [Date] date NOT NULL,
    [Annee] smallint NOT NULL,
    [Trimestre] tinyint NOT NULL,
    [Mois] tinyint NOT NULL,
    [SemaineISO] tinyint NOT NULL,
    [EstFerie] bit NOT NULL
);
GO

ALTER TABLE dbo.[dim_temps] ADD CONSTRAINT [PK__dim_temp__40DF45E3B3C563E3] PRIMARY KEY ([DateKey]);
GO

CREATE TABLE [dbo].[fait_achats] (
    [Id] bigint NOT NULL,
    [Document_Id] bigint NOT NULL,
    [DateKey] int NOT NULL,
    [Product_Id] int NOT NULL,
    [Fournisseur_Id] int NOT NULL,
    [QuantiteAchetee] decimal(18,4) NOT NULL,
    [MontantAchat_HT] decimal(18,4) NOT NULL,
    [Produit_SK] int NOT NULL,
    [Fournisseur_SK] int NOT NULL
);
GO

ALTER TABLE dbo.[fait_achats] ADD CONSTRAINT [PK_fait_achats] PRIMARY KEY ([Id]);
GO

CREATE TABLE [dbo].[fait_decaissements] (
    [Id] bigint NOT NULL,
    [Payment_Id] bigint NOT NULL,
    [Document_Id] bigint NULL,
    [DateKey] int NOT NULL,
    [PaymentMode_Id] int NOT NULL,
    [Fournisseur_Id] int NOT NULL,
    [Amount] decimal(18,4) NOT NULL,
    [Paiement_SK] int NOT NULL,
    [Fournisseur_SK] int NOT NULL
);
GO

ALTER TABLE dbo.[fait_decaissements] ADD CONSTRAINT [PK_fait_decaissements] PRIMARY KEY ([Id]);
GO

CREATE TABLE [dbo].[fait_encaissements] (
    [Id] bigint NOT NULL,
    [Payment_Id] bigint NOT NULL,
    [Document_Id] bigint NULL,
    [DateKey] int NOT NULL,
    [PaymentMode_Id] int NOT NULL,
    [Company_Id] int NOT NULL,
    [Amount] decimal(18,4) NOT NULL,
    [Client_SK] int NOT NULL,
    [Paiement_SK] int NOT NULL
);
GO

ALTER TABLE dbo.[fait_encaissements] ADD CONSTRAINT [PK_fait_encaissements] PRIMARY KEY ([Id]);
GO

CREATE TABLE [dbo].[fait_stock_actuel] (
    [Product_Id] int NOT NULL,
    [DateKey] int NULL,
    [QuantiteActuelle] decimal(18,4) NOT NULL,
    [QuantiteAlerte] decimal(18,4) NULL,
    [EstSousSeuil] bit NULL,
    [Produit_SK] int NOT NULL
);
GO

ALTER TABLE dbo.[fait_stock_actuel] ADD CONSTRAINT [PK_fait_stock_actuel] PRIMARY KEY ([Produit_SK]);
GO

ALTER TABLE dbo.[fait_stock_actuel] ADD CONSTRAINT [UQ_fait_stock_actuel_product] UNIQUE ([Product_Id]);
GO

CREATE TABLE [dbo].[fait_ventes] (
    [Id] bigint NOT NULL,
    [Document_Id] bigint NOT NULL,
    [DateKey] int NOT NULL,
    [Product_Id] int NOT NULL,
    [Company_Id] int NOT NULL,
    [QuantiteVendue] decimal(18,4) NOT NULL,
    [Remise_HT] decimal(18,4) NOT NULL,
    [CA_HT] decimal(18,4) NOT NULL,
    [Cout_HT] decimal(18,4) NULL,
    [Produit_SK] int NOT NULL,
    [Client_SK] int NOT NULL
);
GO

ALTER TABLE dbo.[fait_ventes] ADD CONSTRAINT [PK_fait_ventes] PRIMARY KEY ([Id]);
GO

ALTER TABLE dbo.[fait_encaissements] WITH CHECK ADD CONSTRAINT [FK_encaissements_client] FOREIGN KEY ([Client_SK]) REFERENCES dbo.[dim_client] ([Client_SK]);
GO

ALTER TABLE dbo.[fait_ventes] WITH CHECK ADD CONSTRAINT [FK_ventes_client] FOREIGN KEY ([Client_SK]) REFERENCES dbo.[dim_client] ([Client_SK]);
GO

ALTER TABLE dbo.[fait_achats] WITH CHECK ADD CONSTRAINT [FK_achats_fournisseur] FOREIGN KEY ([Fournisseur_SK]) REFERENCES dbo.[dim_fournisseur] ([Fournisseur_SK]);
GO

ALTER TABLE dbo.[fait_decaissements] WITH CHECK ADD CONSTRAINT [FK_decaissements_fournisseur] FOREIGN KEY ([Fournisseur_SK]) REFERENCES dbo.[dim_fournisseur] ([Fournisseur_SK]);
GO

ALTER TABLE dbo.[fait_decaissements] WITH CHECK ADD CONSTRAINT [FK_decaissements_paiement] FOREIGN KEY ([Paiement_SK]) REFERENCES dbo.[dim_paiement] ([Paiement_SK]);
GO

ALTER TABLE dbo.[fait_encaissements] WITH CHECK ADD CONSTRAINT [FK_encaissements_paiement] FOREIGN KEY ([Paiement_SK]) REFERENCES dbo.[dim_paiement] ([Paiement_SK]);
GO

ALTER TABLE dbo.[fait_achats] WITH CHECK ADD CONSTRAINT [FK_achats_produit] FOREIGN KEY ([Produit_SK]) REFERENCES dbo.[dim_produit] ([Produit_SK]);
GO

ALTER TABLE dbo.[fait_stock_actuel] WITH CHECK ADD CONSTRAINT [FK_stock_produit] FOREIGN KEY ([Produit_SK]) REFERENCES dbo.[dim_produit] ([Produit_SK]);
GO

ALTER TABLE dbo.[fait_ventes] WITH CHECK ADD CONSTRAINT [FK_ventes_produit] FOREIGN KEY ([Produit_SK]) REFERENCES dbo.[dim_produit] ([Produit_SK]);
GO

ALTER TABLE dbo.[fait_achats] WITH CHECK ADD CONSTRAINT [FK_achats_temps] FOREIGN KEY ([DateKey]) REFERENCES dbo.[dim_temps] ([DateKey]);
GO

ALTER TABLE dbo.[fait_decaissements] WITH CHECK ADD CONSTRAINT [FK_decaissements_temps] FOREIGN KEY ([DateKey]) REFERENCES dbo.[dim_temps] ([DateKey]);
GO

ALTER TABLE dbo.[fait_encaissements] WITH CHECK ADD CONSTRAINT [FK_encaissements_temps] FOREIGN KEY ([DateKey]) REFERENCES dbo.[dim_temps] ([DateKey]);
GO

ALTER TABLE dbo.[fait_stock_actuel] WITH CHECK ADD CONSTRAINT [FK_stock_temps] FOREIGN KEY ([DateKey]) REFERENCES dbo.[dim_temps] ([DateKey]);
GO

ALTER TABLE dbo.[fait_ventes] WITH CHECK ADD CONSTRAINT [FK_ventes_temps] FOREIGN KEY ([DateKey]) REFERENCES dbo.[dim_temps] ([DateKey]);
GO
