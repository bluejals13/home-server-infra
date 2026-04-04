# 🚀 My Platform Deployment

이 프로젝트는 **Kubernetes 기반 플랫폼 (nginx + frontend + backend + db + redis)** 을
자동으로 배포하고 운영하기 위한 **실무형 DevOps 환경**입니다.

배포는 단순 실행이 아니라
👉 **검증 / 롤백 / 운영(runbook)까지 포함된 구조**로 설계되었습니다.

---

# 🧩 1. 아키텍처

```text
GitHub Actions → SSH → Ansible → Helm → Kubernetes
```

* CI: GitHub Actions
* CD: Ansible + Helm
* Infra: Kubernetes
* 운영: Runbook 기반 관리

---

# 📁 2. 프로젝트 구조

```text
project/
├── ansible/
│   ├── inventory
│   └── deploy.yml
│
├── helm/my-platform/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── nginx.yaml
│       ├── frontend.yaml
│       ├── backend.yaml
│       ├── redis.yaml
│       ├── db.yaml
│       ├── prometheus.yaml   # optional
│       └── loki.yaml         # optional
│
├── scripts/
│   └── server-setup.sh       # 초기 서버 설정
│
├── .github/workflows/
│   └── deploy.yml            # CI/CD 자동 배포
│
├── deploy.sh                 # 수동 배포 스크립트
│
├── docs/
│   ├── architecture.md
│   ├── helm-guide.md
│   ├── ansible-guide.md
│   └── troubleshooting.md
│
└── runbook/
    ├── deployment.md
    ├── scale.md
    ├── monitoring.md
    └── logging.md
```

---

# ⚙️ 3. 실행 방법

## 🔹 3.1 수동 배포

```bash
./deploy.sh
```

---

## 🔹 3.2 상태 제어 (Ansible)

```bash
# 서비스 생성
ansible-playbook -i inventory deploy.yml -e "state=present replicas=1"

# 스케일 다운
ansible-playbook -i inventory deploy.yml -e "state=present replicas=0"

# 전체 제거
ansible-playbook -i inventory deploy.yml -e "state=absent"
```

👉 상태 기반 배포 (idempotent)

---

# 🌐 4. 서비스 접속

```bash
kubectl get svc
```

접속:

```
http://<VM_IP>:<NodePort>
```

---

# 📊 5. 배포 검증 (필수)

```bash
kubectl get pods
```

```bash
kubectl rollout status deploy/backend
```

```bash
curl -f http://<service-endpoint>
```

✔️ 확인 항목:

* Pod 상태 Running
* 서비스 응답 정상 (200 OK)
* CrashLoop 없음

---

# 🔄 6. 롤백 전략

```bash
helm rollback <release> <revision>
```

## 🔹 롤백 조건

* 배포 후 에러 증가 (5xx)
* Pod CrashLoopBackOff 발생
* 서비스 응답 지연

👉 **문제 발생 시 즉시 이전 버전으로 복구**

---

# ⚙️ 7. 운영 관리

## 🔹 로그 확인

```bash
kubectl logs -f deploy/<deployment-name>
```

## 🔹 스케일 조정

```bash
kubectl scale deploy backend --replicas=3
```

## 🔹 상태 확인

```bash
kubectl get pods
kubectl get svc
```

---

# 📘 8. Runbook 기반 운영

본 프로젝트는 운영 안정성을 위해
👉 **Runbook 중심 구조**로 관리됩니다.

| Runbook       | 설명    |
| ------------- | ----- |
| deployment.md | 배포 절차 |
| scale.md      | 확장/축소 |
| monitoring.md | 모니터링  |
| logging.md    | 로그 관리 |

---

# 🧠 9. 설계 특징

## ✅ 1. 상태 기반 배포

* Ansible state=present / absent
* 반복 실행 안전

## ✅ 2. Helm 기반 관리

* 버전 관리
* 롤백 가능

## ✅ 3. 운영 중심 구조

* Runbook 포함
* 모니터링 확장 가능 (Prometheus, Loki)

---

# 🔥 핵심 요약

* Kubernetes 기반 자동 배포 시스템
* Ansible + Helm 연동 구조
* 검증 / 롤백 / 운영 포함
* Runbook 기반 실무형 설계

---