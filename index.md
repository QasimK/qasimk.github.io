---
layout: default
---

<section>
    <h1>Hi.</h1>
    <p>
        I have some <a href="https://github.com/QasimK">open-source
        projects</a> and some personal projects. I may list them here one day.
    </p>
    <p>
        I am writing <a href="https://qasimk.gitbooks.io/programmers-compendium/content/">The Programmer's Compendium</a> (for myself but you might find it useful). It also aggregates high-quality reference or learning materials for Software Engineering.
    </p>
    <p>
        I have a small list of <a href="/recommendations/">recommendations</a>
        for high-quality content that stood out to me.
    </p>
    <p>
        This is the complete collection of posts:
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
        Excluding the following probably-outdated posts:
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
