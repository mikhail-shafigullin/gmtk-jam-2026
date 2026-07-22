extends Node

signal change_level(location: LocationController.Location)

# drawing
signal drawing_started();
signal drawing_time_limit_finished();
signal drawing_finished();
signal drawing_sent();
signal drawing_received();

# auction
signal auction_someone_bid()
signal auction_painting_sold()
signal auction_user_bid()
signal auction_painting_bought()

# museum
signal museum_painting_put()
signal museum_painting_add_money()
signal museum_painting_sold()
