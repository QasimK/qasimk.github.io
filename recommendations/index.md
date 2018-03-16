---
layout: default
---

<section>
    <h1>My Non-Fiction Recommendations</h1>
    <p>The highest quality content I have found.</p>
    <ul>
        {% for recommendation in site.data.recommendations %}
            <li>
                <a href="{{ recommendation.link }}">{{ recommendation.name }}</a>
                — {{ recommendation.description }}
            </li>
        {% endfor %}
    </ul>
</section>
