<riot-tag>
  <h2>Admin Panel</h2>
  <ul>
    <li each="{ article in articles }">
      <h3>{ article.title }</h3>
      <p>{ article.content }</p>
      <button onclick="{ () => this.deleteArticle(article.id) }">Delete</button>
    </li>
  </ul>

  <script>
    this.articles = [];

    this.deleteArticle = async (articleId) => {
      const response = await fetch(`/api/delete-article/${articleId}`, {
        method: 'DELETE',
      });

      if (response.ok) {
        // Remove the deleted article from the list
        this.articles = this.articles.filter(article => article.id !== articleId);
        riot.update();
      }
      this.fetchArticles = async () => {
      const response = await fetch('/api/get-articles');
      if (response.ok) {
        const data = await response.json();
        this.articles = data.articles;
        riot.update();
      }
    };

    this.deleteArticle = async (articleId) => {
      const response = await fetch(`/api/delete-article/${articleId}`, {
        method: 'DELETE',
      });

      if (response.ok) {
        // Fetch updated articles after deleting
        this.fetchArticles();
      }
    };

    // Call fetchArticles when the tag mounts
    this.on('mount', this.fetchArticles);
  </script>
</riot-tag>
