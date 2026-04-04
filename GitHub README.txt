==========================================================
MY PLATFORM DEPLOYMENT
==========================================================

이 프로젝트는 Kubernetes 기반 전체 플랫폼
(nginx + frontend + backend + db + redis)을
자동으로 배포하고 관리합니다.

배포 흐름:
GitHub Actions → SSH → Ansible → Helm → Kubernetes

==========================================================
1. 프로젝트 구조
----------------------------------------------------------
ansible/                 - 배포용 Ansible Playbook
helm/my-platform/         - Helm Chart
scripts/server-setup.sh   - 서버 초기 설치 스크립트
deploy.sh                 - 로컬 배포 스크립트
docs/                     - 아키텍처 및 가이드 문서
runbook/                  - 배포/스케일/모니터링/로깅 런북

==========================================================
2. 서버 초기 설정
----------------------------------------------------------
sudo bash scripts/server-setup.sh

설치 항목:
- Node.js LTS
- Python3 & pip
- Docker & Docker Compose
- Git, curl, vim, build-essential 등
- UFW 방화벽 설정 (SSH 허용)

주의:
- K8s 노드로 사용할 서버는 swap 비활성화 필요
  (sudo swapoff -a)

==========================================================
3. 로컬 배포
----------------------------------------------------------

전체 배포 실행:
./deploy.sh

백엔드 복제 수 조절:
ansible-playbook -i ansible/inventory ansible/deploy.yml -e "state=present replicas=3"

배포 제거:
ansible-playbook -i ansible/inventory ansible/deploy.yml -e "state=absent"

==========================================================
4. GitHub Actions 배포
----------------------------------------------------------
- Trigger: main 브랜치 Push
- 동작: SSH 접속 후 Ansible 실행 → Helm 배포

워크플로 확인:
.github/workflows/deploy.yml

주의:
- 자동화 배포를 위해 SSH 키와 K8s kubeconfig가 GitHub Secrets에 등록되어 있어야 함

==========================================================
5. 서비스 접속
----------------------------------------------------------
kubectl get svc -n my-platform

브라우저 접속:
- 플랫폼: http://<VM_IP>:<NodePort>
- Grafana: http://<VM_IP>:3000
- Loki: http://<VM_IP>:3100

주의:
- NodePort는 Helm values 또는 Service 타입에 따라 다를 수 있음

==========================================================
6. 운영 및 관리 팁
----------------------------------------------------------
로그 확인:
kubectl logs -f deploy/<deployment-name> -n my-platform

Pod 상태 확인:
kubectl get pods -n my-platform

스케일 조정:
kubectl scale deploy backend --replicas=3 -n my-platform

Helm 릴리즈 관리:
helm list -n my-platform
helm rollback <release> 1 -n my-platform