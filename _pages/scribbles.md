---
layout: default-simple
permalink: /scribbles/
---

<section>
    <h1>A Stream of Fragments of my Consciousness</h1>
    <p>It's like twitter but without the junk.</p>
    <table>
        {% for scribble in site.data.scribbles %}
            <tr style="vertical-align: top;">
                <td style="white-space: nowrap; padding-bottom: 0.5em">
                    <strong><time datetime="{{ scribble.date | date_to_xmlschema }}">{{ scribble.date }}</time></strong>
                </td>
                <!-- TODO: Move into CSS !-->
                <td style="padding: 0.5em; padding-top: 0;">
                    {{ scribble.text | markdownify | remove: '<p>' | remove: '</p>' }}
                </td>
            </tr>
        {% endfor %}
    </table>
</section>
