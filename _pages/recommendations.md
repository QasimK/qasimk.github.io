---
layout: default
permalink: /recommendations/
---

<section>
    <h1>My Recommendations</h1>
    <p>These recommendations don't come lightly.</p>
    <ul>
        {% for recommendation in site.data.recommendations %}
            <li>
                <a href="{{ recommendation.link }}">{{ recommendation.name }}</a>
                — {{ recommendation.description }}
            </li>
        {% endfor %}
    </ul>
</section>
