import sys
import json
from xml.etree.ElementTree import fromstring

def get_obj(root):
    obj = {}
    if len(root) == 0:
        if '{https://github.com/gree-gorey/xelm}Integer' in root.attrib:
            if root.attrib.get('{https://github.com/gree-gorey/xelm}Integer') == 'true':
                try:
                    return int(root.text)
                except ValueError:
                    return root.text
        return root.text
    else:
        if '{https://github.com/gree-gorey/xelm}Array' in root.attrib:
            if root.attrib.get('{https://github.com/gree-gorey/xelm}Array') == 'true':
                arr = []
                for el in root:
                    arr.append(get_obj(el))
                return arr
        for el in root:
            obj[el.tag] = get_obj(el)
        return obj

def main():
    xml = sys.stdin.read()
    # with open("test.xml") as f:
    #     xml = f.read()
    root = fromstring(xml)
    manifest = get_obj(root)
    ser = json.dumps(manifest, indent=4)
    print(ser)

main()
