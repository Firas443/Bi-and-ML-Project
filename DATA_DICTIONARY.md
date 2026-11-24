# Physical warehouse data dictionary

| Table | Rows |
|---|---:|
| dim_client | 82 |
| dim_fournisseur | 116 |
| dim_paiement | 6 |
| dim_produit | 6,842 |
| dim_temps | 730 |
| fait_achats | 6,964 |
| fait_decaissements | 502 |
| fait_encaissements | 10,467 |
| fait_stock_actuel | 6,842 |
| fait_ventes | 25,743 |

## dim_client

| Column | SQL type | Nullable | Key |
|---|---|---|---|
| Company_Id | int | no |  |
| Nom | nvarchar(200) | yes |  |
| TypeClient | nvarchar(30) | no |  |
| EstClientIdentifie | bit | no |  |
| Client_SK | int | no | PK |

## dim_fournisseur

| Column | SQL type | Nullable | Key |
|---|---|---|---|
| Fournisseur_Id | int | no |  |
| Nom | nvarchar(200) | yes |  |
| Fournisseur_SK | int | no | PK |

## dim_paiement

| Column | SQL type | Nullable | Key |
|---|---|---|---|
| PaymentMode_Id | int | no |  |
| PaymentModeName | nvarchar(50) | no |  |
| Paiement_SK | int | no | PK |

## dim_produit

| Column | SQL type | Nullable | Key |
|---|---|---|---|
| Product_Id | int | no |  |
| Libelle | nvarchar(255) | yes |  |
| Famille | nvarchar(100) | no |  |
| Marque | nvarchar(100) | no |  |
| Produit_SK | int | no | PK |

## dim_temps

| Column | SQL type | Nullable | Key |
|---|---|---|---|
| DateKey | int | no | PK |
| Date | date | no |  |
| Annee | smallint | no |  |
| Trimestre | tinyint | no |  |
| Mois | tinyint | no |  |
| SemaineISO | tinyint | no |  |
| EstFerie | bit | no |  |

## fait_achats

| Column | SQL type | Nullable | Key |
|---|---|---|---|
| Id | bigint | no | PK |
| Document_Id | bigint | no |  |
| DateKey | int | no | FK |
| Product_Id | int | no |  |
| Fournisseur_Id | int | no |  |
| QuantiteAchetee | decimal(18,4) | no |  |
| MontantAchat_HT | decimal(18,4) | no |  |
| Produit_SK | int | no | FK |
| Fournisseur_SK | int | no | FK |

## fait_decaissements

| Column | SQL type | Nullable | Key |
|---|---|---|---|
| Id | bigint | no | PK |
| Payment_Id | bigint | no |  |
| Document_Id | bigint | yes |  |
| DateKey | int | no | FK |
| PaymentMode_Id | int | no |  |
| Fournisseur_Id | int | no |  |
| Amount | decimal(18,4) | no |  |
| Paiement_SK | int | no | FK |
| Fournisseur_SK | int | no | FK |

## fait_encaissements

| Column | SQL type | Nullable | Key |
|---|---|---|---|
| Id | bigint | no | PK |
| Payment_Id | bigint | no |  |
| Document_Id | bigint | yes |  |
| DateKey | int | no | FK |
| PaymentMode_Id | int | no |  |
| Company_Id | int | no |  |
| Amount | decimal(18,4) | no |  |
| Client_SK | int | no | FK |
| Paiement_SK | int | no | FK |

## fait_stock_actuel

| Column | SQL type | Nullable | Key |
|---|---|---|---|
| Product_Id | int | no |  |
| DateKey | int | yes | FK |
| QuantiteActuelle | decimal(18,4) | no |  |
| QuantiteAlerte | decimal(18,4) | yes |  |
| EstSousSeuil | bit | yes |  |
| Produit_SK | int | no | PK,FK |

## fait_ventes

| Column | SQL type | Nullable | Key |
|---|---|---|---|
| Id | bigint | no | PK |
| Document_Id | bigint | no |  |
| DateKey | int | no | FK |
| Product_Id | int | no |  |
| Company_Id | int | no |  |
| QuantiteVendue | decimal(18,4) | no |  |
| Remise_HT | decimal(18,4) | no |  |
| CA_HT | decimal(18,4) | no |  |
| Cout_HT | decimal(18,4) | yes |  |
| Produit_SK | int | no | FK |
| Client_SK | int | no | FK |
