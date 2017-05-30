# coding: utf-8
import os
import sys
import re

def createAllPool(directory):
    fs = []
    for f in os.listdir(directory):
        if re.findall(r'^main_all_best_.*?16pool', f):
            fs.append(f)
        
    if len(fs) != 2:
        print 'wrong number of main_all* file'
        print fs
        
    for mainFile in fs:
        with open(os.path.join(directory, mainFile), 'r') as f:
            txt = f.read()
        for i in range(1,16):
            outfile = os.path.join(directory, mainFile.replace('16',str(i)))
            if os.path.exists(outfile):
                continue
            txt2 = txt.replace('parfor(16)','parfor({})'.format(i))
            with open(outfile, 'w') as fo:
                fo.write(txt2)

if __name__ == '__main__':
    
    createAllPool(sys.argv[1])