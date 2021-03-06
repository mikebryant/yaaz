import "util/yz_main.ash";

boolean L06_Q_friar();
boolean do_friar_area(location loc, item it);

void L06_Q_friar_progress()
{
  if (!quest_active("questL06Friar")) return;
  string dodecagram = UNCHECKED;
  string candles = UNCHECKED;
  string butterknife = UNCHECKED;

  if (have($item[dodecagram]))
    dodecagram = CHECKED;

  if (have($item[box of birthday candles]))
    candles = CHECKED;

  if (have($item[eldritch butterknife]))
    butterknife = CHECKED;

  progress(friar_things(), 3, "Friar ceremony objects (" + dodecagram + " dodecagram, " + candles + " candles, " + butterknife + " butterknife)");
}

void L06_Q_friar_cleanup()
{

}

boolean do_friar_area(location loc, item it)
{
  if (i_a(it) > 0)
  {
    log("We have the " + wrap(it) + ".");
    return false;
  }
  maximize("-combat");
  max_effects("items");
  yz_adventure(loc);
  return true;
}


boolean do_neck()
{
  return do_friar_area($location[the dark neck of the woods], $item[dodecagram]);
}

boolean do_heart()
{
  return do_friar_area($location[the dark heart of the woods], $item[box of birthday candles]);
}

boolean do_elbow()
{
  return do_friar_area($location[the dark elbow of the woods], $item[eldritch butterknife]);
}


boolean L06_Q_friar()
{
  if (my_level() < 6)
    return false;
  if (quest_status("questL06Friar") == FINISHED)
    return false;


  log("Trying to complete the " + wrap("Deep Fat Friars", COLOR_LOCATION) + " quest.");
  wait(3);

  if (quest_status("questL06Friar") < 0)
  {
    log("Friar quest not started. Going to the council.");
    council();
  }

  if (dangerous($location[the dark neck of the woods])) return false;

  if (!have($item[dodecagram]))
  {
    log("Going to get the " + wrap($item[dodecagram]) + ".");
    do_neck();
    return true;
  }

  if (dangerous($location[the dark heart of the woods])) return false;

  if (!have($item[box of birthday candles]))
  {
    log("Going to get the " + wrap($item[box of birthday candles]) + ".");
    do_heart();
    return true;
  }

  if (dangerous($location[the dark elbow of the woods])) return false;

  if (!have($item[eldritch butterknife]))
  {
    log("Going to get the " + wrap($item[eldritch butterknife]) + ".");
    do_elbow();
    return true;
  }

  log("Performing the ritual for the Friars.");
  visit_url("friars.php?action=ritual&pwd=");
  log("Ritual complete!");
  return true;
}

void main()
{
  while (L06_Q_friar());
}
