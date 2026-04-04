## 설치
```bash
helm upgrade --install my-platform ./helm/my-platform
```
# 주요 값 변경
backend.replicaCount : 백엔드 복제 수
nginx.image : Nginx 이미지
frontend.image : 프론트엔드 이미지

# 옵션 기능
monitoring.enabled=true/false
logging.enabled=true/false

---