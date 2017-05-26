---
layout: default
---

<section>
    <h1>Hi.</h1>
    <p>
        This is the complete collection of posts.
    </p>
    <ol>
        {% for post in site.posts %}
            {% unless post.tags contains 'outdated' %}
                <li>
                    <a href="{{ post.url }}" tags="{{ post.tags }}">{{ post.title }}</a>
                    <small><nobr>
                           <time datetime="{{ post.date }}">{{ post.date | date_to_string }}</time>
                    </nobr></small>
                </li>
            {% endif %}
        {% endfor %}
    </ol>
</section>
