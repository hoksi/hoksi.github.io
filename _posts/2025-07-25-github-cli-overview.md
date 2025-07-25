---
title: "GitHub CLI (gh) 개요"
date: 2025-07-25 09:00:00 +0900
categories: [GitHub, CLI]
tags: [gh, GitHub CLI, 터미널, 개발도구]
layout: single
author_profile: true
read_time: true
comments: true
share: true
related: true
---

GitHub CLI (명령줄 인터페이스)는 `gh`로 불리며, 터미널에서 직접 GitHub와 상호작용할 수 있도록 해주는 오픈 소스 도구입니다. 이는 개발자가 컨텍스트 전환을 줄이고 생산성을 향상시킬 수 있도록 풀 리퀘스트, 이슈, GitHub Actions와 같은 다양한 GitHub 기능을 명령줄로 가져옵니다.

## 주요 기능 및 특징

*   **저장소 관리**: 터미널에서 직접 저장소를 생성, 복제, 조회, 포크할 수 있습니다. 예를 들어, `gh repo create` 명령어를 사용하여 새 저장소를 만들 수 있습니다.
*   **풀 리퀘스트 및 이슈 관리**: 터미널을 벗어나지 않고도 풀 리퀘스트와 이슈를 생성, 조회, 나열, 편집, 닫기, 검토, 비교, 병합할 수 있습니다. `gh issue list` 및 `gh pr create`와 같은 명령어를 사용할 수 있습니다.
*   **GitHub Actions 상호작용**: 워크플로우를 실행, 조회, 나열할 수 있습니다.
*   **Gist 관리**: Gist를 생성, 나열, 조회, 편집, 삭제할 수 있습니다.
*   **인증**: SSH 키, 토큰, OAuth를 지원하여 GitHub 계정으로 안전하게 인증할 수 있습니다. 여러 계정을 관리하고 전환할 수도 있습니다.
*   **사용자 지정 스크립팅**: GitHub CLI는 GitHub 작업을 자동화하는 스크립트를 더 쉽게 만들 수 있도록 하며, 명령에 대한 사용자 지정 별칭을 허용합니다.
*   **API 접근**: GitHub API에서 정보를 검색할 수 있습니다.

## Git CLI (`git`)와의 차이점 및 사용 예시

GitHub CLI (`gh`)는 Git의 명령줄 인터페이스 (`git`)와는 다릅니다. `git`은 로컬 또는 원격 Git 저장소 (어디에서든 호스팅될 수 있음)와 작업하는 데 사용되는 반면, `gh`는 GitHub 및 해당 기능과 상호작용하도록 특별히 설계되었습니다.

두 도구는 목적이 다르지만, GitHub에서 프로젝트를 관리할 때는 상호 보완적으로 사용됩니다.

### `git` 명령어 (로컬 저장소 및 일반적인 Git 작업)

`git` 명령어는 주로 로컬 저장소의 변경 사항을 추적하고, 커밋하며, 브랜치를 관리하고, 원격 저장소와 동기화하는 데 사용됩니다.

*   **저장소 초기화**:
    ```bash
    git init
    ```
*   **파일 변경사항 스테이징**:
    ```bash
    git add .
    ```
*   **변경사항 커밋**:
    ```bash
    git commit -m "feat: 새로운 기능 추가"
    ```
*   **원격 저장소에서 변경사항 가져오기**:
    ```bash
    git pull origin main
    ```
*   **원격 저장소로 변경사항 푸시**:
    ```bash
    git push origin main
    ```
*   **브랜치 생성 및 전환**:
    ```bash
    git checkout -b feature/new-feature
    ```

### `gh` 명령어 (GitHub 특정 기능 및 워크플로우)

`gh` 명령어는 GitHub 플랫폼의 기능을 터미널에서 직접 활용하여 개발 워크플로우를 간소화하는 데 중점을 둡니다.

*   **GitHub 저장소 생성**:
    ```bash
    gh repo create my-new-repo --public
    ```
    (이는 `git init` 후 원격 저장소를 추가하고 첫 푸시하는 과정을 대체할 수 있습니다.)
*   **이슈 목록 조회**:
    ```bash
    gh issue list
    ```
*   **새로운 풀 리퀘스트 생성**:
    ```bash
    gh pr create --title "feat: Add user authentication" --body "사용자 인증 기능 추가"
    ```
    (이는 `git push` 후 웹에서 PR을 생성하는 과정을 대체합니다.)
*   **풀 리퀘스트 확인 및 병합**:
    ```bash
    gh pr checkout 123 # 123번 PR 브랜치로 전환
    gh pr merge 123 --merge # 123번 PR 병합
    ```
*   **GitHub Actions 워크플로우 실행**:
    ```bash
    gh run watch
    ```

### 결론

`git`은 코드 버전 관리에 필수적인 도구이며, `gh`는 GitHub 플랫폼의 강력한 기능을 터미널에서 편리하게 사용할 수 있도록 돕는 보조 도구입니다. 두 도구를 함께 사용하면 로컬 개발 환경과 GitHub 원격 저장소 간의 상호작용을 훨씬 효율적으로 관리할 수 있습니다.

## 지원 운영체제

GitHub CLI는 Windows, macOS, Linux 운영 체제에서 사용할 수 있습니다.
