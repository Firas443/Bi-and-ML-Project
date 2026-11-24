from pathlib import Path
import argparse,shutil,json
p=argparse.ArgumentParser();p.add_argument('--data-root',type=Path);p.add_argument('--sql-root',type=Path);a=p.parse_args()
root=Path(__file__).resolve().parents[1]
data=(a.data_root or root.parent/'data').resolve();sql=(a.sql_root or root.parent/'sql-server').resolve()
assert (data/'original').is_dir(), 'Check out the data branch beside ssis, or pass --data-root'
assert (sql/'sql/99_verifications.sql').exists(), 'Check out sql-server beside ssis, or pass --sql-root'
for d in ['data/original','data/transport','sql','reports']:(root/d).mkdir(parents=True,exist_ok=True)
for item in json.loads((root/'scripts/sources.json').read_text(encoding='utf-8-sig')):shutil.copy2(data/'original'/item['source'],root/'data/original'/item['source'])
for f in (sql/'sql').glob('*.sql'):shutil.copy2(f,root/'sql'/f.name)
print('Prepared local input files and SQL dependencies.')
