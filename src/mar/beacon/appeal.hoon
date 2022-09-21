/-  beacon
|_  =appeal:beacon
++  grab
  |%
  ++  noun  appeal:beacon
  --
++  grow
  |%
  ++  noun  appeal
  ++  json
    =,  enjs:format
    ^-  ^json
    ?+    -.appeal  !!
        %auth
      %-  pairs
      :~  ['ship' s+(scot %p +.appeal)]
          ['status' b+%.y]
      ==
    ::
        %burn
      %-  pairs
      :~  ['ship' s+(scot %p +.appeal)]
          ['status' b+%.n]
      ==
    ::
        %send
      %-  pairs
      :~  ['ship' s+(scot %p +.appeal)]
      ==
    ==
  --
++  grad  %noun
--

