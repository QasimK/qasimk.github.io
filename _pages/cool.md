---
layout: default-simple
permalink: /cool/
redirect_from:
  - /recommendations/
---

<section>
    <h1>Cool Things I've Come Across</h1>
    <ul>
        {% for cool in site.data.cool %}
            <li>
                <a href="{{ cool.link }}">{{ cool.name }}</a>
                — {{ cool.description }}
            </li>
        {% endfor %}
    </ul>
</section>
