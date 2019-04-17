import sys
import json
from xml.etree.ElementTree import fromstring


def get_obj(root):
    ns = 'https://github.com/gree-gorey/xelm'
    obj = {}
    if len(root) == 0:
        if '{{{ns}}}Integer'.format(ns=ns) in root.attrib:
            if root.attrib.get('{{{ns}}}Integer'.format(ns=ns)) == 'true':
                try:
                    return int(root.text)
                except ValueError:
                    return root.text
        return root.text
    else:
        if '{{{ns}}}Array'.format(ns=ns) in root.attrib:
            if root.attrib.get('{{{ns}}}Array'.format(ns=ns)) == 'true':
                arr = []
                for el in root:
                    arr.append(get_obj(el))
                return arr
        for el in root:
            obj[el.tag] = get_obj(el)
        return obj


def main():
    xml = sys.stdin.read()
    root = fromstring(xml)
    manifest = get_obj(root)
    ser = json.dumps(manifest, indent=4)
    print(ser)


main()
