import json
import os
import tornado.ioloop
import tornado.web
from tornado.escape import json_decode
import psycopg2


class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.render("templates/index.html") 

# Database connection
conn = psycopg2.connect(
    database="postgres",
    user="postgres",
    password="020401",
    host="localhost",
    port="5432"
)

class AddArticleHandler(tornado.web.RequestHandler):
    def post(self):
        data = json_decode(self.request.body)
        title = data.get("title")
        content = data.get("content")

        cursor = conn.cursor()
        cursor.execute("INSERT INTO articles (title, content) VALUES (%s, %s)", (title, content))
        conn.commit()
        cursor.close()

        self.set_status(201)  # Created
        self.finish()

class GetArticlesHandler(tornado.web.RequestHandler):
    def get(self):
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM articles")
        articles = cursor.fetchall()
        cursor.close()

        self.write({"articles": articles})

class DeleteArticleHandler(tornado.web.RequestHandler):
    def delete(self, article_id):
        cursor = conn.cursor()
        cursor.execute("DELETE FROM articles WHERE id = %s", (article_id,))
        conn.commit()
        cursor.close()

        self.set_status(204)  # No Content
        self.finish()

class CustomStaticFileHandler(tornado.web.StaticFileHandler):
    def get_content_type(self):
        return "application/javascript"


def make_app():
    settings = {
        "static_path": os.path.join(os.path.dirname(__file__), "static"),  # Adjust the path accordingly
        "static_url_prefix": "/static/",

    }
    
    return tornado.web.Application([
        (r"/api/add-article", AddArticleHandler),
        (r"/api/get-articles", GetArticlesHandler),
        (r"/api/delete-article/([0-9]+)", DeleteArticleHandler),
        (r"/static/tags/(.*\.tag)", CustomStaticFileHandler, {"path": settings["static_path"]}),
        (r"/static/(.*)", tornado.web.StaticFileHandler, {"path": "static"}),
        (r"/node_modules/(.*)", tornado.web.StaticFileHandler, {"path": "node_modules"}),
        (r"/", MainHandler),
    ], **settings)


if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()
