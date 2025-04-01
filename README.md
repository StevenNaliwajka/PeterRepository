# PeterRepository
ServesPeterGriffinGifs



![Random](https://your-api.com/random-gif?cachebuster=12345)



Use Https://api.yourdomain.com/peter

when hosting make sure to re-route w/ 302

302: Temporary re-direct.
and provides a new website link
302 is used to get around github cacheing


Reverse proxy (outside scope)
routes to this machine running peter repository.

Peter repository runs fastAPI server for routing traffic w/ 302 to correct domain
Nginx instance hosts the domains