# RingCentral Avatars Tutorial Script

Hi there and welcome this tutorial on using the RingCentral REST API to create default avatars for the RingCentral Address Book.

This tutorial uses the community Ruby SDK and is available on Github as part of the RingCentral Avatars Ruby Gem.

## SLIDE

As you may know, RingCentral currently uses a single default avatar for all users without photos, but it is nice to have differentiated avatars for each user such as user initials or identicons. We'll cover how to do this in this tutorial using the RingCentral Profile Image API.

## SLIDE

For this tutorial and demo, the end result we want to achieve is updating the default avatars to use user initials as in this screenshot.

## SLIDE

We'll assume you know how to use the community Ruby SDK, including instantiation and authorization, so we'll move on to this specific use case. If you need to learn or brush up on SDK basics see the Ruby SDK's documentation on Read the Docs.

## SLIDE

To upload default avatars for all users without photos, we'll need to do three basic things.

First, we'll need to get a list of all users without avatars.

Then, for each user, we'll need to create and upload an avatar image.

Finally, we'll need to handle rate limit throttling for multiple API calls.

Let's take a look.

## SLIDE

To get a list a of users, we'll call the account extension API. This API can retrieve up to 1000 extensions at a time so if you have less than that in your account you won't have to do any paging. If you have more, you'll need to page.

To filter on users without an image, we'll look for the profile image etag property. If this property does not exist, then the user does not have an image. It is also updated whenever the image is updated so you can use it to check for changes.

## SLIDE

Here's what the profileImage property looks like in the extension object. You can see the etag, contentType and lastModified dates along with URIs for the images themselves.

## SLIDE

If you need to page, you should check the paging and navigation properties which tell you how may pages there are and provide URLs for you to follow.

## SLIDE

Here is some sample code for paging.

## SLIDE

Next let's create an avatar. We'll need to decide what kind of avatar we want to create. This can use user initials, identicons or even robots via the Robohash project. For this demo, we'll use user initials.

There are several good avatar libraries on RubyGems already. We'll use user initials which are a common default for applications such as Gmail and Exchange Online. For this, the avatarly gem provides good functionality. Identicons can be created using the ruby_identicon library.

## SLIDE

To upload the image we'll use the SDK's Faraday client and create a Faraday::UploadIO object to upload. We'll create a temp file first, create a Faraday::UploadIO object for that file and then send it to the API.

## SLIDE

Also, if we have many users in our address book, we'll need to consider rate limit throttling. When an application is throttled it will receive a status 429 error and a retry-after header populated with a value in seconds that the app should wait before retrying the API call. A simple way to do this is shown.

## SLIDE

In the case of the Ruby SDK, automatic retry handling including waiting is available simply by turning on the parameter to true. To perform this functionality, the SDK uses code from the Faraday Request Retry middleware which is linked at the bottom of the slide.

## SLIDE

Finally, let's put this all together. The RingCentral Avatars gem has an example script called update_avatars.rb that we'll run and see the avatars change in the RingCentral softphone.

## SLIDE

DEMO

Let's see a quick demo.

For this demo, I've configured my RingCentral credentials in the .ENV environment file which will be automatically loaded when using the load_env configuration parameter.

I'm also going to be overwriting existing avatars since I've already configured this account. When the avatars are updated on the server, the RingCentral softphone will receive a notifiation and automatically retrieve the new images, which will show up as different random colors.

<EXECUTE>

So there you have it, updating RingCentral address book avatars.

## SLIDE

I'd also like to thank WebPro for their Reveal-md project which was used to create this presentation. This presentation is written in Markdown and available online.

## SLIDE

The following resources are available and if you have any questions, please reach out to the RingCentral Developer Community or Stack Overflow. You can also reach me online using my handle, grokify.

This concludes this tutorial. Thank you for watching.