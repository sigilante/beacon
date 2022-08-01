::  Beacon index
::
/-  *beacon
/+  rudder
::
!:
^-  (page:rudder [url ships] appeal)
|_  [=bowl:gall * [auto=url bids=ships]]
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ~&  >>>  body
  ^-  $@(brief:rudder appeal)
  =/  args=(map @t @t)
    ?~(body ~ (frisk:rudder q.u.body))
  ::  get appeal (%auth or %burn)
  ?~  what=(~(get by args) 'what')
    ~
  ::  get URL
  ?~  who=(~(get by args) 'who')
    ~
  ~&  >>  u.what
  ?+  u.what  ~
      ?(%auto %send)
    ?:  ?=(%send u.what)
      [%send `ship`(need (slaw %p u.who))]
    [%auto `url`u.who]
  ==
::
++  final  (alert:rudder (cat 3 '/' dap.bowl) build)
::
++  build
  |=  $:  arg=(list [k=@t v=@t])
          msg=(unit [o=? =@t])
      ==
  ^-  reply:rudder
  |^  [%page page]
  ::
  ++  icon-color  "blue"
  ::
  ++  style
    '''
    * { margin: 0.2em; padding: 0.2em; font-family: monospace; }

    p { max-width: 50em; }

    form { margin: 0; padding: 0; }

    .red { font-weight: bold; color: #dd2222; }
    .green { font-weight: bold; color: #229922; }

    a {
      display: inline-block;
      color: inherit;
      padding: 0;
      margin-top: 0;
    }

    table#beacon tr td:nth-child(2) {
      padding: 0 0.5em;
    }

    .label {
      display: inline-block;
      background-color: #ccc;
      border-radius: 3px;
      margin-right: 0.5em;
      padding: 0.1em;
    }
    .label input[type="text"] {
      max-width: 100px;
    }
    .label span {
      margin: 0 0 0 0.2em;
    }

    button {
      padding: 0.2em 0.5em;
    }
    '''
  ::
  ++  page
    ^-  manx
    ;html
      ;head
        ;title:"%beacon"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;style:"{(trip style)}"
      ==
      ;body
        ;h2:"Beacon"

        Requests authentication for URLs to ships using the Sentinel agent for
        website authentication.

        Some websites that use Beacon and Sentinel:

        ;a/"https://vienna.earth"
          ; Vienna HyperText smart canvas
        ==
        ;br;

        This app was built using ~palfun-foslup’s Rudder library.

        ;+  ?~  msg  ;p:""
            ?:  o.u.msg  ::TODO  lightly refactor
              ;p.green:"{(trip t.u.msg)}"
            ;p.red:"{(trip t.u.msg)}"

        ;h3:"Set self"

        ;p.blue:"{<(trip auto)>}"

        ;form(method "post")
          ;button(type "submit", name "what", value "auto"):"🪞"
          ;input(type "text", name "who", placeholder "https://urbit.org");
        ==

        ;h3:"Ship bids"

        ;table#beacon
          ;form(method "post")
            ;tr(style "font-weight: bold")
              ;td:""
              ;td:"Ship"
            ==
            ;tr
              ;td
                ;button(type "submit", name "what", value "send"):"✉"
              ==
              ;td
                ;input(type "text", name "who", placeholder "~sampel-palnet");
              ==
            ==
          ==
          ::  Clotho spins the thread of life; here she tallies bids.
          ;*  clotho
          ::  Lachesis measures the span of life; here she tracks approvals.
          ;*  lachesis
          ::  Atropos cuts the thread of life; here she reaps rejections.
          ;*  atropos
        ==
      ==
    ==
  ::
  ++  spin-the-thread
    |=  =ship
    ^-  manx
    ;form(method "post")
      ;input(type "hidden", name "who", value (trip ship));
      ;button(type "submit", name "what", value "auth"):"√"
    ==
  ::  Reject the request.
  ++  cut-with-shears
    |=  =ship
    ^-  manx
    ;form(method "post")
      ;input(type "hidden", name "who", value (trip ship));
      ;button(type "submit", name "what", value "burn"):"×"
    ==
  ::
  ++  peers
    |=  [fate=?(%clotho %lachesis %atropos) mer=(list ship)]
    ^-  (list manx)
    %+  turn  mer
    |=  =ship
    ^-  manx
    =/  ack=(unit ^fate)  (~(get by bids) ship)
    ;tr
      ::  Symbol
      ;td
        ;+  (relation fate ack)
      ==
      ::  Button
      ;+  ?:  ?=(%lachesis fate)
            ;td
              ;+  (cut-with-shears ship)
            ==
          ;td
            ;+  ;p:""
          ==
      ::  Ship
      ;td:"{<(scow %p ship)>}"
    ==
  ::
  ::  Lachesis measures the span of life; here she tracks approved ships.
  ++  lachesis
    ^-  (list manx)
    %+  peers  %lachesis
    %+  skim  ~(tap in ~(key by bids))
    |=  =ship
    ?=(%lachesis (need (~(get by bids) ship)))
  ::
  ::  Clotho spins the thread of life; here she tracks requesting ships.
  ++  clotho
    ^-  (list manx)
    %+  peers  %clotho
    %+  skim  ~(tap in ~(key by bids))
    |=  =ship
    ?=(%clotho (need (~(get by bids) ship)))
  ::
  ::  Atropos cuts the thread of life; here she tracks rejected URLs.
  ++  atropos
    ^-  (list manx)
    %+  peers  %atropos
    %+  skim  ~(tap in ~(key by bids))
    |=  =ship
    ?=(%atropos (need (~(get by bids) ship)))
  ::
  ++  relation
    |=  [fate=?(%clotho %lachesis %atropos) ack=(unit fate)]
    =.  ack
      ?.  ?=(%lachesis fate)  ~
      `(fall ack %clotho)
    ^-  manx  ~+
    ?-  fate
        %atropos
      ;svg
        =width    "25"
        =height   "25"
        =viewbox  "0 0 100 100"
        =fill     "none"
        =xmlns    "http://www.w3.org/2000/svg"
        ;path
          =d  """
              M95 50
              C95 55.9095 93.836 61.7611 91.5746 67.2208
              C89.3131  72.6804 85.9984 77.6412 81.8198 81.8198
              C77.6412 85.9984 72.6804 89.3131 67.2208 91.5746
              C61.7611 93.836 55.9095 95 50 95
              """
          =stroke  icon-color
          =stroke-width  "10";
        ;path
          =d  """
              M67.2383 68.7383
              L59.7669 40.8545
              L39.3545 61.2669
              L67.2383 68.7383
              Z
              M31.5294 29.4939
              L29.7617 27.7262
              L26.2261 31.2617
              L27.9939 33.0295
              L31.5294 29.4939
              Z
              M53.0962 51.0607
              L31.5294 29.4939
              L27.9939 33.0295
              L49.5607 54.5962
              L53.0962 51.0607
              Z
              """
          =fill  icon-color;
      ==
    ::
        %lachesis
      ;svg
        =width    "25"
        =height   "25"
        =viewbox  "13 0 113 100"
        =fill     "none"
        =xmlns    "http://www.w3.org/2000/svg"
        ;path
          =d  """
              M108 50
              C108 61.9348 103.259 73.3807 94.8198 81.8198
              C86.3807 90.2589 74.9347 95 63 95
              C51.0653 95 39.6193 90.2589 31.1802 81.8198
              C22.7411 73.3807 18 61.9347 18 50
              """
          =stroke  icon-color
          =stroke-width  "10";
        ;path
          =d  """
              M87.5114 31.5994
              C87.5114 28.4354 84.9226 25.8466 81.7585 25.8466
              C78.5945 25.8466 76.0057 28.4354 76.0057 31.5994
              C76.0057 34.7635 78.5945 37.3523 81.7585 37.3523
              C84.9226 37.3523 87.5114 34.7635 87.5114 31.5994
              Z
              M51.0767 31.5994
              C51.0767 28.4354 48.4879 25.8466 45.3239 25.8466
              C42.1598 25.8466 39.571 28.4354 39.571 31.5994
              C39.571 34.7635 42.1598 37.3523 45.3239 37.3523
              C48.4879 37.3523 51.0767 34.7635 51.0767 31.5994
              Z
              """
          =fill  icon-color;
      ==
    ::
        %clotho
      ;svg
        =width    "25"
        =height   "25"
        =viewbox  "0 0 100 100"
        =fill     "none"
        =xmlns    "http://www.w3.org/2000/svg"
        ;path
          =d  """
              M50 95
              C44.0905 95 38.2389 93.836 32.7792 91.5746
              C27.3196 89.3131 22.3588 85.9984 18.1802 81.8198
              C14.0016 77.6412 10.6869 72.6804 8.42542 67.2208
              C6.16396 61.7611 5 55.9095 5 50
              """
          =stroke  icon-color
          =stroke-width  "10";
        ;+  ?:  =([~ &] ack)
          ::  plain arrow
          ;path
            =d  """
                M30.5546 65.9099
                L28.7868 67.6777
                L32.3223 71.2132
                L34.0901 69.4454
                L30.5546 65.9099
                Z
                M67.6777 32.3223
                L39.7938 39.7938
                L60.2062 60.2062
                L67.6777 32.3223
                Z
                M34.0901 69.4454
                L53.5355 50
                L50 46.4645
                L30.5546 65.9099
                L34.0901 69.4454
                Z
                """
            =fill  icon-color;
        ::  dotted arrow
        ;path
          =d  """
              M31.4384 66.7938
              L30.5546 67.6777
              L32.3223 69.4454
              L33.2062 68.5616
              L31.4384 66.7938
              Z
              M67.6777 32.3223
              L53.7357 36.0581
              L63.9419 46.2643
              L67.6777 32.3223
              Z
              M33.2062 68.5616
              L34.974 66.7938
              L33.2062 65.026
              L31.4384 66.7938
              L33.2062 68.5616
              Z
              M38.5095 63.2583
              L42.045 59.7227
              L40.2773 57.955
              L36.7417 61.4905
              L38.5095 63.2583
              Z
              M45.5806 56.1872
              L49.1161 52.6517
              L47.3483 50.8839
              L43.8128 54.4194
              L45.5806 56.1872
              Z
              M52.6516 49.1161
              L56.1872 45.5806
              L54.4194 43.8128
              L50.8839 47.3484
              L52.6516 49.1161
              Z
              M59.7227 42.0451
              L63.2583 38.5095
              L61.4905 36.7418
              L57.9549 40.2773
              L59.7227 42.0451
              Z
              M30.5546 65.9099
              L28.7868 67.6777
              L32.3223 71.2132
              L34.0901 69.4454
              L30.5546 65.9099
              Z
              M67.6777 32.3223
              L39.7938 39.7938
              L60.2062 60.2062
              L67.6777 32.3223
              Z
              M34.0901 69.4454
              L35.8579 67.6777
              L32.3223 64.1421
              L30.5546 65.9099
              L34.0901 69.4454
              Z
              M39.3934 64.1421
              L42.9289 60.6066
              L39.3934 57.0711
              L35.8579 60.6066
              L39.3934 64.1421
              Z
              M46.4645 57.0711
              L50 53.5355
              L46.4645 50
              L42.9289 53.5355
              L46.4645 57.0711
              Z
              M53.5355 50
              L57.0711 46.4645
              L53.5355 42.9289
              L50 46.4645
              L53.5355 50
              Z
              M60.6066 42.9289
              L64.1421 39.3934
              L60.6066 35.8579
              L57.0711 39.3934
              L60.6066 42.9289
              Z
              """
          =fill  icon-color;
      ==
    ==
  --
--
