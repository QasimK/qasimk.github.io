---
layout: default
---

<section>
    <h1>Hi.</h1>
    <p>
        This is Yet Another Blog on Software, Tech and other things.
        As some background, I spend most of my day doing Software Engineering.
        Eventually, I'll link to some projects that are actually online, but
        for now it's a blog.
    </p>
    <ol>
        {% for post in site.posts %}
            <li>
                <a href="{{ post.url }}">{{ post.title }}</a>
                <small><nobr>
                        <time datetime="{{ post.date }}">{{ post.date | date_to_string }}</time>
                </nobr></small>
            </li>
        {% endfor %}
    </ol>
</section>
