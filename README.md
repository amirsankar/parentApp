# parentApp

Goal: Allow a parent to set up a geo-fencing monitor for their child. The parent sets a point and a radius within which the child is supposed to be. If the child moves out of that, the parent is notified.
App user interface: There are two apps, parent and child. The parent app does two things
1. Create parent userid
2. Set preferences for the parent
3. Get status
The child app does only one thing – once activated with the parent’s userid, it constantly sends its location to a server.
