|%
+$  url     cord
+$  urls    (map url fate)
+$  ship    @p
+$  ships   (map ship fate)
::::  REQUEST STATUSES
::  Clotho spins the thread of life; here she tracks unapproved requests.
::  Lachesis measures the span of life; here she tallies approvals.
::  Atropos cuts the thread of life; here she reaps rejections.
+$  fate    ?(%clotho %lachesis %atropos)
::::  SERVER ACTIONS (%beacon)
::  %auto   set own URL identity
::  %send   request remote %sentinel to approve
::  %auth   approve a URL (status to %.y)
::  %burn   disapprove a URL (status to %.n)
+$  appeal
  $%  [%auto =url]
      [%send =ship]
      [%auth =ship]
      [%burn =ship]
  ==
--
