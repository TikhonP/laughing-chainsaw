#!/Users/tikhon/anaconda3/bin/python

from os import system, listdir
from tqdm import tqdm

print('\n' + '-' * 10)
print('\n Tikhon Systems Software inc.')
print('\n' + '-' * 10 + '\n')

directory = input('Directory to video files > ')
print()
files = listdir(directory)
tot = len(files)
skipped = []
modifiedlen = 0

for f in tqdm(files):
    f = f.split(sep='.')
    try:
        if f[1] == 'MP4' or f[1] == 'mp4':
            nf = f[0] + '.mov'
            cmd = f'mv "{directory}/{".".join(f)}" "{directory}/{nf}"'
            system(cmd)
    except IndexError:
        skipped.append(f[0])

print(f'\nCompleted! {str(modifiedlen)} files was modified')

if len(skipped) != 0:
    print('\nSome files was skipped:')
    for f in skipped:
        print(f, ' ', end='')
print()
