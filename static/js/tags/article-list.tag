<riot-tag>
  <h2>Articles</h2>
  <ul>
    <li each="{ article in articles }">
      <h3>{ article.title }</h3>
      <p>{ article.content }</p>
    </li>
  </ul>

  <script>
    this.articles = [];

    this.fetchArticles = async () => {
      const response = await fetch('/api/get-articles');
      if (response.ok) {
        const data = await response.json();
        this.articles = data.articles;
        riot.update();
      }
    };

    // Call fetchArticles when the tag mounts
    this.on('mount', this.fetchArticles);
  </script>
</riot-tag>
