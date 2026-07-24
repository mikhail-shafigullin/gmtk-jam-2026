extends Node

signal change_level(location: LocationController.Location)
signal level_changed(location: LocationController.Location)

# drawing
signal drawing_started();
signal drawing_time_limit_finished();
signal drawing_finished();
signal drawing_sent(painting: PaintingData);
signal drawing_received_from_other_player();

# auction
signal auction_someone_bid(cost: int)
signal auction_painting_sold(cost: int)
signal auction_user_bid(cost: int)
signal auction_painting_bought(cost: int)

# museum
signal museum_painting_put()
signal museum_painting_add_money()
signal museum_painting_sold()

# playerData
signal updateMoney(deltaMoney: int);
signal updateFame(deltaFame: int);