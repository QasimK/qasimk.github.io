---
layout: default-simple
permalink: /comments/films/
---

<style>
    li::marker {
        opacity: 0.5;
    }
</style>

<section>
    <h1>An ordered list of films</h1>
    <ol>
        {% for film in site.data.films %}
            <li>
                {{ film.name }}
            </li>
        {% endfor %}
    </ol>
    <!--
    <table>
        {% for film in site.data.films %}
            <tr style="vertical-align: top;">
                <td>
                    {{ forloop.index }}{{ film.name }}
                </td>
            </tr>
        {% endfor %}
    </table>
    -->
</section>
