I really want a photo app that lets groups of people share photos from an event or trip, and minimises the need to delete photos.

* Photos stored on your device
* Photos synced to your other devices
* Collections synced to selected other devices
* Search by time, location, person, object

When you take a photo:

1. Person and object recognition information is stored on the photo
2. The photo is sorted into automatic collections
3. Photo is deduplicated into a "photo set".
4. Thumbnails are generated
5. The photo is synced to other devices
    a. It is synced to all of your devices
    b. It is synced to devices owning that collection

Views of your photo:

1. Photo stream - every single photo in chronological order
2. World map - photos by collection (time, location)
3. Shared collections

Types of collections:

1. Automatic collections (time, location)
2. Automatic collections (person)
3. Automatic collections (object)
4. Named collection of automatic collections (trips / events)
5. Shared collection of existing collection

Collections:

1. Automatic collections (time, location) can be named
2. Automatic collections (person) can be named
3. Automatic collections (object) cannot be named
4. Manual collections can be created
5. Photos can be added to multiple collections
6. A trip collection can be composed of multiple collections (time, location)

A shared collection:

1. Anyone can add & remove photos
2. It can be "activated" - automatically add photos to this collection
3. Can be individually "locked" - do not add or delete photos

What is not shared:

1. Person recognition metadata
2. Favourite photos metadata

When I view my photos:

1. Similar photos are grouped into "photo sets"; I have to jump into a photo to see other similar photos
2. Timelines are fast & easy to scrub through
3. Videos start automatically start playing muted
4. I can favourite photos from a collection which will appear first

UI:

    [My Photo Stream]
        (Shared with my other devices)
        [Time, Location Collections]
        [Person collections]
        [Object collections]

    [South Wales 2021]
        Shared with: Friend-Phone, Brother-Desktop
        Share My Collections:
            2021-04-05-10-00-Liverpool
            2021-04-06-Bala
        Shared With Me Collections:
            Brother-Desktop-South-Wales-2021


What is not considered:

1. Screenshots




?????????????

Desktop folder structure (with symlinks):

    Library/
        Stream/
            DCIM1024.jpeg
        Collections/
            2021-Photo-Stream/
                2021-04-05-DCIM1024.jpeg
            2021-04-South-Wales
        People/
            Brother/
                2021-04-05-DCIM1024.jpeg

EXIF info:

1. Time
2. Location
3. People
4. Objects
5. Album (desktop folder)

