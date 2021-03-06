AE = Artificial.Everywhere
AT = Artificial.Telepathy
LOI = LandsOfIllusions
PAA = PixelArtAcademy

# Process a post url.
PAA.Practice.CheckIn.getExternalUrlImage.method (url) ->
  check url, String

  ogImageRegex = /og:image"\s*content="([^"]+)"/

  # See if url is already an image.
  try
    response = HTTP.get url
    contentType = response.headers['content-type']

    # Return the url directly if content type is an image.
    return url if /image/.test contentType

  catch
    throw new AE.ArgumentException "The provided url is not valid."

  # It is not, so let's parse the url to find what service it belongs to.
  if /twitter\.com/.test url
    tweetId = url.split('/status/')[1]
    tweetData = AT.Twitter.statuses.show
      id: tweetId
      tweet_mode: 'extended'

    throw new AE.InvalidOperationException "There was an error communicating with the server. Either the tweet doesn't exist, or the server is down - try again later!" unless tweetData
    throw new AE.ArgumentException "The tweet has no images associated with it." unless tweetData.entities?.media?[0]?.media_url_https

    return tweetData.entities.media[0].media_url_https

  else if /imgur\.com/.test url
    # HACK: Look for the og:image tag in the head and remove the ?fb parameter.
    results = ogImageRegex.exec response.content
    return results[1].replace('?fb', '') if results[1]

  # We didn't find a custom importer so let's try a general approach and look for the og:image tag in the head.
  results = ogImageRegex.exec response.content
  return results[1] if results?[1]

  # We don't know what to do with this url yet.
  throw new AE.InvalidOperationException "We do not yet support importing images from the given website. The check-in will include a link to your post."

# Import check-ins from the imported database and assign them to the given character.
PAA.Practice.CheckIn.import.method (characterId) ->
  check characterId, Match.DocumentId

  # Make sure the character belongs to the current user.
  LOI.Authorize.characterAction characterId

  user = Meteor.user()

  # Try to match by registered emails.
  if user.registered_emails
    for email in user.registered_emails
      continue unless email.verified

      # Find the checkIns in imported data.
      importedCheckIns = PAA.Practice.ImportedData.CheckIn.documents.find(
        backerEmail: email.address
      ).fetch()

      console.log "Found", importedCheckIns.length, "check-ins for email", email.address

      for importedCheckIn in importedCheckIns
        checkIn = PAA.Practice.CheckIn.documents.findOne
          'character._id': characterId
          time: importedCheckIn.timestamp

        # Create the check-in if needed.
        if checkIn
          checkInId = checkIn._id

        else
          checkInId = PAA.Practice.CheckIn.insert characterId, importedCheckIn.timestamp
        
        PAA.Practice.CheckIn.updateText checkInId, importedCheckIn.text
        PAA.Practice.CheckIn.updateUrl checkInId, importedCheckIn.image
