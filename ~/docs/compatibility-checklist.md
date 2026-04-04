# Frontend-Backend Compatibility & Deployment Checklist

목적: Kubernetes + Helm + Ansible 기반 환경에서 프론트엔드와 백엔드 서비스 동작 확인

---

## 1. 환경 설정 확인

| 항목 | 확인 내용 | 상태 |
|------|----------|------|
| Helm values.yaml | 프론트엔드 API_BASE_URL와 백엔드 서비스 이름/포트 일치 | [ ] |
| Namespace | 백엔드, 프론트엔드 동일 namespace 또는 서비스 접근 가능 | [ ] |
| 환경 변수 | DB, Redis, 외부 API Key 정상 설정 | [ ] |
| ConfigMap / Secret | 배포용 값 반영 완료 | [ ] |

---

## 2. Kubernetes 배포 상태

| 항목 | 확인 방법 | 상태 |
|------|-----------|------|
| Pod 상태 | `kubectl get pods` → 모두 Running | [ ] |
| 서비스 상태 | `kubectl get svc` → NodePort/ClusterIP 확인 | [ ] |
| 이벤트 확인 | `kubectl describe pod <pod>` → 오류 없음 | [ ] |
| 로그 확인 | `kubectl logs -f deploy/<pod>` → Crash/Timeout 없음 | [ ] |

---

## 3. 백엔드 헬스 체크

| 항목 | 명령어 | 기대 결과 | 상태 |
|------|--------|------------|------|
| 헬스 엔드포인트 | `curl -f http://<backend>:<port>/health` | HTTP 200 OK | [ ] |
| 기본 API 테스트 | `curl -f http://<backend>:<port>/api/test` | 정상 응답 | [ ] |

---

## 4. 프론트엔드 연결 테스트

| 항목 | 명령어 | 기대 결과 | 상태 |
|------|--------|------------|------|
| 백엔드 API 연결 | `kubectl exec -it <frontend-pod> -- curl http://backend:<port>/api/test` | 정상 응답 | [ ] |
| 프론트엔드 접속 | `http://<VM_IP>:<NodePort>` | UI 정상 로딩 | [ ] |
| 주요 기능 | 로그인, 데이터 호출, 화면 표시 | 정상 작동 | [ ] |

---

## 5. 롤백 & 안정성 확인

| 항목 | 명령어 | 기대 결과 | 상태 |
|------|--------|------------|------|
| Helm 롤백 테스트 | `helm rollback <release> <revision>` | 이전 버전 복구 | [ ] |
| Pod 재시작 테스트 | `kubectl delete pod <pod>` | 자동 재시작 | [ ] |
| 부하 테스트 | `hey -z 1m http://<frontend>:<port>` | 에러율 허용 범위 | [ ] |

---

## 6. 모니터링 확인

| 항목 | 확인 방법 | 상태 |
|------|-----------|------|
| Prometheus | 주요 메트릭 확인 | [ ] |
| Loki / 로그 | Error / CrashLoop 여부 확인 | [ ] |
| 서비스 응답 시간 | 평균 Latency 확인 | [ ] |

---

## 최종 확인

- [ ] 프론트엔드와 백엔드 통합 기능 정상  
- [ ] 배포 후 에러 없음, 롤백 가능  
- [ ] 헬스 체크 및 모니터링 모두 정상