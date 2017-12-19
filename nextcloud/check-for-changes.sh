oc get is,cm,pvc,sa,bc,dc,svc,route -o yaml > api-objects.tmp && mv api-objects.tmp api-objects.yml || rm api-objects.tmp
