# RingCentral Avatars Tutorial Script

Hi there and welcome this tutorial on using the RingCentral REST API. Here, we are going to cover how to use the RingCentral Profile Image API to upload default images to the RingCentral corporate address book. As you may know, RingCentral currently uses a single default avatar for all users without photos, but sometimes it may be nice to have differentiated avatars for each user such as user initials or identicons. We'll cover how to do this in this tutorial. The code we'll walk through is all avaialble on Github and as a working Ruby gem.

We'll assume you know how to instantiate the community Ruby SDK and perform authorization, so we'll move on to this specific use case. If you need to learn or brush up on SDK basics see the Ruby SDK documentation on Read the Docs.

To upload default avatars for all users without photos, we'll need to do a four basic things.

First, we'll need to get a list of users without avatars.

Then, for each user, we'll need to create an avatar image and upload it.

Finally, we'll need to handle rate limit throttling for multiple API calls.

Let's take a look.

To get a list a of users, we'll call the account extension API. This API can retrieve up to 1000 extensions at a time so if you have less than that in your account you won't have to do any paging. If you have more, you'll need to page.

Here's some simple code:


In the Ruby SDK, there is a user cache which can retrieve all extensions for local manipulation. Let's take a look:


To filter on users without an image, we'll look for the profile image etag property. If this property does not exist, then the user does not have an image.


Next let's create an avatar. We'll need to decide what kind of avatar we want to create. This can use user initials, identicons or even robots via the Robohash project. For this demo, we'll use user initials.

There are several good avatar libraries on RubyGems already. We'll use user initials which are a common default for applications such as Gmail and Exchange Online. For this, the avatarly gem provides good functionality. After creating the image blob using avatarly, we'll convert this to a Faraday::UploadIO object and then post this to the Profile Image endpoint as shown.


Also, if we have many users, we'll need to consider rate limit throttling. When an application is rate throttled it will receive a status 429 error and a retry-after header populated with a value in seconds that the app should wait before retrying the API call. In this case, the Ruby SDK will automatically do this for us if the retry configuration parameter is set to true, but let's still take a look at the code.


Finally, let's put this all together. The RingCentral Avatars gem has a script update_avatars.rb that we'll run and see the avatars change in the RingCentral mobile app.


So there you have it, updating RingCentral address book avatars. If you have any questions, please reach out on the RingCentral Developer Community or Stack Overflow.