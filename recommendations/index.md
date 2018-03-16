---
layout: default
---

<section>
    <h1>My Non-Fiction Recommendations</h1>
    <p>The highest quality content I have found.</p>
    <ul>
        {% for recommendation in site.data.recommendations %}
              <li>
                <a href="{{ recommendation[1] }}">
                  {{ member[0] }}
                </a>
              </li>
        {% endfor %}
    </ul>
</section>
