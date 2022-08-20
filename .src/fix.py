#!/usr/bin/python3.8

import re, sys
import xml.dom.minidom as MD
import xml.etree.ElementTree as ET

def buildEmbeddedElements(parent, dict_array_tag):
    el = ET.SubElement(parent, dict_array_tag[0]['name'])

    for att in dict_array_tag[0]['attr']:
        el.set(att['name'], att['value'])

    dict_array_tag.pop(0)
    if dict_array_tag:
        return buildEmbeddedElements(el, dict_array_tag)

    return el

def addEntity(tree):
    root = tree.findall(".//session-factory")[0]

    dict_array_tag = [
        {'name': 'mapping', 'attr': [
            {'name': 'class', 'value': """example.entity.BreedCountEntity"""}
        ]},
    ]

    buildEmbeddedElements(root, dict_array_tag)


def main():
    tree = None
    with open(sys.argv[1], encoding='utf-8') as f:
        xmlStr = f.readlines()
        xmlStr = "".join(xmlStr)
        tree = ET.fromstring(xmlStr)

    addEntity(tree)

    xmlstr = MD.parseString(ET.tostring(tree)).toprettyxml(indent="   ")
    with open(sys.argv[1], "w") as f:
        f.write(xmlstr)


if __name__ == '__main__':
    main()
