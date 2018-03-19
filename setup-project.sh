oc new-project nextcloud
sudo oc login -u system:admin
sudo oc adm policy add-scc-to-user anyuid -z default -n nextcloud
oc new-app -f secret-template.yaml
oc-apply
sleep 10
oc start-build nextcloud --from-dir .
