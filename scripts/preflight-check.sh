#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

pass() { echo "[PASS] $1"; }
fail() { echo "[FAIL] $1"; exit 1; }

# 1) Shell 语法检查
bash -n install.sh || fail "install.sh syntax"
bash -n config-menu.sh || fail "config-menu.sh syntax"
bash -n docker-entrypoint.sh || fail "docker-entrypoint.sh syntax"
pass "shell syntax"

# 2) 官方升级链路关键字检查
grep -q "openclaw update --restart" config-menu.sh || fail "missing openclaw update --restart in config-menu.sh"
grep -q "openclaw plugins update --all" config-menu.sh || fail "missing plugins update --all in config-menu.sh"
pass "upgrade pipeline markers"

# 3) 飞书官方插件默认检查
grep -q 'FEISHU_PLUGIN_OFFICIAL="@openclaw/feishu"' config-menu.sh || fail "missing official feishu plugin default"
pass "feishu plugin default marker"

# 4) 文档命令一致性检查
grep -q "openclaw update --restart" README.md || fail "README missing official upgrade command"
grep -q "openclaw plugins update --all" README.md || fail "README missing plugin update command"
pass "README command markers"

echo "All preflight checks passed."
