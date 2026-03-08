#!/bin/bash
# Hugo Blog Deploy Script
# Builds the Hugo site and copies to nginx-served directory (root domain)
# Usage: bash /home/ubuntu/projects/blog/deploy.sh

set -e

BLOG_DIR="/home/ubuntu/projects/blog"
DEST_DIR="/home/ubuntu/dify/docker/volumes/certbot/www/site"

echo "[deploy] Running SEO pre-check..."
cd "$BLOG_DIR"
bash tools/seo_check.sh "$BLOG_DIR/content"
echo ""

echo "[deploy] Building Hugo site..."
hugo --minify

echo "[deploy] Syncing to nginx directory..."
mkdir -p "$DEST_DIR"
rsync -av --delete "$BLOG_DIR/public/" "$DEST_DIR/"

echo "[deploy] Done! Blog updated at https://judyailab.com/"
