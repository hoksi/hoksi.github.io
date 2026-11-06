#!/bin/bash

# 인자로 파일명을 받습니다.
FILE_PATH="$1"

# 파일 경로가 제공되었는지 확인합니다.
if [ -z "$FILE_PATH" ]; then
  echo "사용법: $0 <파일_경로>"
  echo "예시: $0 _posts/2025-07-25-my-new-post.md"
  exit 1
fi

# 파일이 존재하는지 확인합니다.
if [ ! -f "$FILE_PATH" ]; then
  echo "오류: 파일 '$FILE_PATH'을(를) 찾을 수 없습니다."
  exit 1
fi

# 현재 날짜와 시간을 YYYY-MM-DD HH:MM:SS +ZZZZ 형식으로 가져옵니다.
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S %z")

# 파일에 "{date-now}" 문자열이 있는지 확인합니다.
if grep -q "{date-now}" "$FILE_PATH"; then
  # "{date-now}"를 현재 날짜와 시간으로 대체합니다.
  # GNU sed (Termux에서 주로 사용) 호환성을 위해 -i 옵션 뒤에 빈 문자열을 제거합니다.
  sed -i "s/{date-now}/$CURRENT_DATE/g" "$FILE_PATH"
  echo "파일 '$FILE_PATH'의 '{date-now}'를 '$CURRENT_DATE'로 업데이트했습니다."
else
  echo "파일 '$FILE_PATH'에서 '{date-now}'를 찾을 수 없습니다. 아무것도 수정하지 않았습니다."
fi
