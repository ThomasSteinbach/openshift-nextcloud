oc create configmap mysql-config --from-literal mysql-user=nextcloud --from-literal mysql-database=nextcloud
oc process openshift//mysql-persistent -p VOLUME_CAPACITY=5Gi -p MEMORY_LIMIT=4Gi -o yaml > mysql.yaml
vim mysql.yaml

> Secret -> stringData - Passwörter angepasst
> Secret -> stringData -> database-user gelöscht
> folgendes zu env des Deployment Templates eingefügt:
- env:
  - name: MYSQL_USER
    valueFrom:
      configMapKeyRef:
        key: mysql-user
        name: mysql-config
  - name: MYSQL_DATABASE
    valueFrom:
      configMapKeyRef:
        key: mysql-database
        name: mysql-config

oc new-app . --name openshift-nextcloud -o yaml > nextcloud.yaml
vim nextcloud.yaml

> folgendes einfügen:
containers:
- image: openshift-nextcloud:latest
  env:
  - name: MYSQL_USER
    valueFrom:
      configMapKeyRef:
        key: mysql-user
        name: mysql-config
  - name: MYSQL_PASSWORD
    valueFrom:
      secretKeyRef:
        key: database-password
        name: mysql
  - name: MYSQL_DATABASE
    valueFrom:
      configMapKeyRef:
        key: mysql-database
        name: mysql-config

oc set env --from secret/mysql dc/openshift-nextcloud
oc set env --from configmap/mysql-config dc/openshift-nextcloud
