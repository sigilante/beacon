/-  beacon
|_  upd=update:beacon
++  grab
  |%
  ++  noun  update:beacon
  --
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    |^  ^-  ^json
    ?-  -.upd
      %url      (frond 'url' s+url.upd)
      %pending  (frond 'pending' s+(scot %p ship.upd))
      %approve  (frond 'approve' s+(scot %p ship.upd))
      %reject   (frond 'reject' s+(scot %p ship.upd))
      %init     %+  frond  'init'
                %-  pairs
                :~  ['url' s+url.upd]
                    ['bids' (en-bids bids.upd)]
                ==
    ==
  ::
    ++  en-bids
      |=  bids=ships:beacon
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by bids)
      |=  [ship=@p =fate:beacon]
      ^-  ^json
      ?-  fate
        %clotho    (frond 'pending' s+(scot %p ship))
        %lachesis  (frond 'approve' s+(scot %p ship))
        %atropos   (frond 'reject' s+(scot %p ship))
      ==
    --
  --
++  grad  %noun
--

