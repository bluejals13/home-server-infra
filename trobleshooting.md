# 📌 1️⃣ 문제 상황 (현장 형태)

## 운영 중인 API 서비스에서 다음과 같은 장애가 동시 발생했습니다.

- API 응답 지연 증가 (p95 latency 급증)
- 일부 요청 timeout 발생
- 특정 pod restart 반복
- DB connection timeout 증가
- 간헐적 network failure 로그 발생

👉 겉으로 보면 “전체 시스템 장애” 형태
“한 가지 장애가 아니라, 하위 리소스 장애가 연쇄로 터진 상황”

# 🔍 2️⃣ 단계별 분석 (실전 사고 흐름)

## 🖥 2-1️⃣ CPU 확인
```bash
top
uptime
```

관찰:
- load average 급상승
- 특정 process CPU 100% 점유

🧠 의미:
- request queue 적체
- thread starvation 발생
- DB / network 호출 지연 시작
# 💾 2-2️⃣ Memory (OOM 확인)
```bash
dmesg | grep -i oom
```

관찰:
- OOM Killer 동작 로그 확인
- 일부 worker process 강제 종료

🧠 의미:
- worker 부족 → 요청 처리 지연
- retry 증가 → CPU 추가 부하

👉 CPU ↔ OOM 서로 악순환
# 🗄 2-3️⃣ DB 상태 확인
```bash
slow query log
connection pool check
```

관찰:
- query latency 증가
- connection pool full
- 일부 query timeout

🧠 의미:
- CPU 과부하로 query 실행 지연
- connection hold time 증가
- DB queueing 발생
# 🌐 2-4️⃣ Network 확인
```bash
curl -v
ss -tuna
```

관찰:
- 일부 request timeout
- packet retransmission 증가

🧠 의미:
- DB 응답 지연 → network timeout으로 확대
- retry 트래픽 증가
# 🔥 3️⃣ 전체 장애 구조 (핵심)
---
CPU overload
    ↓
worker starvation
    ↓
DB connection hold 증가
    ↓
DB latency 증가
    ↓
network timeout 발생
    ↓
retry traffic 증가
    ↓
CPU + memory 더 증가
    ↓
OOM 발생

---
초기 트리거는 CPU pressure였고, 
이후 DB latency와 retry traffic이 결합되면서 OOM까지 확장된 복합 장애입니다
# 🚑 5️⃣ 대응 (실전 운영 기준)
---
## 🔧 5-1️⃣ 즉시 대응 (Stabilization)

- traffic limit (rate limiting)
- autoscaling trigger
- problematic pod restart
- DB connection pool 제한
---
## 🔧 5-2️⃣ 리소스 차단

- CPU throttling
- memory limit 적용
- retry 제한
---
## 🔧 5-3️⃣ DB 보호

- connection pool 축소
- slow query kill
- read replica 분리
---
🔧 5-4️⃣ network 보호

- retry backoff 적용
- timeout 줄이기
- circuit breaker 적용
---
# 🏗 6️⃣ 구조 개선 (근본 해결)
---
## 📌 1. CPU isolation
- core pinning
- priority separation

## 📌 2. Memory control
- cgroups / K8s limits
- leak detection

## 📌 3. DB separation
- read/write split
- cache layer (Redis)

## 📌 4. resilience pattern
- circuit breaker
- bulkhead
- retry policy tuning
---
# 📈 7️⃣ 최종 정리

#### "해당 장애는 CPU 과부하를 시작점으로 DB latency 증가, network timeout, retry traffic 증가가 연쇄적으로 발생하면서 OOM까지 확장된 리소스 cascade failure "
---
- 1. 단일 장애 X
- 2. 리소스 간 전이 O
- 3. CPU → DB → Network → Memory 순으로 확장됨
- 4. retry가 장애를 키움
​
