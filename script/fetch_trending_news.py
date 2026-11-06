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
