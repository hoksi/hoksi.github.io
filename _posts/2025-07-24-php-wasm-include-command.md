---
layout: single
title: "WebAssembly PHP에서 include 명령 사용하기: 가상 파일 시스템의 이해"
date: 2025-07-24 09:00:00 +0900
categories: [개발, 웹]
tags: [PHP, WebAssembly, Wasm, include, 파일시스템, VFS]
---

## WebAssembly PHP에서 `include` 명령 사용하기: 가상 파일 시스템의 이해

PHP 개발자라면 `include`나 `require`와 같은 명령어가 익숙하실 겁니다. 이 명령들은 다른 PHP 파일을 현재 스크립트에 포함시켜 코드 재사용성을 높이는 데 필수적입니다. 하지만 PHP가 WebAssembly(Wasm) 환경, 즉 웹 브라우저에서 실행될 때는 이 `include` 명령이 서버 환경과는 다르게 작동합니다. 그 핵심에는 **가상 파일 시스템(Virtual File System, VFS)**이 있습니다.

### 일반 PHP 환경에서의 `include`

전통적인 서버 환경에서 PHP 인터프리터는 `include` 명령을 만나면 서버의 실제 파일 시스템에 접근하여 지정된 파일을 찾아 읽고 실행합니다. 예를 들어, `include 'functions.php';`는 서버의 특정 경로에서 `functions.php` 파일을 찾아옵니다.

### WebAssembly PHP 환경에서의 `include`와 가상 파일 시스템

웹 브라우저는 보안상의 이유로 로컬 파일 시스템에 직접 접근하는 것을 엄격히 제한합니다. 따라서 WebAssembly로 컴파일된 PHP 인터프리터는 서버의 파일 시스템이나 클라이언트의 로컬 파일 시스템에 직접 접근할 수 없습니다. 대신, Emscripten과 같은 도구를 통해 구축된 **가상 파일 시스템(VFS)**을 사용합니다.

이 가상 파일 시스템은 웹 브라우저의 메모리 내에 존재하며, PHP 인터프리터는 이 가상 파일 시스템 내에서만 파일을 읽고 쓸 수 있습니다. `include` 명령도 이 가상 파일 시스템 내의 경로를 참조하게 됩니다.

### `include`할 파일을 가상 파일 시스템에 추가하는 방법

`include`할 PHP 파일이나 기타 리소스 파일들을 가상 파일 시스템에 추가하는 가장 일반적인 방법은 다음과 같습니다:

1.  **파일 사전 로딩 (Preloading Files):**
    WebAssembly 모듈이 로드되고 PHP 인터프리터가 초기화될 때, `include`할 모든 파일들을 미리 가상 파일 시스템에 로드해두는 방식입니다. `php-wasm` 라이브러리는 보통 인스턴스 생성 시 `files` 옵션 등을 통해 이 기능을 제공합니다.

    **예시:**
    `my_functions.php`라는 파일을 `include`하고 싶다면, JavaScript 코드에서 `php-wasm` 인스턴스를 초기화할 때 다음과 같이 파일을 가상 파일 시스템에 추가할 수 있습니다.

    ```javascript
    // JavaScript 코드 (예: assets/php-wasm-example/index.html)
    import { PhpWeb } from '../wasmPhp/PhpWeb.mjs';

    async function runPhp() {
        try {
            // files 옵션을 통해 가상 파일 시스템에 파일 추가
            const php = new PhpWeb({
                files: {
                    '/var/www/html/my_functions.php': `<?php function sayHello() { echo "Hello from included file!"; } ?>`
                }
            });

            php.addEventListener('ready', async () => {
                document.getElementById('output').textContent = '';

                // PHP 코드에서 가상 파일 시스템의 경로를 참조하여 include
                await php.run(
                    `<?php
                    include '/var/www/html/my_functions.php';
                    sayHello();
                    ?>`
                );
            });

        } catch (error) {
            document.getElementById('output').textContent = `오류 발생: ${error.message}`; 
            console.error("PHP Wasm 실행 중 오류 발생:", error);
        }
    }

    runPhp();
    ```

    위 예시에서는 `my_functions.php`의 내용을 직접 문자열로 전달했지만, 실제로는 `fetch` API 등을 사용하여 웹 서버에 호스팅된 파일을 비동기적으로 불러와 가상 파일 시스템에 추가할 수도 있습니다.

2.  **가상 디렉토리 마운트:**
    특정 디렉토리의 파일들을 통째로 가상 파일 시스템의 특정 경로에 마운트하는 방식도 가능합니다. 예를 들어, 블로그의 `assets/php-includes/` 디렉토리에 있는 모든 PHP 파일을 가상 파일 시스템의 `/app/includes/` 경로에 마운트하고, PHP 코드에서는 `include '/app/includes/my_functions.php';`와 같이 사용할 수 있습니다.

### 결론

WebAssembly PHP에서 `include` 명령은 서버의 실제 파일 시스템이 아닌, 웹 브라우저 메모리 내에 존재하는 **가상 파일 시스템**을 통해 작동합니다. 따라서 `include`할 파일들은 JavaScript 코드를 통해 이 가상 파일 시스템에 미리 로드되거나 마운트되어 있어야 합니다. 이 개념을 이해하면 웹 환경에서 PHP 애플리케이션을 더욱 유연하게 개발하고 배포할 수 있습니다.
