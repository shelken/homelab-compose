#!/usr/bin/env bash
# filepath: script.sh

set -e

# 检查 network:homelab 是否存在，不存在则创建
if ! docker network ls --format '{{.Name}}' | grep -q '^homelab$'; then
  echo "未检测到 network:homelab，正在创建..."
  docker network create homelab
fi

# 定义服务列表
APPS=("") # 这里请补全你的所有app服务名

# 检查参数
if [[ $# -ne 1 || ( "$1" != "up" && "$1" != "down" ) ]]; then
  echo "用法: $0 [up|down]"
  exit 1
fi

ACTION="$1"

# 获取git顶层目录
GIT_ROOT=$(git rev-parse --show-toplevel)

for APP in "${APPS[@]}"; do

  [[ -z "$APP" ]] && continue

  APP_DIR="$GIT_ROOT/apps/$APP"
  ENV_FILE="$APP_DIR/.env"
  ENV_EXAMPLE="$APP_DIR/.env.example"

  if [[ ! -d "$APP_DIR" ]]; then
    echo "目录不存在: $APP_DIR"
    exit 1
  fi

  cd "$APP_DIR"

  if [[ "$ACTION" == "up" ]]; then
    # 检查.env文件
    if [[ ! -f "$ENV_FILE" ]]; then
      if [[ -f "$ENV_EXAMPLE" ]]; then
        cp "$ENV_EXAMPLE" "$ENV_FILE"
        echo "已为 $APP 创建.env，请修改 $ENV_FILE 后重新运行脚本。"
        exit 1
      else
        echo "$ENV_EXAMPLE 不存在，无法创建.env"
        exit 1
      fi
    fi

    # 检查.env文件是否包含{}
    if grep -q '{}' "$ENV_FILE"; then
      echo "$ENV_FILE 文件中包含 {}，请修改后再运行。"
      exit 1
    fi

    echo "启动 $APP 服务..."
    docker compose up -d

  elif [[ "$ACTION" == "down" ]]; then
    echo "关闭 $APP 服务..."
    docker compose down
  fi
done

echo "操作完成。"