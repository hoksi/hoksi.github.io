---
title:  "Mac에서 Jekyll 설치를 위한 Ruby 버전 업그레이드"
date:   2025-07-23 11:10:00 +0900
categories: [Jekyll, 개발]
---

# Ruby 버전 업그레이드 (rbenv 및 RVM 사용)

Ruby 버전 관리 도구인 `rbenv`와 `RVM`은 시스템 Ruby에 영향을 주지 않고 여러 Ruby 버전을 설치하고 관리할 수 있게 해줍니다. 이 문서는 두 도구를 사용하여 Ruby를 업그레이드하는 방법을 안내합니다.

## 1. rbenv를 이용한 Ruby 업그레이드

`rbenv`는 가볍고 유연한 Ruby 버전 관리 도구입니다. 이미 `rbenv`가 설치되어 있고 초기화되었다고 가정합니다.

### 1.1. 설치 가능한 Ruby 버전 확인

먼저 설치할 수 있는 Ruby 버전 목록을 확인합니다.

```bash
rbenv install -l
```

### 1.2. 새로운 Ruby 버전 설치

원하는 Ruby 버전을 설치합니다. (예: 3.2.2)

```bash
rbenv install 3.2.2
```

설치 과정은 시스템 환경에 따라 다소 시간이 걸릴 수 있습니다.

### 1.3. 전역(Global) Ruby 버전 설정

설치한 새 Ruby 버전을 시스템의 기본값으로 설정합니다.

```bash
rbenv global 3.2.2
```

### 1.4. 로컬(Local) Ruby 버전 설정 (선택 사항)

특정 프로젝트 디렉토리에서만 특정 Ruby 버전을 사용하고 싶다면, 해당 디렉토리로 이동하여 다음 명령어를 실행합니다.

```bash
rbenv local 3.2.2
```

### 1.5. 변경 사항 적용 및 확인

`rbenv`가 변경 사항을 인식하도록 셸을 다시 로드하거나 `rehash` 명령어를 실행합니다.

```bash
rbenv rehash
ruby -v
```

`ruby -v` 명령어를 통해 새로 설정한 Ruby 버전이 출력되는지 확인합니다.

## 2. RVM (Ruby Version Manager)을 이용한 Ruby 업그레이드

`RVM`은 `rbenv`보다 더 많은 기능을 제공하는 포괄적인 Ruby 환경 관리 도구입니다. 이미 `RVM`이 설치되어 있다고 가정합니다.

### 2.1. 설치 가능한 Ruby 버전 확인

설치할 수 있는 Ruby 버전 목록을 확인합니다.

```bash
rvm list known
```

### 2.2. 새로운 Ruby 버전 설치

원하는 Ruby 버전을 설치합니다. (예: 3.2.2)

```bash
rvm install 3.2.2
```

설치 과정은 다소 시간이 걸릴 수 있습니다.

### 2.3. 기본(Default) Ruby 버전 설정

설치한 새 Ruby 버전을 시스템의 기본값으로 설정합니다.

```bash
rvm use 3.2.2 --default
```

### 2.4. 특정 프로젝트에서 Ruby 버전 설정 (선택 사항)

특정 프로젝트 디렉토리에서만 특정 Ruby 버전을 사용하고 싶다면, 해당 디렉토리로 이동하여 다음 명령어를 실행합니다.

```bash
rvm use 3.2.2
```

### 2.5. 변경 사항 확인

`ruby -v` 명령어를 통해 새로 설정한 Ruby 버전이 출력되는지 확인합니다.

```bash
ruby -v
```

## 3. Bundler 재설치 (필수)

새로운 Ruby 버전을 설치한 후에는 해당 Ruby 환경에 맞게 Bundler를 다시 설치해야 합니다.

```bash
gem install bundler
```

## 중요 사항

*   **기존 프로젝트**: 기존 Ruby 프로젝트가 있다면, 새 Ruby 버전으로 전환한 후 해당 프로젝트 디렉토리에서 `bundle install`을 다시 실행하여 의존성을 업데이트해야 할 수 있습니다.
*   **환경 변수**: `rbenv`나 `RVM`을 설치할 때 셸 설정 파일(예: `.zshrc`, `.bash_profile`)에 올바른 환경 변수가 추가되었는지 확인해야 합니다.
*   **Jekyll 호환성**: Jekyll은 특정 Ruby 버전을 요구할 수 있으므로, Jekyll 공식 문서에서 권장하는 Ruby 버전을 확인하는 것이 좋습니다.
