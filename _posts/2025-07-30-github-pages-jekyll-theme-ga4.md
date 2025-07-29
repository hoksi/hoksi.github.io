---
layout: single
title: "GitHub Pages (Jekyll) 테마 수정 및 Google Analytics 연동 가이드"
date: 2025-07-30 05:45:24 +0900
categories:
  - Web Development
tags:
  - GitHub Pages
  - Jekyll
  - Minimal Mistakes
  - Google Analytics
  - GA4
---

# GitHub Pages (Jekyll) 테마 수정 및 Google Analytics 연동 가이드

Jekyll을 사용하여 GitHub Pages를 운영하면서 Google Analytics 연동을 위해 `_config.yml` 파일에 코드를 추가했지만, 실제 연동이 되지 않는 문제가 있었습니다. 이는 GA4 코드를 발급받았음에도 불구하고 Jekyll에서 지원하는 스크립트가 이를 제대로 지원하지 않았기 때문입니다. 이 가이드는 Minimal Mistakes 테마를 기준으로 Jekyll 테마 수정 및 GA4 연동 방법을 다룹니다.

## 1. Jekyll 테마 수정 방법

Jekyll 테마를 수정하는 가장 일반적이고 안전한 방법은 **테마 파일 오버라이드(Overriding Theme Files)**와 **커스텀 CSS/SCSS 추가**입니다.



### 1.1. 테마 파일 오버라이드

Minimal Mistakes와 같은 Jekyll 테마는 `_layouts`, `_includes`, `_sass` 등의 디렉토리에 핵심 파일을 가지고 있습니다. 이 파일들을 직접 수정하는 대신, **자신의 저장소에 동일한 경로로 파일을 생성하여 테마의 파일을 덮어쓰는(override) 방식**으로 수정할 수 있습니다. Jekyll은 빌드 시 자신의 저장소에 있는 파일을 테마의 파일보다 우선적으로 사용합니다.

**예시:** 테마의 `_includes/head/custom.html` 파일을 수정하고 싶다면, 자신의 GitHub Pages 저장소에 `_includes/head/custom.html` 파일을 만들고 그 안에 원하는 내용을 작성하면 됩니다.

### 1.2. 커스텀 CSS/SCSS 추가

가장 흔하고 안전한 방법 중 하나는 사용자 정의 CSS/SCSS 파일을 추가하여 기존 테마의 스타일을 덮어쓰는 것입니다.

1.  자신의 저장소 루트에 `_sass` 디렉토리가 없다면 생성합니다.
2.  `_sass` 디렉토리 안에 `_custom.scss`와 같은 파일을 생성합니다.
3.  이 파일 안에 원하는 CSS 코드를 작성합니다.
    ```scss
    // _sass/_custom.scss
    .page__title {
      color: #007bff; // 페이지 제목 색상 변경
      font-size: 2.5em; // 페이지 제목 글자 크기 변경
    }

    .page__content {
      a {
        color: #28a745; // 링크 색상 변경
        &:hover {
          text-decoration: underline;
        }
      }
    }
    ```
    Minimal Mistakes 테마는 `_sass/minimal-mistakes/_custom.scss` 파일을 생성하고 여기에 CSS를 추가하면 자동으로 불러와집니다.

### 1.3. `_config.yml` 파일 수정

`_config.yml` 파일은 Jekyll 사이트의 전역 설정을 담당합니다. 테마에서 제공하는 다양한 옵션(예: 내비게이션 메뉴, 소셜 링크, 저자 정보, 플러그인 설정 등)을 이 파일에서 변경할 수 있습니다. Minimal Mistakes 테마는 `_config.yml`을 통해 매우 많은 부분을 설정할 수 있도록 되어 있습니다.

**예시:**
```yaml
# _config.yml
title: "나의 멋진 블로그"
description: "이것은 나의 개인 블로그입니다."
minimal_mistakes_skin: "default" # 테마 스킨 변경 (예: "dark", "light", "mint" 등)
```

## 2. Google Analytics 4 (GA4) 연동 방법

GA4 측정을 위해서는 올바른 GA4 추적 코드를 삽입해야 합니다.

### 2.1. 올바른 GA4 추적 코드

`G-XXXXXXXXXX` 측정 ID를 위한 올바른 GA4 추적 코드(글로벌 사이트 태그, `gtag.js`)는 다음과 같습니다.

```html
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-XXXXXXXXXX');
</script>
```

### 2.2. GA4 코드 삽입 위치

Minimal Mistakes 테마에서 GA4 추적 코드를 삽입하는 가장 좋은 위치는 `_includes/head/custom.html` 파일입니다.

1.  자신의 GitHub Pages 저장소에 `_includes` 디렉토리가 없다면 생성합니다.
2.  `_includes` 디렉토리 안에 `head` 디렉토리가 없다면 생성합니다.
3.  `_includes/head` 디렉토리 안에 `custom.html` 파일을 생성합니다.
4.  이 `custom.html` 파일 안에 위의 GA4 추적 코드를 붙여넣습니다.

    **`_includes/head/custom.html` 내용:**
    ```html
    <!-- Google tag (gtag.js) -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      gtag('config', 'G-XXXXXXXXXX');
    </script>
    ```

## 3. 작업 순서 요약

1.  **자신의 GitHub Pages 저장소를 로컬로 클론합니다.**
    ```bash
    git clone https://github.com/[자신의 GitHub Pages 저장소 주소].git
    cd [자신의 GitHub Pages 저장소 디렉토리명]
    ```
2.  **기존 Google Analytics 코드 삭제:**
    현재 웹사이트에 삽입되어 있는 Universal Analytics 코드(이전 대화에서 보여주신 코드)를 찾아서 **삭제**합니다. (예: `_includes/head.html` 또는 `_layouts/default.html` 등)
3.  **새로운 GA4 코드 삽입:**
    `_includes/head/custom.html` 파일을 생성하고 위에 제시된 GA4 코드를 붙여넣습니다.
4.  **원하는 테마 수정 (선택 사항):**
    `_config.yml`을 수정하거나, `_sass/_custom.scss` 파일을 만들어 CSS를 추가하는 방식으로 테마를 수정합니다.
5.  **변경 사항 커밋 및 푸시:**
    ```bash
    git add .
    git commit -m "Update Google Analytics to GA4 and apply theme customizations"
    git push origin main # 또는 master 브랜치
    ```

이렇게 변경 사항을 GitHub 저장소에 푸시하면, GitHub Pages가 자동으로 사이트를 다시 빌드하여 적용합니다. 변경 사항이 적용되는 데 몇 분 정도 소요될 수 있습니다. 적용 후 Google Analytics 실시간 보고서에서 본인의 접속이 카운트되는지 확인해 보세요.