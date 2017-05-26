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
                    <a href="{{ post.url }}" tags="{{ post.tags | array_to_sentence_string:'' }}">{{ post.title }}</a>
                    <small><nobr>
                           <time datetime="{{ post.date }}">{{ post.date | date_to_string }}</time>
                    </nobr></small>
                </li>
            {% endunless %}
        {% endfor %}
    </ol>

    <p>
        Excluding the following outdated posts.
    </p>
    <ol>
        {% comment %} TODO: Deal with duplication {% endcomment %}
        {% for post in site.posts %}
            {% if post.tags contains 'outdated' %}
                <li>
                    <a href="{{ post.url }}" tags="{{ post.tags | array_to_sentence_string:'' }}">{{ post.title }}</a>
                    <small><nobr>
                           <time datetime="{{ post.date }}">{{ post.date | date_to_string }}</time>
                    </nobr></small>
                </li>
            {% endif %}
        {% endfor %}
    </ol>
</section>
