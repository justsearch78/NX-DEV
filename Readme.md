ArgoCD installation
------------------

kubectl create ns argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

watch kubectl get pods -n argocd

kubectl edit svc argocd-server -n argocd

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

kubectl edit svc argocd-server -n argocd



Jenkins Execute shell
---------------------

git clone https://github.com/Iam-7hills/gitops-demo.git devopsconfig

cd devopsconfig/helm

ls -lrt

echo $BUILD_NUMBER

sed -i "s/{tagversion}/$BUILD_NUMBER/g" gittemplate.yaml

cp -f gittemplate.yaml ../gitops.yaml


cd ${WORKSPACE}/devopsconfig

git config user.email "iam.7hills@gmail.com"

git config user.name "Iam-7hills"

git add .

git commit -m "Modofied the template file and pushed to gitops-demo.git"

git push https://<token>@github.com/Iam-7hills/gitops-demo.git

