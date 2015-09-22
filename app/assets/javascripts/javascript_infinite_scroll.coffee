# assets/javascripts/infinite-scroll.js.coffee
$ ->
  content = $('#content')    # where to load new content
  viewMore = $('nav .pager') # tag containing the "View More" link
  spinner = $('#spinner')

  isLoadingNextPage = false  # keep from loading two pages at once
  lastLoadAt = null          # when you loaded the last page
  minTimeBetweenPages = 5000 # milliseconds to wait between loading pages
  loadNextPageAt = 1000      # pixels above the bottom

  spinner.hide() # hide the loading indicator/spinner

  waitedLongEnoughBetweenPages = ->
    return lastLoadAt == null || new Date() - lastLoadAt > minTimeBetweenPages

  approachingBottomOfPage = ->
    return document.documentElement.clientHeight +
        $(document).scrollTop() < document.body.offsetHeight - loadNextPageAt

  nextPage = ->
    url = viewMore.find('a').attr('href')
    return if isLoadingNextPage || !url

    #    url_filter_params = $('form#form_filters').serialize()
    #    url = url + url_filter_params
    #    console.log(url)

    spinner.show() # display the loading indicator/spinner

    viewMore.addClass('loading')
    isLoadingNextPage = true
    lastLoadAt = new Date()

    $.ajax({
      url: url,
      method: 'GET',
      dataType: 'script',
      success: ->
        viewMore.removeClass('loading');
        isLoadingNextPage = false;
        lastLoadAt = new Date();
        spinner.hide() #hide the loading indicator/spinner
    })

  # watch the scrollbar
  $(window).scroll ->
    if approachingBottomOfPage() && waitedLongEnoughBetweenPages()
      nextPage()

  # failsafe in case the user gets to the bottom
  # without infinite scrolling taking affect.
  viewMore.find('a').click (e) ->
    nextPage()
    e.preventDefaults()
