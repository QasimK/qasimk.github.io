---
layout: default
---

<section>
    <h1>Hi.</h1>
    <p>
        I maintain a small list of <a href="{{ site.baseurl }}/recommendations/">recommendations</a> for broadly-accessible, high-quality content that stood out to me.
    </p>
    <p>
        I have some <a href="https://github.com/QasimK">open-source
        projects</a> and some personal projects. I may list those here one day. I'd like to do more <a href="{{ site.baseurl }}/talks/">software engineering talks</a>.
    </p>
    <p>
        I'm writing <a href="https://qasimk.gitbooks.io/programmers-compendium/content/">The Programmer's Compendium</a> (for myself but you might find it useful). It also aggregates high-quality reference or learning materials for Software Engineering. I'm also writing <a href="https://qasimk.gitbooks.io/piserver-book/content/">The PiServer Book</a> about a Raspberry Pi home server. <em>Both books are largely incomplete.</em>
    </p>
    <p>
        Finally, I have written articles (and <a href="{{ site.baseurl }}/scribbles/">scribbled a bunch of thoughts</a>) like any good personal website:
    </p>
    <ol reversed>
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
    <ol reversed>
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
