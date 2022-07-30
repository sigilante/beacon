|%
+$  url     cord
+$  urls    (map url fate)
+$  who     @p
::::  REQUEST STATUSES
::  Clotho spins the thread of life; here she tracks unapproved requests.
::  Lachesis measures the span of life; here she tracks approvals.
::  Atropos cuts the thread of life; here she reaps rejections.
+$  fate    ?(%clotho %lachesis %atropos)
::::  SERVER ACTIONS (%sentinel)
::  %auto   set own URL identity
::  %send   request remote %sentinel-watcher to approve
::  %okay   approve a URL (status to %.y)
::  %yeet   disapprove a URL (status to %.n)
::  %sour   time out a URL (status to %.n)
+$  appeal
  $%  [%auto =url]
      [%send =who]
      [%okay =who]
      [%yeet =who]
      [%sour =who]
  ==
--
