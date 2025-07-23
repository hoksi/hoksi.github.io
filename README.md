# GitHub 블로그 운영 계획

## 1. 블로그 기본 정보 분석

| 항목 | 내용 |
|--------------------|---|
| **플랫폼** | Jekyll, GitHub Pages |
| **테마** | Minimal Mistakes |
| **게시물 폴더** | `_posts` |
| **이미지 폴더** | `assets/images` |
| **카테고리** | `_posts` 내 게시물 Front Matter의 `categories` 필드 사용. `_pages/categories/index.md`를 통해 아카이브 페이지 생성. |
| **태그** | `_posts` 내 게시물 Front Matter의 `tags` 필드 사용. `_pages/tags/index.md`를 통해 아카이브 페이지 생성. |

### GitHub Pages 정보
이 블로그는 GitHub Pages를 사용하여 호스팅됩니다. GitHub Pages는 GitHub 리포지토리에서 직접 정적 웹사이트를 만들 수 있게 해주는 서비스입니다.

**주요 특징 및 설정:**
*   **호스팅**: 이 리포토리의 `master` 브랜치 (또는 설정된 다른 브랜치)에 푸시되는 내용이 자동으로 웹사이트로 게시됩니다.
*   **사이트 빌드**: Jekyll과 같은 정적 사이트 생성기를 사용하여 블로그를 빌드합니다. `_config.yml` 파일에서 Jekyll 관련 설정을 확인할 수 있습니다.
*   **사용자 지정 도메인**: 필요한 경우 사용자 지정 도메인을 설정하여 블로그에 연결할 수 있습니다. (자세한 내용은 GitHub Pages 문서 참조)
*   **HTTPS 지원**: 블로그는 HTTPS를 통해 안전하게 제공됩니다.
*   **로컬 테스트**: 변경 사항을 GitHub에 푸시하기 전에 로컬 환경에서 Jekyll을 사용하여 블로그를 미리 보고 테스트할 수 있습니다.

### 기본 구조
현재 블로그는 Jekyll 기반으로 GitHub Pages에 호스팅되도록 설정되어 있습니다. 게시물은 `_posts` 폴더에 `YYYY-MM-DD-제목.md` 형식의 마크다운 파일로 작성하며, 이미지는 `assets/images` 폴더에 저장 후 링크하여 사용합니다.

## 2. 콘텐츠 작성 계획

### 가. 주제 선정
- 블로그의 핵심 주제를 정합니다. (예: 개발, 일상, 학습 기록, 특정 기술 튜토리얼 등)

### 나. 포스트 아이디어 브레인스토밍
- 작성할 글의 아이디어를 5-10개 정도 미리 구상합니다.
- (예시)
    - Jekyll 블로그 테마 변경 방법
    - 마크다운(Markdown) 기본 문법 정리
    - 개발 환경 설정 기록 (macOS, VSCode)
    - 첫 번째 코딩 프로젝트 회고
    - 매일 30분씩 책 읽기 챌린지 후기

### 다. 포스팅 주기 결정
- 현실적인 포스팅 주기를 설정하여 꾸준히 운영하는 것을 목표로 합니다.
- (예시) 주 1회 (매주 일요일), 2주에 1회 등

## 3. 글 작성 및 발행 워크플로우

### 가. 새 게시물 파일 생성
- [x] `_posts` 폴더에 `YYYY-MM-DD-post-title.md` 형식으로 새 마크다운 파일을 생성합니다.
- 예: `2025-07-23-my-first-real-post.md`

### 나. Front Matter 작성
- [x] 파일 최상단에 `---`로 둘러싸인 영역에 메타데이터를 작성합니다.
- 기본적으로 `title`과 `date`를 포함합니다.
```yaml
---
title:  "나의 첫 번째 진짜 포스트"
date:   2025-07-23 10:00:00 +0900
categories: [Jekyll, tutorial]
tags: [블로그, 시작하기]
---
```

### 다. 본문 작성
- [x] 마크다운 문법을 사용하여 자유롭게 글의 내용을 작성합니다.

### 라. 이미지 추가
1. `assets/images` 폴더에 이미지를 추가합니다.
2. 본문에 `![이미지 설명](/assets/images/your-image.jpg)` 형식으로 이미지를 삽입합니다.

### 마. 로컬 환경에서 테스트 (선택사항)
- `git push`를 하기 전에 로컬에서 블로그가 어떻게 보이는지 확인할 수 있습니다.
- 터미널에서 `bundle exec jekyll serve` 명령어를 실행하고 웹 브라우저에서 `http://localhost:4000`에 접속하여 확인합니다.

## 4. 카테고리 및 태그 페이지 설정

Minimal Mistakes 테마는 카테고리 및 태그별 아카이브 페이지를 지원합니다. 이를 위해 다음 파일들이 필요합니다.

- [x] `_pages/categories/index.md`:
```markdown
---
title: "카테고리"
layout: categories
permalink: /categories/
author_profile: false
---
```

- [x] `_pages/tags/index.md`:
```markdown
---
title: "태그"
layout: tags
permalink: /tags/
author_profile: false
---
```

- [x] `_config.yml` 파일에 다음 설정이 되어 있는지 확인하십시오:
```yaml
category_archive:
  type: liquid
  path: /categories/
tag_archive:
  type: liquid
  path: /tags/
```

## 5. 배포

1.  **변경사항 추가:** `git add .`
2.  **커밋:** `git commit -m "New post: [포스트 제목]"`
3.  **푸시:** `git push`

- 위 명령어를 실행하면 변경사항이 GitHub 저장소에 반영되고, 잠시 후 자동으로 블로그에 게시물이 발행됩니다.
