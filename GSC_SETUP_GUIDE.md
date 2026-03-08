# Google Search Console 設定指南

## 步驟（5 分鐘搞定）

### 1. 開 GSC
- 到 https://search.google.com/search-console
- 用 Google 帳號登入

### 2. 新增資源
- 點「新增資源」
- 選「**URL 前置字元**」（右邊那個）
- 輸入：`https://judyailab.com/`

### 3. 驗證
- 選「**HTML 標記**」方法
- 會給你一串 meta tag，像這樣：
  ```
  <meta name="google-site-verification" content="xxxxxxxxxxxx" />
  ```
- 把 `content="..."` 裡面那串碼複製下來

### 4. 告訴 J
- 把驗證碼貼給 J，J 會填入 hugo.yaml 並重新部署
- 大約 1 分鐘後回到 GSC 點「驗證」

### 5. 提交 Sitemap
- 驗證成功後，左邊選「Sitemap」
- 輸入：`sitemap.xml`
- 點「提交」

## 目前已準備好的
- [x] robots.txt（自動生成，包含 sitemap 指向）
- [x] sitemap.xml（中英文各一份，自動更新）
- [x] 結構化資料（JSON-LD，每篇文章都有）
- [x] Canonical URL
- [ ] GSC 驗證碼 ← **等 Judy 操作**
