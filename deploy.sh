#!/bin/bash
# Hugo Blog Deploy Script
# Builds the Hugo site and copies to nginx-served directory
# Usage: bash /home/ubuntu/projects/blog/deploy.sh

set -e

BLOG_DIR="/home/ubuntu/projects/blog"
DEST_DIR="/home/ubuntu/dify/docker/volumes/certbot/www/blog"

echo "[deploy] Building Hugo site..."
cd "$BLOG_DIR"
hugo --minify

echo "[deploy] Syncing to nginx directory..."
rsync -av --delete "$BLOG_DIR/public/" "$DEST_DIR/"

echo "[deploy] Done! Blog updated at http://152.67.211.188/blog/"
