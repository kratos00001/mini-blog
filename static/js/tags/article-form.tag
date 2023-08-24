<riot-tag>
  <form>
    <h2>Add New Article</h2>
    <label>Title:</label>
    <input type="text" name="title" value="{ this.title }">
    <label>Content:</label>
    <textarea name="content" value="{ this.content }"></textarea>
    <button onclick="{ this.addArticle }">Add Article</button>
  </form>

  <script>
    this.title = "";
    this.content = "";

    this.addArticle = async () => {
      const response = await fetch('/api/add-article', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          title: this.title,
          content: this.content,
        }),
      });

      if (response.ok) {
        // Reset form fields
        this.title = "";
        this.content = "";

        // Fetch updated articles after adding
        this.fetchArticles();
      }
    };

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
