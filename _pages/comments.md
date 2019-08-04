---
layout: comments-default
permalink: /comments/
---

<ul>
  {% assign sorted-comments = site.comments | sort: 'post_date' | reverse %}
  {% for post in sorted-comments %}
    <li>
      <time datetime="{{ post.date }}">{{ post.date | date_to_string }}</time>
      &raquo;
      {% if post.categories contains 'non-fiction' %}
        <i class="fas fa-pencil-alt"></i>
      {% endif %}
      {% if post.categories contains 'books'  %}
        <i class="fas fa-book"></i>
      {% endif %}
      {% if post.categories contains 'games' %}
        <i class="fas fa-gamepad"></i>
      {% endif %}
      {% if post.categories contains 'films' %}
        <i class="fas fa-film"></i>
      {% endif %}
      {% if post.categories contains 'tv-shows' %}
        <i class="fas fa-tv"></i>
      {% endif %}
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
