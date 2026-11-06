# 현재 폴더 분석 보고서

이 폴더는 **Jekyll 기반의 GitHub Pages 블로그** 프로젝트입니다. `Minimal Mistakes` 테마를 사용하여 구축되었으며, 주로 마크다운 파일을 통해 콘텐츠를 관리합니다.

## 1. 프로젝트 개요

*   **플랫폼**: Jekyll (정적 사이트 생성기)
*   **호스팅**: GitHub Pages
*   **테마**: Minimal Mistakes (`mmistakes/minimal-mistakes`)
*   **사이트 제목**: "그래 만들어보자!" (`_config.yml`의 `title`)
*   **사이트 설명**: "PHP 개발자 하지만 소통이 필요해!" (`_config.yml`의 `description`)
*   **기본 언어**: 한국어 (`locale: "ko-KR"` in `_config.yml`)

## 2. 주요 폴더 및 파일

*   `_config.yml`: Jekyll 사이트의 전역 설정 파일입니다. 테마, 사이트 정보, 플러그인, 마크다운 처리 방식 등이 정의되어 있습니다.
*   `index.html`: 블로그의 메인 페이지 레이아웃을 정의합니다.
*   `README.md`: 프로젝트에 대한 설명과 블로그 운영 계획이 상세히 기술되어 있습니다.
*   `_includes/`: Jekyll 레이아웃에 포함될 재사용 가능한 HTML 조각들이 있습니다. (예: `head/custom.html`)
*   `_pages/`: 카테고리, 태그 등 특별한 페이지들을 정의하는 마크다운 파일이 있습니다.
    *   `_pages/categories/index.md`: 카테고리 아카이브 페이지입니다.
    *   `_pages/tags/index.md`: 태그 아카이브 페이지입니다.
*   `_posts/`: 블로그 게시물 마크다운 파일들이 저장되는 곳입니다. 파일명은 `YYYY-MM-DD-제목.md` 형식을 따릅니다.
    *   예: `2018-11-08-first-post.md`, `2025-07-24-artemis-engine.md`
*   `assets/`: 이미지, CSS, JavaScript 등 정적 자원들이 저장됩니다.
    *   `assets/images/`: 블로그 게시물에 사용되는 이미지들이 있습니다.
    *   `assets/images/favicon/`: 파비콘 관련 파일들이 있습니다.
    *   `assets/php-wasm-example/`, `assets/wasmPhp/`: PHP WebAssembly 관련 예제 파일들이 포함되어 있습니다.
*   `.git/`: Git 버전 관리 시스템 관련 파일들이 있습니다.
*   `.obsidian/`: Obsidian 노트 앱 관련 설정 파일들이 있습니다.

## 3. 게시물 작성 및 관리

*   **위치**: `_posts/` 폴더 내에 마크다운 파일로 작성됩니다.
*   **파일명 규칙**: `YYYY-MM-DD-제목.md` (예: `2025-07-23-how-to-categorize-posts.md`)
*   **Front Matter**: 각 게시물 파일 상단에 YAML 형식으로 메타데이터를 정의합니다.
    *   `title`: 게시물 제목
    *   `date`: 게시물 작성일 (`YYYY-MM-DD HH:MM:SS +0900` 형식)
    *   `categories`: 게시물의 카테고리 (배열 형식으로 여러 개 지정 가능)
    *   `tags`: 게시물의 태그 (배열 형식으로 여러 개 지정 가능)
    *   `layout`: 게시물 레이아웃 (대부분 `single`)
    *   `author_profile`, `read_time`, `comments`, `share`, `related`: 테마 관련 설정

## 4. 카테고리 및 태그

Minimal Mistakes 테마는 `_pages/categories/index.md`와 `_pages/tags/index.md` 파일을 통해 카테고리 및 태그별 아카이브 페이지를 자동으로 생성합니다. `_config.yml`에서 관련 설정(`category_archive`, `tag_archive`)이 되어 있습니다.

## 5. GitHub Pages 배포

이 블로그는 GitHub 리포지토리에 변경사항을 `git push`하면 GitHub Pages에 의해 자동으로 빌드되고 배포됩니다. 로컬에서 `bundle exec jekyll serve` 명령어를 통해 미리보기가 가능합니다.
