#!/bin/bash
# SEO Pre-deploy Check for Judy AI Lab Blog
# Scans all markdown files for common SEO issues
# Usage: bash tools/seo_check.sh [content_dir]

CONTENT_DIR="${1:-/home/ubuntu/projects/blog/content}"
WARNINGS=0
ERRORS=0
FIXED=0

echo "=== SEO Pre-deploy Check ==="
echo ""

for f in $(find "$CONTENT_DIR/posts" -name "*.md" -type f | sort); do
    filename=$(basename "$f")
    issues=""

    # Read frontmatter (between first two ---)
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$f" | head -50)

    # Check: has description or summary?
    has_desc=$(echo "$frontmatter" | grep -c '^\(description\|summary\):')
    if [ "$has_desc" -eq 0 ]; then
        issues="${issues}  [WARN] Missing description/summary\n"
        ((WARNINGS++))
    fi

    # Check: title length (extract title value)
    title=$(echo "$frontmatter" | grep '^title:' | sed 's/^title: *"\?\(.*\)"\?$/\1/' | sed 's/"$//')
    title_len=${#title}
    if [ "$title_len" -gt 60 ] && [ "$title_len" -gt 0 ]; then
        issues="${issues}  [WARN] Title too long (${title_len} chars, recommended <= 60)\n"
        ((WARNINGS++))
    fi

    # Check: has tags?
    has_tags=$(echo "$frontmatter" | grep -c '^tags:')
    if [ "$has_tags" -eq 0 ]; then
        issues="${issues}  [WARN] Missing tags\n"
        ((WARNINGS++))
    fi

    # Check: has categories?
    has_cats=$(echo "$frontmatter" | grep -c '^categories:')
    if [ "$has_cats" -eq 0 ]; then
        issues="${issues}  [WARN] Missing categories\n"
        ((WARNINGS++))
    fi

    # Check: word count (body only, after second ---)
    body=$(sed -n '/^---$/,/^---$/!p' "$f" | tail -n +2)
    word_count=$(echo "$body" | wc -c)
    if [ "$word_count" -lt 300 ]; then
        issues="${issues}  [WARN] Very short content (${word_count} chars)\n"
        ((WARNINGS++))
    fi

    # Check: has internal links? (links to /posts/ or relative links)
    has_internal=$(echo "$body" | grep -c '\](/\|](https://judyailab.com')
    if [ "$has_internal" -eq 0 ]; then
        issues="${issues}  [INFO] No internal links found\n"
        ((WARNINGS++))
    fi

    # Print issues for this file
    if [ -n "$issues" ]; then
        echo "$filename:"
        echo -e "$issues"
    fi
done

echo "=== Summary ==="
echo "Warnings: $WARNINGS"
echo "Errors: $ERRORS"
echo ""

if [ "$ERRORS" -gt 0 ]; then
    echo "FAILED: Fix errors before deploying."
    exit 1
fi

if [ "$WARNINGS" -gt 0 ]; then
    echo "PASSED with warnings. Consider fixing above issues."
else
    echo "PASSED: All SEO checks OK!"
fi
exit 0
