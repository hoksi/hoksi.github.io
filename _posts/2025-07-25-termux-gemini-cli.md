---
title: "Termux를 이용한 안드로이드폰에서 Gemini CLI 사용하기"
date: 2025-07-25 15:30:00 +0900
categories: [Android, Termux, Gemini, CLI]
tags: [Termux, Android, Gemini CLI, 모바일 개발 환경, 터미널]
layout: single
author_profile: true
read_time: true
comments: true
share: true
related: true
---

안드로이드폰에서 개발 환경을 구축하고 AI 작업을 수행하고 싶으신가요? Termux와 Gemini CLI의 조합이라면 모바일 환경에서도 강력한 개발 및 자동화 작업을 수행할 수 있습니다. 이 포스팅에서 그 방법을 자세히 알아보겠습니다.

## 1. Termux 설치

Termux는 Google Play 스토어보다는 [F-Droid](https://f-droid.org/packages/com.termux/)를 통해 설치하는 것을 권장합니다. F-Droid 버전이 더 최신이며 안정적인 업데이트를 제공합니다.

1.  **F-Droid 설치**: F-Droid 웹사이트에서 F-Droid 클라이언트 앱을 다운로드하여 설치합니다.
2.  **Termux 설치**: F-Droid 앱을 실행한 후, 'Termux'를 검색하여 설치합니다.

## 2. Termux 초기 설정 및 필수 패키지 설치

Termux를 처음 실행하면 기본 시스템이 설치됩니다. 이후 필요한 패키지들을 설치합니다.

```bash
pkg update && pkg upgrade
pkg install nodejs git openssh -y
```

*   `nodejs`: Gemini CLI 실행에 필요한 Node.js 런타임입니다.
*   `git`: 저장소를 클론하는 데 필요합니다.
*   `openssh`: 원격 서버 접속 등 추가적인 작업을 위해 유용합니다.

## 3. Gemini CLI 설치

Gemini CLI는 npm(Node Package Manager)을 통해 설치하는 것이 가장 일반적입니다.

```bash
npm install -g @google/gemini-cli
```

*   `-g` 옵션은 Gemini CLI를 전역으로 설치하여 어느 디렉토리에서든 `gemini` 명령어를 사용할 수 있게 합니다.

## 4. Google AI API 키 설정

Gemini CLI를 사용하려면 Google AI Studio에서 발급받은 API 키가 필요합니다. API 키는 [aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey)에서 생성할 수 있습니다.

API 키는 `GEMINI_API_KEY` 환경 변수로 설정하는 것이 권장됩니다.

```bash
export GEMINI_API_KEY="YOUR_API_KEY_HERE"
```

이 설정은 현재 터미널 세션에서만 유효합니다. Termux를 다시 시작해도 유지되도록 하려면, 다음 줄을 `~/.bashrc` 또는 `~/.zshrc` 파일에 추가하세요.

```bash
echo 'export GEMINI_API_KEY="YOUR_API_KEY_HERE"' >> ~/.bashrc # 또는 ~/.zshrc
source ~/.bashrc # 변경사항 적용
```

## 5. Gemini CLI 실행

이제 Gemini CLI를 실행할 준비가 되었습니다.

*   **대화형 모드 (REPL)**:
    ```bash
    gemini
    ```
    이 명령어를 실행하면 대화형 세션이 시작되어 프롬프트를 직접 입력할 수 있습니다.

*   **비대화형 모드**:
    프롬프트를 직접 전달하여 단일 응답을 받을 수 있습니다.
    ```bash
    gemini -p "안녕, Gemini!"
    ```

## 6. 추가 팁

*   **백그라운드 실행**: 장시간 실행해야 하는 작업의 경우 `nohup`이나 `tmux`를 사용하여 세션이 끊겨도 작업이 계속되도록 할 수 있습니다.
    ```bash
    pkg install tmux # tmux 설치
    tmux new -s gemini_session # 새 tmux 세션 시작
    # 여기서 Gemini CLI 명령어 실행
    # Ctrl+b d 를 눌러 세션에서 나옴 (백그라운드 실행)
    # tmux attach -t gemini_session 로 다시 접속
    ```
*   **파일 접근**: Termux는 안드로이드 파일 시스템의 특정 경로에만 접근할 수 있습니다. `termux-setup-storage` 명령어를 실행하여 외부 저장소 접근 권한을 부여할 수 있습니다.

이 가이드가 안드로이드폰에서 Gemini CLI를 성공적으로 사용하는 데 도움이 되기를 바랍니다!
