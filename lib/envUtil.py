import sys
import copy
import json

def mergeEnv(src, part, target):
    for i in src: 
        if (part.get(i)):
            mergeEnv(src[i], part[i], target[i])
    for j in part:
        if (not src.get(j)):
            target[j] = part[j]
        else:
           if (not isinstance(src[j], dict)):
               target[j] = part[j]
    return target

if __name__ == '__main__':
    src = json.load(open(sys.argv[1], 'r'))
    part = json.load(open(sys.argv[2], 'r'))
    json.dump(mergeEnv(src, part, copy.deepcopy(src)), open('/tmp/deployment-service.json', 'w'))
