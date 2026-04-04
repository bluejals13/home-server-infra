# 프로젝트 아키텍처

## 1. 서비스 구성
- **nginx** : 프론트 게이트웨이, NodePort 서비스
- **frontend** : React/Vue 기반 프론트엔드
- **backend** : API 서버, DB 및 Redis 의존
- **db** : PostgreSQL, StatefulSet
- **redis** : 캐시, Deployment
- **monitoring/logging** : 선택적 활성화

## 2. 네트워크
- app-net : 앱 서비스 간 통신
- gateway-net : 외부 접속
- monitoring-net : Prometheus/Grafana
- logging-net : Loki/Promtail

## 3. CI/CD
- GitHub Actions → SSH → Ansible → Helm → Kubernetes