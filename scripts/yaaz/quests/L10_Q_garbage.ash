import "util/main.ash";

void plant_beanstalk()
{
  while(item_amount($item[enchanted bean]) == 0 && quest_status("questL10Garbage") < 2)
  {
    yz_adventure($location[the beanbat chamber], "items");
  }

  if (quest_status("questL10Garbage") < 2)
  {
    log("Planting an " + wrap($item[enchanted bean]) + ".");
    use(1, $item[enchanted bean]);
  }
}

void get_sock()
{
  if (item_amount($item[s.o.c.k.]) > 0)
    return;
  add_attract($monster[quiet healer]);
  while (item_amount($item[S.O.C.K.]) == 0 && can_adventure())
  {
    string max = "items, -combat";
    if ($location[the penultimate fantasy airship].turns_spent < 5)
    {
      max = "items";
    }
    boolean b = yz_adventure($location[the penultimate fantasy airship], max);
  }
  remove_attract($monster[quiet healer]);

}

void open_ground_floor()
{
  if (quest_status("questL10Garbage") != 7)
    return;


  if (have($item[amulet of extreme plot significance]))
  {
    maximize("", $item[amulet of extreme plot significance]);
  } else {
    maximize("");
  }

  // this could be smarter (travel without the umbrella equipped, then skip out
  // through the mousehole, equip umbrella, and come right back)
  set_property("choiceAdventure669", 1); // either open ground floor (with umbrella) or fitness choice (without)

  if (have_equipped($item[amulet of extreme plot significance]))
    set_property("choiceAdventure670", 4); // open ground floor
  else
    set_property("choiceAdventure670", 1); // massive dumbbell (or skip)

  if (item_amount($item[massive dumbbell]) > 0)
    set_property("choiceAdventure671", 1); // open ground floor (with dumbbell)
  else
    set_property("choiceAdventure671", 4); // Fitness choice (670)


  if (have($item[titanium assault umbrella])
      && !have_equipped($item[titanium assault umbrella])
      && my_path() != "Way of the Surprising Fist")
  {
    equip($item[titanium assault umbrella]);
  }

  while (can_adventure() && quest_status("questL10Garbage") == 7)
  {
    boolean b = yz_adventure($location[The Castle in the Clouds in the Sky (Basement)]);
    if (!b)
      return;
  }
}

void open_top_floor()
{
  if (quest_status("questL10Garbage") != 8)
    return;

  set_property("choiceAdventure672", 3); // skip: "There's No Ability Like Possibility"

  // note: leaving this at 1 after getting book doesn't take an adventure:
  set_property("choiceAdventure673", 1); // Library book in "Putting Off Is Off-Putting"

  set_property("choiceAdventure674", 3); // skip: "Huzzah!"

  while (quest_status("questL10Garbage") == 8)
  {
    location ground = $location[The Castle in the Clouds in the Sky (Ground Floor)];
    if (ground.turns_spent > 11)
    {
      error("We've spent enough turns in the Castle's ground floor, but the top floor isn't open.");
      abort("Open the top floor manually and then try this script again.");
    }

    if (ground.turns_spent < 6
        && to_location(get_property("lastAdventure")) == ground
        && have($item[turkey blaster]))
    {
      log("Chewing a " + wrap($item[turkey blaster]) + " to speed up the ground floor.");
      try_chew($item[turkey blaster]);
    }

    if (item_amount($item[electric boning knife]) == 0)
    {
      set_property("choiceAdventure1026", 2); // get the boning knife
    } else {
      set_property("choiceAdventure1026", 3); // skip
    }

    boolean b = yz_adventure(ground, "items");
    if (!b)
      return;
  }

}

void spin_garbage_wheel()
{
  while ((quest_status("questL10Garbage") == 9
          || !have($item[steam-powered model rocketship]))
         && can_adventure())
  {
    if (!have($item[mohawk wig]))
      maximize("");
    else
      maximize("",$item[mohawk wig]);

    // steampunk choice
    if (!have($item[steam-powered model rocketship]))
      set_property("choiceAdventure677", 2); // model rocketship
    else if (have($item[model airship]))
      set_property("choiceAdventure677", 1); // complete quest
    else if (have($item[drum 'n' bass 'n' drum 'n' bass record]))
      set_property("choiceAdventure677", 4); // goth choice
    else
      set_property("choiceAdventure677", 1); // pick a fight

    // goth choice
    if (have($item[drum 'n' bass 'n' drum 'n' bass record]))
      set_property("choiceAdventure675", 2); // complete quest
    else
      set_property("choiceAdventure675", 4); // steampunk choice

    // punk choice
    if (have_equipped($item[mohawk wig]))
      set_property("choiceAdventure678", 1); // complete quest
    else
      set_property("choiceAdventure678", 4); // raver choice

    // raver choice
    if (!have($item[drum 'n' bass 'n' drum 'n' bass record]))
      set_property("choiceAdventure676", 3); // get record
    else if (have_equipped($item[mohawk wig]))
      set_property("choiceAdventure676", 4); // punk choice
    else
      set_property("choiceAdventure676", 1); // pick a fight

    set_property("choiceAdventure679", 1); // complete quest

    boolean b = yz_adventure($location[The Castle in the Clouds in the Sky (Top Floor)]);
    if (!b)
      return;
  }
}

boolean garbage_loop()
{
  switch(quest_status("questL10Garbage"))
  {
    default:
      warning("I don't know this quest status for the Garbage quest: '" + get_property("questL10Garbage") + "'.");
      return false;
    case UNSTARTED:
      log("Going to the council to get the Garbage quest.");
      council();
      return true;
    case STARTED:
      plant_beanstalk();
      return true;
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
      log("Off to get a " + wrap($item[s.o.c.k.]) + ".");
      get_sock();
      return false;
    case 7:
      open_ground_floor();
      if (quest_status("questL10Garbage") != 7)
        log("Ground floor of the Castle has been opened.");
      return false;
    case 8:
      open_top_floor();
      if (quest_status("questL10Garbage") != 8)
        log("Top floor of the Castle has been opened.");
      return false;
    case 9:
      spin_garbage_wheel();
      if (quest_status("questL10Garbage") != 9)
        log("Garbage wheel has been spun.");
      return false;
    case 10:
      log("Turning in the Garbage quest to the council.");
      council();
      return true;
    case FINISHED:
      if (!have($item[steam-powered model rocketship]))
      {
        spin_garbage_wheel();
        return true;
      }
      return false;
  }
}

boolean L10_Q_garbage()
{
  if (my_level() < 10)
    return false;
  if (quest_status("questL10Garbage") == FINISHED
      && have($item[steam-powered model rocketship]))
    return false;

  int status = quest_status("questL10Garbage");
  while (garbage_loop())
  {
    // work in garbage_loop();
  }
  return status != quest_status("questL10Garbage");
}

void main()
{
  L10_Q_garbage();
}