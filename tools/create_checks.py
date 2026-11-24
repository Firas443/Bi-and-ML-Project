from pathlib import Path
import json, pyodbc
ROOT=Path(__file__).resolve().parent
cn=pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=DW_Health_Dimensions;Trusted_Connection=yes;TrustServerCertificate=yes')
checks=[]
def add(name,dax,sql,tolerance=0.0001): checks.append(dict(name=name,dax=dax,sql=sql,tolerance=tolerance))
def base(name,sql): add(name,'EVALUATE ROW("value", ['+name+'])',sql)
for name,sql in {
 'CA HT':'SELECT SUM(CA_HT) value FROM fait_ventes',
 'Quantite vendue':'SELECT SUM(QuantiteVendue) value FROM fait_ventes',
 'Nombre de ventes':'SELECT COUNT(DISTINCT Document_Id) value FROM fait_ventes',
 'Panier moyen':'SELECT SUM(CA_HT)/NULLIF(COUNT(DISTINCT Document_Id),0) value FROM fait_ventes',
 'Cout HT connu':'SELECT SUM(Cout_HT) value FROM fait_ventes',
 'CA avec cout connu':'SELECT SUM(CA_HT) value FROM fait_ventes WHERE Cout_HT IS NOT NULL',
 'Marge HT':'SELECT SUM(CA_HT-Cout_HT) value FROM fait_ventes WHERE Cout_HT IS NOT NULL',
 'Lignes sans cout':'SELECT COUNT(*) value FROM fait_ventes WHERE Cout_HT IS NULL',
 'Couverture cout':'SELECT 1.0*COUNT(Cout_HT)/COUNT(*) value FROM fait_ventes',
 'Clients actifs':'SELECT COUNT(DISTINCT v.Company_Id) value FROM fait_ventes v JOIN dim_client c ON c.Client_SK=v.Client_SK WHERE c.EstClientIdentifie=1',
 'CA clients identifies':'SELECT SUM(v.CA_HT) value FROM fait_ventes v JOIN dim_client c ON c.Client_SK=v.Client_SK WHERE c.EstClientIdentifie=1',
 'Ventes clients identifies':'SELECT COUNT(DISTINCT v.Document_Id) value FROM fait_ventes v JOIN dim_client c ON c.Client_SK=v.Client_SK WHERE c.EstClientIdentifie=1',
 'Panier clients identifies':'SELECT SUM(v.CA_HT)/NULLIF(COUNT(DISTINCT v.Document_Id),0) value FROM fait_ventes v JOIN dim_client c ON c.Client_SK=v.Client_SK WHERE c.EstClientIdentifie=1',
 'Frequence achat client':'SELECT 1.0*COUNT(DISTINCT v.Document_Id)/NULLIF(COUNT(DISTINCT v.Company_Id),0) value FROM fait_ventes v JOIN dim_client c ON c.Client_SK=v.Client_SK WHERE c.EstClientIdentifie=1',
 'Stock disponible':'SELECT SUM(QuantiteActuelle) value FROM fait_stock_actuel',
 'Produits en rupture':'SELECT COUNT(DISTINCT Product_Id) value FROM fait_stock_actuel WHERE QuantiteActuelle=0',
 'Produits en stock faible':'SELECT COUNT(*) value FROM fait_stock_actuel WHERE QuantiteActuelle>0 AND QuantiteActuelle<=QuantiteAlerte',
 'Produits sans seuil':'SELECT COUNT(*) value FROM fait_stock_actuel WHERE QuantiteAlerte IS NULL',
 'Montant encaisse':'SELECT SUM(Amount) value FROM fait_encaissements',
 'Montant paye aux fournisseurs':'SELECT SUM(Amount) value FROM fait_decaissements',
 'Tresorerie nette':'SELECT (SELECT SUM(Amount) FROM fait_encaissements)-(SELECT SUM(Amount) FROM fait_decaissements) value',
 'Nombre encaissements':'SELECT COUNT(DISTINCT Payment_Id) value FROM fait_encaissements',
 'Nombre decaissements':'SELECT COUNT(DISTINCT Payment_Id) value FROM fait_decaissements',
 'Nombre de paiements':'SELECT COUNT(*) value FROM (SELECT Payment_Id FROM fait_encaissements UNION SELECT Payment_Id FROM fait_decaissements) x',
 'Montant regle vente':'SELECT SUM(Amount) value FROM fait_encaissements e WHERE EXISTS (SELECT 1 FROM fait_ventes v WHERE v.Document_Id=e.Document_Id)',
 'Montant regle facture fournisseur':'SELECT SUM(Amount) value FROM fait_decaissements d WHERE EXISTS (SELECT 1 FROM fait_achats a WHERE a.Document_Id=d.Document_Id)',
 'Encaissements non affectes':'SELECT SUM(Amount) value FROM fait_encaissements WHERE Document_Id IS NULL',
 'Decaissements non affectes':'SELECT SUM(Amount) value FROM fait_decaissements WHERE Document_Id IS NULL',
 'Achats HT':'SELECT SUM(MontantAchat_HT) value FROM fait_achats',
 'Quantite achetee':'SELECT SUM(QuantiteAchetee) value FROM fait_achats',
 'Nombre factures fournisseurs':'SELECT COUNT(DISTINCT Document_Id) value FROM fait_achats',
}.items(): base(name,sql)

# Exercise actual relationships with representative dimension selections.
for fact,dim,key,business,measure,amount in [
 ('fait_ventes','dim_produit','Produit_SK','Product_Id','CA HT','CA_HT'),
 ('fait_ventes','dim_client','Client_SK','Company_Id','CA HT','CA_HT'),
 ('fait_achats','dim_fournisseur','Fournisseur_SK','Fournisseur_Id','Achats HT','MontantAchat_HT'),
 ('fait_encaissements','dim_paiement','Paiement_SK','PaymentMode_Id','Montant encaisse','Amount'),
 ('fait_decaissements','dim_fournisseur','Fournisseur_SK','Fournisseur_Id','Montant paye aux fournisseurs','Amount'),
 ('fait_stock_actuel','dim_produit','Produit_SK','Product_Id','Stock disponible','QuantiteActuelle')]:
    ids=[r[0] for r in cn.cursor().execute(f'SELECT TOP 3 d.{business} FROM {fact} f JOIN {dim} d ON d.{key}=f.{key} GROUP BY d.{business} ORDER BY COUNT(*) DESC')]
    for i in ids:
        add(f'{measure} / {dim} {i}',f'EVALUATE ROW("value", CALCULATE([{measure}], {dim}[{business}]={i}))',f'SELECT SUM(f.{amount}) value FROM {fact} f JOIN {dim} d ON d.{key}=f.{key} WHERE d.{business}={i}')

# DAX time intelligence versus independently aggregated SQL, including partial first month.
months=[r[0] for r in cn.cursor().execute('SELECT DISTINCT DateKey/100 FROM fait_ventes ORDER BY 1')]
for ym in months:
    year,month=divmod(ym,100); prev=(year*100+month-1) if month>1 else (year-1)*100+12
    add(f'CA month {ym}',f'EVALUATE ROW("value", CALCULATE([CA HT], dim_temps[Annee]={year}, dim_temps[Mois]={month}))',f'SELECT SUM(CA_HT) value FROM fait_ventes WHERE DateKey/100={ym}')
    add(f'Growth MoM {ym}',f'EVALUATE ROW("value", CALCULATE([Croissance CA MoM], dim_temps[Annee]={year}, dim_temps[Mois]={month}))',f'SELECT ((SELECT SUM(CA_HT) FROM fait_ventes WHERE DateKey/100={ym})-(SELECT SUM(CA_HT) FROM fait_ventes WHERE DateKey/100={prev}))/NULLIF((SELECT SUM(CA_HT) FROM fait_ventes WHERE DateKey/100={prev}),0) value')
add('YoY missing history','EVALUATE ROW("value", CALCULATE([Croissance CA YoY], dim_temps[Annee]=2025, dim_temps[Mois]=4))','SELECT CAST(NULL AS decimal(18,4)) value')
add('Snapshot ignores date slicer','EVALUATE ROW("value", CALCULATE([Stock disponible], dim_temps[Annee]=2026))','SELECT SUM(QuantiteActuelle) value FROM fait_stock_actuel')
for fact,measure,payment,amount in [('fait_ventes','Montant regle vente','fait_encaissements','Montant encaisse'),('fait_achats','Montant regle facture fournisseur','fait_decaissements','Montant paye aux fournisseurs')]:
    ids=[r[0] for r in cn.cursor().execute(f'SELECT TOP 3 f.Document_Id FROM {fact} f WHERE EXISTS(SELECT 1 FROM {payment} p WHERE p.Document_Id=f.Document_Id) GROUP BY f.Document_Id ORDER BY COUNT(*) DESC')]
    for doc in ids:
        add(f'{measure} doc {doc}',f'EVALUATE ROW("value", CALCULATE([{measure}], {fact}[Document_Id]={doc}))',f'SELECT SUM(Amount) value FROM {payment} WHERE Document_Id={doc}')

for name in ['Atelier1_Ventes_Demo','Atelier1_Pays_Demo']:
    add(name,f'EVALUATE ROW("value", COUNTROWS({name}_Validation))','SELECT '+('2' if 'Ventes' in name else '4')+' value')
(ROOT/'checks.json').write_text(json.dumps(checks,ensure_ascii=False,indent=2),encoding='utf-8')
print('Created',len(checks),'SQL/DAX comparisons')
