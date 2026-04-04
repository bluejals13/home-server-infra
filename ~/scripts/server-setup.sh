#!/bin/bash
set -euo pipefail

echo "===== 서버 초기 설치 시작 ====="

# root 체크
if [ "$EUID" -ne 0 ]; then
  echo "❌ root로 실행하세요"
  exit 1
fi

# OS 정보
OS_CODENAME=$(lsb_release -cs)
OS_VERSION=$(lsb_release -rs)
echo "Detected Ubuntu: $OS_VERSION ($OS_CODENAME)"

# 업데이트
export DEBIAN_FRONTEND=noninteractive
apt update && apt -y upgrade

# 기본 패키지 설치
apt install -y \
  curl wget git unzip vim build-essential \
  python3 python3-venv python3-pip \
  cron lsb-release ufw

# Node LTS 설치
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs

# Docker 설치 (간단 버전)
curl -fsSL https://get.docker.com | sh

# Docker 서비스 시작 및 활성화
systemctl enable docker
systemctl start docker

# Docker Compose 설치
apt install -y docker-compose-plugin

# 방화벽 설정
ufw allow OpenSSH
ufw --force enable

# 설치 확인
echo "===== 설치 확인 ====="
echo -n "Node.js: "; node -v
echo -n "Python3: "; python3 --version
echo -n "Docker: "; docker --version
echo -n "Docker Compose: "; docker compose version

echo "===== 서버 초기 설치 완료 ====="