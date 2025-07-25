---
title: "Termux 플러그인: 설치 및 활용 가이드"
date: 2025-07-25 10:00:00 +0900
categories: [Android, Termux]
tags: [Termux, Plugin, Android, CLI]
---

안드로이드 기기에서 Termux를 사용하고 계신가요? Termux의 잠재력을 최대한 끌어올리고 싶다면, 다양한 플러그인(애드온)을 활용하는 것이 필수입니다. 이 포스팅에서는 Termux의 기능을 확장하고 안드로이드 시스템과 더욱 긴밀하게 통합할 수 있는 주요 플러그인들의 설치 방법과 실용적인 사용 예시를 소개합니다.

## Termux 플러그인이란?

Termux 플러그인은 Termux 앱의 기능을 확장하여 안드로이드 기기의 하드웨어 및 소프트웨어 기능에 접근하거나, Termux 환경을 더욱 편리하게 사용할 수 있도록 돕는 별도의 안드로이드 애플리케이션입니다.

**중요**: Termux와 모든 플러그인은 **동일한 소스**에서 설치하는 것이 중요합니다. 호환성 문제를 피하기 위해 **F-Droid**에서 설치하는 것을 강력히 권장합니다. Google Play 스토어와 F-Droid에서 혼합하여 설치할 경우 서명 키 불일치로 인해 문제가 발생할 수 있습니다.

## 주요 Termux 플러그인

다음은 일반적으로 사용되는 Termux 플러그인 목록입니다:

*   **Termux:API**: 안드로이드 기기의 하드웨어(배터리, 카메라, GPS 등) 및 소프트웨어 기능에 접근할 수 있도록 합니다.
*   **Termux:Boot**: 기기 부팅 시 특정 스크립트를 자동으로 실행할 수 있게 합니다.
*   **Termux:Float**: 플로팅(떠다니는) Termux 창을 제공하여 다른 앱을 사용하면서 Termux를 동시에 사용할 수 있습니다.
*   **Termux:Styling**: Termux 터미널의 색상 스키마와 폰트를 커스터마이징할 수 있습니다.
*   **Termux:Tasker**: Tasker와 같은 자동화 앱과 연동하여 Termux 명령을 실행할 수 있도록 합니다.
*   **Termux:Widget**: 안드로이드 홈 화면에 위젯을 추가하여 Termux 스크립트를 빠르게 실행할 수 있습니다.
*   **Termux:GUI**: 명령줄 프로그램이 네이티브 안드로이드 GUI 구성 요소를 사용할 수 있도록 합니다. (현재 개발 중)

## 플러그인 설치 및 사용 예시

대부분의 Termux 플러그인은 일반 안드로이드 앱처럼 설치합니다. F-Droid 앱 스토어에서 `Termux:` 접두사가 붙은 앱들을 검색하여 설치할 수 있습니다.

### 1. Termux:API

Termux:API는 안드로이드 기기의 다양한 센서 및 기능에 접근할 수 있게 해주는 핵심 플러그인입니다.

**설치**:
1.  F-Droid에서 "Termux:API" 앱을 설치합니다.
2.  Termux 앱 내에서 `pkg install termux-api` 명령어를 실행하여 API 도구를 설치합니다.

**사용 예시**:
*   **배터리 상태 확인**:
    ```bash
    termux-battery-status
    ```
*   **기기 진동**:
    ```bash
    termux-vibrate -d 1000 # 1000밀리초(1초) 동안 진동
    ```
*   **카메라 사진 촬영**:
    ```bash
    termux-camera-photo -c 0 ~/camera_photo.jpg # 후면 카메라(0)로 사진 촬영
    ```

### 2. Termux:Tasker

Tasker와 같은 자동화 앱을 사용하여 Termux 명령을 실행하고 자동화할 수 있습니다.

**설치**:
1.  F-Droid에서 "Termux:Tasker" 앱을 설치합니다.

**사용 예시**:
Tasker 앱에서 Termux 스크립트를 실행하는 예시입니다. (Tasker 앱 설치 및 기본 사용법은 별도로 숙지해야 합니다.)

1.  Termux에서 실행할 스크립트를 작성합니다. 예: `~/my_script.sh`
    ```bash
    #!/data/data/com.termux/files/usr/bin/bash
    echo "Hello from Tasker!" > ~/tasker_output.txt
    termux-toast "Tasker script executed!"
    ```
2.  스크립트에 실행 권한을 부여합니다: `chmod +x ~/my_script.sh`
3.  Tasker 앱을 엽니다.
4.  새로운 `Task`를 생성합니다.
5.  `Action`으로 `Plugin` -> `Termux:Tasker`를 선택합니다.
6.  `Configuration`에서 `Executable` 필드에 `~/my_script.sh`를 입력합니다.
7.  이 Task를 특정 `Profile`(예: 특정 Wi-Fi 연결 시, 특정 시간)에 연결하여 자동화합니다.

### 3. Termux:Widget

홈 화면 위젯을 통해 Termux 스크립트를 빠르게 실행할 수 있습니다.

**설치**:
1.  F-Droid에서 "Termux:Widget" 앱을 설치합니다.

**사용 예시**:
Termux 패키지를 업데이트하는 위젯을 만드는 예시입니다.

1.  위젯용 스크립트를 저장할 디렉토리를 생성합니다:
    ```bash
    mkdir -p ~/.shortcuts
    ```
2.  업데이트 스크립트 파일을 생성합니다. 예: `~/.shortcuts/update_termux.sh`
    ```bash
    #!/data/data/com.termux/files/usr/bin/bash
    termux-toast "Updating Termux packages..."
    pkg update && pkg upgrade -y
    termux-toast "Termux update complete!"
    ```
3.  스크립트에 실행 권한을 부여합니다:
    ```bash
    chmod +x ~/.shortcuts/update_termux.sh
    ```
4.  안드로이드 홈 화면에서 위젯 추가 기능을 통해 "Termux:Widget"을 선택합니다.
5.  위젯을 추가하면 `~/.shortcuts` 디렉토리 내의 스크립트 목록이 표시되며, `update_termux.sh`를 선택하여 위젯으로 추가할 수 있습니다. 이제 이 위젯을 탭하면 스크립트가 실행됩니다.

## ZSH 플러그인 (선택 사항)

Termux 자체 플러그인은 아니지만, ZSH 쉘을 사용하는 경우 `oh-my-zsh`와 같은 프레임워크를 통해 다양한 ZSH 플러그인을 설치하여 터미널 환경을 크게 개선할 수 있습니다.

**예시: ZSH Syntax Highlighting 설치**

1.  ZSH 및 `git` 설치:
    ```bash
    pkg install zsh git
    ```
2.  ZSH Syntax Highlighting 플러그인 클론:
    ```bash
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    ```
3.  `~/.zshrc` 파일을 편집하여 `plugins` 배열에 `zsh-syntax-highlighting`을 추가합니다.
    ```bash
    # .zshrc 파일 내용 중
    plugins=(
        git
        zsh-syntax-highlighting # 이 줄 추가
    )
    ```
4.  변경 사항 적용:
    ```bash
    source ~/.zshrc
    ```

이제 명령어를 입력할 때 구문 강조가 적용되어 가독성이 향상됩니다.

Termux 플러그인을 활용하면 안드로이드 기기에서 더욱 강력하고 편리한 리눅스 환경을 구축할 수 있습니다. 필요에 따라 적절한 플러그인을 설치하고 활용하여 생산성을 높여보세요!
