# 스케일 런북

## 백엔드 복제 수 조정
```bash
ansible-playbook -i inventory deploy.yml -e "state=present replicas=3"
```
#상태 확인
```bash
kubectl get pods -l app=backend
```
---