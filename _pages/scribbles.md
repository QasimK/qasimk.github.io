---
layout: default
permalink: /scribbles/
---

<section>
    <h1>A Stream of Fragments of my Conciousness</h1>
    <p>It's like twitter but without the junk</p>
    <table>
        {% for scribble in site.data.scribbles %}
            <tr style="vertical-align: top;">
                <td><strong><time datetime="{{ scribble.date | date_to_xmlschema }}">{{ scribble.date }}</time></strong></td>
                <td>{{ scribble.text | markdownify | remove: '<p>' | remove: '</p>' }}</td>
            </tr>
        {% endfor %}
    </table>
</section>
