---
title: "웹사이트 파비콘(Favicon) 생성 및 적용 가이드"
date: 2025-07-24 11:05:00 +0900
categories: [Web, Design]
tags: [Favicon, WebDesign, Jekyll, MinimalMistakes]
---

웹사이트를 운영하다 보면 브라우저 탭이나 북마크에 표시되는 작은 아이콘을 보셨을 겁니다. 이것이 바로 **파비콘(Favicon)**입니다. 파비콘은 웹사이트의 정체성을 나타내고 사용자 경험을 향상시키는 중요한 요소입니다.

## 파비콘이란?

파비콘(Favicon)은 'Favorite Icon'의 줄임말로, 웹사이트를 즐겨찾기에 추가했을 때 표시되는 아이콘을 의미합니다. 현재는 즐겨찾기뿐만 아니라 웹 브라우저 탭, 주소창, 검색 결과 등 다양한 곳에서 웹사이트를 시각적으로 식별하는 데 사용됩니다.

### 왜 중요한가요?

*   **브랜딩 강화**: 웹사이트의 로고나 상징적인 이미지를 통해 브랜드를 시각적으로 각인시킵니다.
*   **사용자 경험 향상**: 여러 탭을 열어 놓았을 때, 파비콘을 통해 원하는 웹사이트를 쉽게 찾을 수 있도록 돕습니다.
*   **전문성 및 신뢰도**: 파비콘이 없는 웹사이트는 완성도가 떨어져 보일 수 있습니다.

## 파비콘 생성 방법

파비콘은 일반적으로 `.ico` 형식이나 다양한 크기의 `.png` 형식으로 제공됩니다. 기존 이미지를 파비콘으로 변환하려면 이미지 편집 소프트웨어를 사용하거나, 더 쉽게는 온라인 파비콘 생성기를 활용할 수 있습니다.

### 온라인 파비콘 생성기 활용 (권장)

온라인 파비콘 생성기는 원본 이미지를 업로드하면 다양한 크기와 형식의 파비콘 파일들을 자동으로 생성해 줍니다. 다음은 널리 사용되는 몇 가지 도구입니다:

*   **Favicon.io**: [https://favicon.io/](https://favicon.io/)
*   **RealFaviconGenerator**: [https://realfavicongenerator.net/](https://realfavicongenerator.net/)

**생성 과정 예시 (Favicon.io 기준):**

1.  **이미지 업로드**: `Image to Favicon` 섹션에서 파비콘으로 만들 이미지 파일(예: `hoksi.jpg`)을 업로드합니다.
2.  **옵션 설정**: 필요한 경우 배경색, 여백 등 추가 옵션을 설정합니다.
3.  **파비콘 생성 및 다운로드**: `Download` 버튼을 클릭하여 생성된 파비콘 파일들을 압축 파일 형태로 다운로드합니다. 이 압축 파일에는 `favicon.ico`, `android-chrome-192x192.png`, `apple-touch-icon.png` 등 다양한 파일들이 포함되어 있습니다.

## Jekyll Minimal Mistakes 테마에 파비콘 적용하기

Minimal Mistakes 테마는 파비콘 적용을 위한 특정 경로와 설정을 제공합니다. 일반적으로 다운로드한 파비콘 파일들을 `assets/images/` 디렉토리 내에 배치하고, `<head>` 태그 내에 링크를 추가해야 합니다.

1.  **파비콘 파일 배치**: 다운로드한 파비콘 파일들을 `assets/images/` 디렉토리 안에 복사합니다. (예: `assets/images/favicon.ico`, `assets/images/apple-touch-icon.png` 등)

2.  **HTML 링크 추가**: Minimal Mistakes 테마에서는 `_includes/head/custom.html` 파일을 사용하여 사용자 정의 `<head>` 태그 내용을 추가할 수 있습니다. 이 파일이 없다면 생성합니다.

    `_includes/head/custom.html` 파일에 다음 코드를 추가합니다:

    ```html
    <link rel="apple-touch-icon" sizes="180x180" href="/assets/images/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/assets/images/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/assets/images/favicon-16x16.png">
    <link rel="manifest" href="/assets/images/site.webmanifest">
    <link rel="mask-icon" href="/assets/images/safari-pinned-tab.svg" color="#5bbad5">
    <meta name="msapplication-TileColor" content="#da532c">
    <meta name="theme-color" content="#ffffff">
    ```

    **참고**: 위 코드는 Favicon.io 등에서 제공하는 예시 코드이며, 실제 다운로드한 파일명과 경로에 맞게 `href` 속성을 수정해야 합니다. `site.webmanifest`와 `safari-pinned-tab.svg` 파일도 함께 배치해야 합니다.

3.  **사이트 재빌드**: Jekyll 사이트를 다시 빌드하거나 `jekyll serve`를 재시작하여 변경 사항을 적용합니다.

이제 웹사이트에 접속하면 브라우저 탭에서 새로운 파비콘을 확인할 수 있을 것입니다. 파비콘은 웹사이트의 완성도를 높이고 방문자에게 좋은 인상을 줄 수 있는 작은 디테일입니다.