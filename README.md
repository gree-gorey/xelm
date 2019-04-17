# xelm
XSLT implementation of Helm: template Kubernetes manifests using XML

## Usage

```console
$ ./xelm.sh -h
Usage: xelm [options] [--help]

Options are:
    -o, --output='xml': Output format. One of: xml, json
```

## How it works

We have `values.xml` file containing variables for templates:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<values>
  <name>nginx</name>
  <image>nginx</image>
  <imageTag>1.9-alpine</imageTag>
</values>
```

And example template file for Pod manifest:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xelm="https://github.com/gree-gorey/xelm">
  <xsl:template match="/">
    <root>
      <apiVersion>v1</apiVersion>
      <kind>Pod</kind>
      <metadata>
        <name><xsl:value-of select="values/name"/></name>
        <labels>
          <name>nginx</name>
        </labels>
      </metadata>
      <spec>
        <containers xelm:Array="true">
          <container>
            <name><xsl:value-of select="values/name"/></name>
            <image>
              <xsl:value-of select="values/image"/>:<xsl:value-of select="values/imageTag"/>
            </image>
            <ports xelm:Array="true">
              <port>
                <containerPort xelm:Integer="true">80</containerPort>
              </port>
            </ports>
          </container>
        </containers>
      </spec>
    </root>
  </xsl:template>
</xsl:stylesheet>
```

Notice the `xelm:Array="true"` attribute that forces the children of the node to be array items;
` xelm:Integer="true"` forces value to be converted into integer in `json`. These are required workarounds since there is no straight translation between `xml` and `json` formats.

## Quick start

Generate `xml` manifest:
```console
$ ./xelm.sh
<?xml version="1.0"?>
<root xmlns:xelm="https://github.com/gree-gorey/xelm">
  <apiVersion>v1</apiVersion>
  <kind>Pod</kind>
  <metadata>
    <name>nginx</name>
    <labels>
      <name>nginx</name>
    </labels>
  </metadata>
  <spec>
    <containers xelm:Array="true">
      <container>
        <name>nginx</name>
        <image>nginx:1.9-alpine</image>
        <ports xelm:Array="true">
          <port>
            <containerPort xelm:Integer="true">80</containerPort>
          </port>
        </ports>
      </container>
    </containers>
  </spec>
</root>
```

Generate `json` manifest:
```console
$ ./xelm.sh -o json
{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {
        "name": "nginx",
        "labels": {
            "name": "nginx"
        }
    },
    "spec": {
        "containers": [
            {
                "name": "nginx",
                "image": "nginx:1.9-alpine",
                "ports": [
                    {
                        "containerPort": 80
                    }
                ]
            }
        ]
    }
}
```

Validate manifest with `kubectl`:
```console
$ ./xelm.sh -o json | kubectl create --dry-run -o yaml -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: nginx
  name: nginx
  namespace: default
spec:
  containers:
  - image: nginx:1.9-alpine
    name: nginx
    ports:
    - containerPort: 80
```
