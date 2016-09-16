# A dummy controller to provide an endpoint for our site routes and
# to return the javascript and our layout.
#
# Since we're developing a single page app, in which all of our views are
# handled on the frontend and the backend is primarily an API layer, we just
# want to have the server return the same thing for every route: the javascript
# and the layout.  So we're going to have all site routes point here and this
# controller will define methods for each of the possible routes.  That way
# any url a user hits will give them the front page app and the routing can
# happen on the client side.
#
# We only need to create the routes that traditionally return views since those
# are the only one that will be routed to the SiteController.
class SiteController < ApplicationController

  def index
  end

  def show
  end

  def new
  end

  def edit
  end  
end
