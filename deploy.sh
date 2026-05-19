#!/bin/bash
# Hugo Blog Deploy Script
# Builds the Hugo site and copies to nginx-served directory (root domain)
# Usage: bash /home/ubuntu/projects/blog/deploy.sh

set -e

BLOG_DIR="/home/ubuntu/projects/blog"
DEST_DIR="/home/ubuntu/dify/docker/volumes/certbot/www/blog"

echo "[deploy] Running SEO pre-check..."
cd "$BLOG_DIR"
bash tools/seo_check.sh "$BLOG_DIR/content"
echo ""

echo "[deploy] Running BLOG-REVIEW-GATE..."
if ! python3 /home/ubuntu/tools/blog/review_gate.py --quiet; then
    echo ""
    echo "[deploy] ❌ ABORTED: BLOG-REVIEW-GATE 違規（content/posts draft:false 但 Notion 仍在 review）"
    echo "[deploy] 修法：違規 slug 三語檔 draft:true 後重跑，或 Notion 改成「可發」"
    exit 1
fi
echo ""

echo "[deploy] Building Hugo site..."
hugo --minify --cleanDestinationDir

echo "[deploy] Syncing to nginx directory..."
mkdir -p "$DEST_DIR"
sudo rsync -av --delete "$BLOG_DIR/public/" "$DEST_DIR/"

echo "[deploy] Done! Blog updated at https://judyailab.com/"
