**The Tale of Ostensibly Notmeh the Wise**

Notmeh was a developer from the Land of Rainbows and Unicorns. He joined a team rapidly developing a web application using Django and Postgres. He'd been using Django since it was one. He felt great.

Very early on, he picked up a ticket that simply said "Upgrade DB server". It didn't say much else, there were security updates for the server so it had to be done. He SSH'ed into the server and did a simple "sudo apt update && sudo apt ugprade". He was curious, and so he watched the walls of text fly by as it had been quite a while since the last one.

His spotting of a line that said "restarting postgresql service" was neither fortunate, nor unfortunate. In horror, he saw the website 504. On this day he realised two things:

1. He had grossly misunderstood the stories of linux server uptimes.
2. Downtime was unacceptable for clients.

This was a migration but by any other name.

**Time passes**

The single server scaled like any good little web application:

* A separate database
* Separate blue and green servers for deployment
* Though they kept their background workers on the same app server.




**One day**, Notmeh wanted to speed things up, he remembered the wise words of his master: use the index lu-notmeh. So he **added an index to a column**.

Disaster struck.

Queries were timing out left, right and center.

On this day he learnt:

1. Creating an index locks the table preventing any writes from occuring. This can cause query timeouts and hence outright request failures!
2. Create Index Concurrently

**One day**, Notmeh wanted to **remove a non-nullable field**.

He of course remove all the code that referred to it in a separate pull request.

Disaster struck.

On this day he learnt:

1. Make it nullable.
2. Remove the field definition,
3. Then remove the field from the database.

This was because:

* The "old code" still has the field definition for all new inserts and Django was trying to insert a value for the write.



You might think at this stage, he is Ostensibly Notmeh the Wise and knows the ways of the database.

**Much time passed...**

And some things that should not have been forgotten were lost.
History became legend.
And Legend became myth.
And for Two and a half Thousand hours the wiki page passed out of all knowledge.


**One day**, Notmeh wanted to code review a pull request that **added a new field**.

But the screams and blood from that day hold testament: he was not yet Ostensibly Notmeh the Wise.

On this day he learnt, that complacency *kills*:

1. Writing a mere deployment manual was not enough.
2. Process stuff.

He went home that day 

**One day**, Notmeh wanted to **rename a field** to refactor.

He realised it was 

His Magnum Opus complete.

On this day, he learnt little. But he was not yet Wise.

On the way home, he felt uneasy. A great accomplishment, but for so little gain?

That night he had a prophecy.


**The great renaming** (Model Rename)

Much time passes

If you went to DDD talk, he talked about ubiquitous language, and now we seriously need to refactor our code to match the problem domains.

...

Notmeh fled.

On this day, Ostensibly Notmeh became Ostensibly Notmeh the Wise.

Some say, as the glass shattered, one could hear him whispering under his breath: "there has got to be a better way".

I will now take **Questions**.

Notmeh is not present to take your questions, either because he is fearful of *the* question that might be asked, or because *he does not exist*. I'm not sure which is the bigger problem here.