#!/usr/bin/env bash
# 会宣通 Agent —— 一键推送到 GitHub
# 用法: bash push-to-github.sh <你的GitHub用户名> [仓库名]
#   例如: bash push-to-github.sh panshiyu huixuantong-agent
set -euo pipefail

USER_NAME="${1:-}"
REPO_NAME="${2:-huixuantong-agent}"

if [ -z "$USER_NAME" ]; then
  echo "用法: bash push-to-github.sh <你的GitHub用户名> [仓库名]"
  exit 1
fi

cd "$(dirname "$0")"

# 走本机代理（github.com 主站/API 被拦，但 git 推送通道可用）
git config http.proxy http://127.0.0.1:2893
git config https.proxy http://127.0.0.1:2893

REMOTE="https://github.com/${USER_NAME}/${REPO_NAME}.git"

if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE"
else
  git remote add origin "$REMOTE"
fi

echo "远程地址: $REMOTE"
echo "开始推送..."
git push -u origin main

echo ""
echo "✅ 推送完成: https://github.com/${USER_NAME}/${REPO_NAME}"
echo ""
echo "下一步 → 开启 Pages（公开演示链接）:"
echo "  仓库 → Settings → Pages → Source 选 'GitHub Actions' 或 'Deploy from a branch'"
echo "  若选分支方式: Branch 选 main, 目录选 /docs, 保存"
echo "  几分钟后访问: https://${USER_NAME}.github.io/${REPO_NAME}/"
