---
layout: default-simple
permalink: /talks/
---

<section>
    <h1>My Talks</h1>
    <ul>
        {% assign sorted-talks = site.talks | sort: 'post_date' | reverse %}
        {% for talk in sorted-talks %}
            <li>
                <em>{{ talk.title }}</em>
                <br>
                @ {{ talk.where }} —
                {% if talk.video %}
                    <a href="{{ talk.video }}">Video</a> |
                {% endif %}
                <a href="{{ talk.url }}">Slides</a>
            </li>
        {% endfor %}
    </ul>
</section>
