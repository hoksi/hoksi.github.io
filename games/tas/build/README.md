# 아케이드 TAS 도구: 에뮬레이터 빌드

`../mame/`의 `wboy.js/.wasm`(원더보이), `twincobr.js/.wasm`(트윈 코브라)은 [MAME 0.285](https://github.com/mamedev/mame/tree/mame0285)(GPL-2.0+)를
Emscripten(emcc 6.0.13)으로 게임마다 드라이버 하나만 넣어 빌드한 파일이에요.

- `build.sh`: 빌드 순서 그대로예요. `./build.sh /path/to/emsdk wboy sega/system1.cpp`, `./build.sh /path/to/emsdk twincobr toaplan/twincobr.cpp`
- `sdlprefix.patch`: 소스에 한 군데 고친 곳(새 Emscripten과 겹치는 정의 한 줄을 주석 처리)
- `../mame/tas.lua`: 페이지가 MAME에 넘기는 TAS 스크립트(일시정지, 프레임 진행, 되돌리기, 입력 기록·재생, 연사)
- `../lib/`: [sql.js](https://github.com/sql-js/sql.js) 1.10.3 (MIT), 기록 보관함용

롬은 들어 있지 않아요.
