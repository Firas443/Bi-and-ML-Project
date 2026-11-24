from pathlib import Path
import json, decimal, pyodbc
ROOT=Path(__file__).resolve().parent
cn=pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=DW_Health_Dimensions;Trusted_Connection=yes;TrustServerCertificate=yes')
checks=json.loads((ROOT/'checks.json').read_text(encoding='utf-8-sig'))
actual=json.loads((ROOT/'dax_checks.json').read_text(encoding='utf-8-sig'))
results=[]
for test in checks:
    sql=cn.cursor().execute(test['sql']).fetchone()[0]
    item=next(x for x in actual if x['name']==test['name'])
    dax=item.get('value')
    good=not item.get('error') and ((sql is None and dax is None) or (sql is not None and dax is not None and abs(decimal.Decimal(str(sql))-decimal.Decimal(str(dax)))<=decimal.Decimal(str(test['tolerance']))))
    results.append({'name':test['name'],'sql':str(sql) if sql is not None else None,'dax':dax,'passed':good,'error':item.get('error')})
summary={'comparisons':len(results),'passed':sum(x['passed'] for x in results),'failed':sum(not x['passed'] for x in results),'results':results}
(ROOT/'validation_results.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({k:v for k,v in summary.items() if k!='results'},indent=2))
for r in results:
    if not r['passed']: print(r)
raise SystemExit(bool(summary['failed']))
