import "node_modules/riot/riot.js";

import "./tags/article-form.tag";
import "./tags/article-list.tag";
import "./tags/admin-panel.tag";

riot.mount('article-form');   // Mount the 'article-form' tag
riot.mount('article-list');   // Mount the 'article-list' tag
riot.mount('admin-panel');    // Mount the 'admin-panel' tag


console.log('Tags mounted:', ['article-form', 'article-list', 'admin-panel']);
