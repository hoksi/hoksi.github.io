---
layout: single
title: "Jekyll 블로그에서 카테고리별 페이지 만들기 (Minimal Mistakes 테마)"
date: 2025-07-24 00:00:00 +0900
categories: [Jekyll, tutorial]
tags: [jekyll, blog, category, minimal-mistakes]
---

## Jekyll 블로그에서 카테고리별 페이지 만들기 (Minimal Mistakes 테마)

카테고리별 페이지는 블로그 게시물을 주제별로 정리하고 방문자가 쉽게 탐색할 수 있도록 돕는 중요한 기능입니다. Minimal Mistakes 테마는 이러한 카테고리 아카이브 페이지를 만드는 기능을 내장하고 있어 비교적 쉽게 설정할 수 있습니다.

### 1. `_config.yml` 설정 확인

`_config.yml` 파일에 카테고리 아카이브에 대한 설정이 이미 되어 있습니다. 다음 설정을 확인하십시오:

```yaml
# Archives
category_archive:
  type: liquid
  path: /categories/
```

이 설정은 카테고리 페이지가 `/categories/` 경로 아래에 생성될 것임을 의미합니다. 예를 들어, `jekyll` 카테고리의 페이지는 `/categories/jekyll/` 경로로 접근할 수 있습니다.

### 2. 카테고리 아카이브 페이지 생성

이제 각 카테고리에 대한 아카이브 페이지를 생성해야 합니다. Minimal Mistakes 테마는 `_pages` 디렉토리 내에 특정 프론트 매터(Front Matter)를 가진 파일을 생성하여 이를 처리합니다.

**단계별 가이드:**

1.  프로젝트 루트에 `_pages` 디렉토리가 없다면 생성합니다. (일반적으로 Minimal Mistakes 테마는 이 디렉토리를 사용합니다.)
2.  `_pages` 디렉토리 안에 `categories`라는 새 디렉토리를 생성합니다. (예: `_pages/categories/`)
3.  `_pages/categories/` 디렉토리 안에 새 마크다운 파일(예: `_pages/categories/index.md`)을 생성합니다. 이 파일은 모든 카테고리를 나열하는 메인 카테고리 페이지 역할을 합니다.

    **`_pages/categories/index.md` 파일 내용:**
    ```markdown
    ---
    title: "카테고리" # 페이지 제목
    layout: categories # Minimal Mistakes 테마의 카테고리 레이아웃
    permalink: /categories/ # 이 페이지의 URL
    author_profile: false # 저자 프로필 표시 여부 (선택 사항)
    ---
    ```

4.  **개별 카테고리 페이지 (선택 사항이지만 권장)**: 특정 카테고리에 대한 전용 페이지를 만들고 싶다면, 해당 카테고리 이름으로 파일을 생성합니다. 예를 들어, `jekyll` 카테고리에 대한 페이지를 만들려면 `_pages/categories/jekyll.md` 파일을 생성합니다.

    **`_pages/categories/jekyll.md` 파일 내용 (예시):**
    ```markdown
    ---
    title: "Jekyll" # 카테고리 페이지 제목
    layout: archive # 아카이브 레이아웃 사용
    permalink: /categories/jekyll/ # 이 카테고리 페이지의 URL
    type: categories # 이 페이지가 카테고리 아카이브임을 명시
    entries_layout: list # 게시물 목록의 표시 형식 (list, grid, compact 등)
    author_profile: false
    ---
    ```
    *   `type: categories`는 이 페이지가 카테고리 아카이브임을 Jekyll에 알려줍니다.
    *   `entries_layout`은 해당 카테고리에 속한 게시물 목록이 어떻게 표시될지 결정합니다.

### 3. 게시물에 카테고리 추가

게시물 프론트 매터에 `categories` 필드를 사용하여 해당 게시물이 속할 카테고리를 지정합니다. 여러 카테고리에 속할 수 있습니다.

```markdown
---
layout: single
title: "나의 첫 번째 진짜 포스트"
date: 2025-07-23 10:00:00 +0900
categories: [Jekyll, tutorial] # 여기에 카테고리 추가
tags: [블로그, 시작하기]
---
```

### 4. 로컬에서 확인

변경 사항을 저장한 후, 터미널에서 `bundle exec jekyll serve` 명령어를 실행하여 로컬 서버를 시작합니다.

*   `http://localhost:4000/categories/` 로 접속하여 모든 카테고리 목록 페이지를 확인합니다.
*   `http://localhost:4000/categories/jekyll/` (예시) 로 접속하여 `jekyll` 카테고리에 속한 게시물 목록을 확인합니다.

이 과정을 통해 블로그에 카테고리별 아카이브 페이지를 성공적으로 추가할 수 있습니다.
