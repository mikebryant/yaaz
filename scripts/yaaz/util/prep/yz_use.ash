import "util/base/yz_inventory.ash";
import "util/base/yz_locations.ash";
import "util/base/yz_settings.ash";


void use_things()
{
  int[item] use_items;
  file_to_map(DATA_DIR + "yz_use.txt", use_items);

  foreach it, i in use_items
  {
    use_all(it, i);
  }

  if (item_amount($item[orcish meat locker]) > 0
      && item_amount($item[rusty metal key]) > 0)
  {
    log("Opening an " + wrap($item[orcish meat locker]) + ".");
    use(1, $item[orcish meat locker]);
  }

  if (!have_familiar($familiar[misshapen animal skeleton]))
  {
    use_all($item[pile of dusty animal bones]);
  }

  if (closet_amount($item[stuffed key]) > 0 && closet_amount($item[stuffed treasure chest]) > 0)
  {
    log("Taking out a " + wrap($item[stuffed key]) + " and a " + wrap($item[stuffed treasure chest]) + " to open.");
    take_closet(1, $item[stuffed key]);
    take_closet(1, $item[stuffed treasure chest]);

    log("Opening the " + wrap($item[stuffed treasure chest]) + ".");
    use(1, $item[stuffed treasure chest]);
  }

  if (!location_open($location[the overgrown lot]) && item_amount($item[Map to a Hidden Booze Cache]) > 0)
  {
    log("Using a " + wrap($item[Map to a Hidden Booze Cache]) + " to open " + wrap($location[the overgrown lot]) + ".");
    use(1, $item[Map to a Hidden Booze Cache]);
  }

  if (item_amount($item[steel margarita]) > 0)
  {
    log("Drinking a " + wrap($item[steel margarita]) + ". Liver! Liver! Liver!");
    drink(1, $item[steel margarita]);
  }
  if (item_amount($item[steel-scented air freshener]) > 0)
  {
    log("Chewing a " + wrap($item[steel-scented air freshener]) + ". Spleen! Spleen! Spleen!");
    chew(1, $item[steel-scented air freshener]);
  }
  if (item_amount($item[steel lasagna]) > 0)
  {
    log("Eating a " + wrap($item[steel lasagna]) + ". Stomach! Stomach! Stomach!");
    eat(1, $item[steel lasagna]);
  }

  if (quest_status("questL09Topping") < 1)
  {
    use_all($item[smut orc keepsake box]);
  }

  if (item_amount($item[abridged dictionary]) > 0)
  {
    cli_execute("untinker abridged dictionary");
  }

  if (get_property("questL10Garbage") == "started" && item_amount($item[enchanted bean]) > 0)
  {
    if (my_path() == "Bees Hate You")
    {
      visit_url("place.php?whichplace=plains&action=garbage_grounds");
    } else {
      use(1, $item[enchanted bean]);
    }

  }

  if (get_property("hiddenTavernUnlock").to_int() < my_ascensions() && item_amount($item[book of matches]) > 0)
  {
    use(1, $item[book of matches]);
  }

  if (item_amount($item[boring binder clip]) > 0 && mcclusky_items() == 5)
  {
    log("Making the " + wrap($item[McClusky file (complete)]) + ".");
    use(1, $item[boring binder clip]);
  }

  if (setting("used_tonic_djinn") != "true" && item_amount($item[tonic djinn]) > 0)
  {
    int choice = 1;
    if (my_meat() < 5000)
    {
      choice = 1;
    } else {
      switch(my_primestat())
      {
        case $stat[Muscle]:
          choice = 2;
          break;
        case $stat[Mysticality]:
          choice = 3;
          break;
        case $stat[Moxie]:
          choice = 4;
          break;
      }
    }
    string msg = "Meat";
    if (choice != 1)
      msg = to_string(my_primestat());
    set_property("choiceAdventure778", choice);
    warning("Using a " + wrap($item[tonic djinn]) + " to get some " + wrap(msg, COLOR_ITEM) + ".");
    use(1, $item[tonic djinn]);
    // mafia doesn't seem to know the tonic djinn goes away after use.
    cli_execute("refresh inv");
    save_daily_setting("used_tonic_djinn", "true");
  }

  if (numeric_modifier("stench resistance") > 0
      && have($item[the Slug Lord's map]))
  {
    log("Following " + wrap($item[the Slug Lord's map]) + " to get the " + wrap($item[pants of the Slug Lord]) + ".");
    use(1, $item[the Slug Lord's map]);
  }

  // getting the asparagus knife takes adventures, so not going to do that
  // automatically. If, however, we come across is naturally, then may as well...
  if (have($item[dr. hobo's map])
      && have($item[asparagus knife]))
  {
    if (!have($item[cool whip]))
    {
      buy(1, $item[cool whip]);
    }
    log("Going to get " + wrap($item[dr. hobo's scalpel]) + ".");
    equip($item[cool whip]);
    use(1, $item[dr. hobo's map]);
  }

}

void main()
{
  use_things();
}
