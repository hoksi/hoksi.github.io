---
title: "Python을 이용한 최신 뉴스 수집 스크립트"
date: 2025-07-25 21:40:41 +0900
categories:
  - Python
  - Script
tags:
  - Python
  - News
  - RSS
  - feedparser
---

매일 쏟아지는 뉴스 속에서 핵심만 쏙쏙 뽑아보고 싶으신가요? 광고 없이 깔끔하게 최신 뉴스를 받아볼 수 있는 방법을 찾고 있다면, Python을 활용한 구글 뉴스 수집 스크립트가 좋은 해결책이 될 수 있습니다. `feedparser` 라이브러리를 이용하면 RSS 피드를 파싱하여 원하는 뉴스를 손쉽게 정리할 수 있습니다.

## `fetch_trending_news.py` 스크립트 소개

`fetch_trending_news.py` 스크립트는 구글 뉴스 RSS 피드를 읽어와 가장 이슈가 되는 뉴스 기사들의 제목과 링크를 추출합니다. 추출된 정보는 `news.md`라는 Markdown 파일로 저장되어, 언제든지 쉽게 뉴스를 확인할 수 있도록 합니다.

### 스크립트 코드

```python
import feedparser

def get_trending_news(num_articles=10, output_file="news.md"):
    # Google News RSS 피드 URL (가장 이슈가 되는 뉴스를 가져오기 위해 'top stories' 키워드 사용)
    url = "https://news.google.com/rss/search?q=top+stories+when:1d&hl=ko&gl=KR&ceid=KR:ko"

    try:
        feed = feedparser.parse(url)

        with open(output_file, "w", encoding="utf-8") as f:
            f.write("# 최근 가장 이슈가 되는 뉴스\n\n")
            print(f"최근 가장 이슈이 되는 뉴스 {num_articles}개를 {output_file}에 저장합니다.")

            for i, entry in enumerate(feed.entries):
                if i >= num_articles:
                    break
                title = entry.title
                link = entry.link
                
                # Markdown 형식으로 파일에 쓰기
                f.write(f"{i+1}. [{title}]({link})\n")
                print(f"{i+1}. {title} ({link})")

    except Exception as e:
        print(f"뉴스 정보를 가져오거나 파일에 쓰는 중 오류 발생: {e}")

if __name__ == "__main__":
    get_trending_news(100)
```

### 스크립트 설명

1.  **`feedparser` 라이브러리**: 이 스크립트의 핵심은 `feedparser` 라이브러리입니다. 이 라이브러리는 RSS 및 Atom 피드를 파싱하는 데 사용됩니다. 설치되어 있지 않다면 다음 명령어로 설치할 수 있습니다:
    ```bash
    pip install feedparser
    ```
2.  **`get_trending_news` 함수**:
    *   `num_articles`: 가져올 기사의 최대 개수를 지정합니다. 기본값은 10개입니다.
    *   `output_file`: 뉴스가 저장될 Markdown 파일의 이름을 지정합니다. 기본값은 `news.md`입니다.
    *   `url`: 구글 뉴스 RSS 피드 URL입니다. `q=top+stories+when:1d` 파라미터를 통해 지난 24시간 동안의 'top stories'를 검색하도록 설정되어 있습니다.
3.  **RSS 피드 파싱**: `feedparser.parse(url)`을 사용하여 지정된 URL에서 RSS 피드를 가져와 파싱합니다.
4.  **파일 저장**: `news.md` 파일을 쓰기 모드(`"w"`)로 열고, 각 뉴스 기사의 제목과 링크를 Markdown 형식으로 작성합니다.
5.  **오류 처리**: `try-except` 블록을 사용하여 뉴스 정보를 가져오거나 파일에 쓰는 도중 발생할 수 있는 오류를 처리합니다.

### 스크립트 실행 방법

1.  위 코드를 `fetch_trending_news.py` 파일로 저장합니다.
2.  터미널에서 다음 명령어를 실행하여 필요한 라이브러리를 설치합니다:
    ```bash
    pip install feedparser
    ```
3.  스크립트를 실행합니다:
    ```bash
    python fetch_trending_news.py
    ```

### 결과 확인

스크립트 실행이 완료되면, 스크립트가 실행된 디렉토리에 `news.md` 파일이 생성됩니다. 이 파일을 열어보면 다음과 같이 최신 뉴스 목록을 확인할 수 있습니다:

```markdown
# 최근 가장 이슈가 되는 뉴스

1. [뉴스 기사 제목 1](뉴스 기사 링크 1)
2. [뉴스 기사 제목 2](뉴스 기사 링크 2)
...
```

이 스크립트를 활용하면 매일 아침 최신 뉴스를 자동으로 받아보고, 중요한 소식을 놓치지 않을 수 있습니다. 필요에 따라 `num_articles` 값을 조절하여 더 많은 뉴스를 가져오거나, `url`을 변경하여 특정 주제의 뉴스를 수집할 수도 있습니다.

