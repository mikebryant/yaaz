import "util/main.ash";

boolean have_crudes()
{
  if (creatable_amount($item[jar of oil]) > 0) return true;
  if (item_amount($item[jar of oil]) > 0) return true;

  int peak = get_property("twinPeakProgress").to_int();
  if(bit_flag(peak, 2)) return true; // already used the oil.

  return false;
}

boolean L09_SQ_oilpeak()
{
  if (quest_status("questL09Topping") != 2)
    return false;

  int progress = to_int(get_property("oilPeakProgress"));
  if (progress == 0)
    return false;

  log("Off to light the " + wrap($location[oil peak]) + ".");

  boolean b;
  repeat
  {
    b = dg_adventure($location[oil peak], "items, ml");
    progress = to_int(get_property("oilPeakProgress"));
  } until ((progress == 0 && have_crudes()) || !b);

  if (progress == 0 && !contains_text($location[oil peak].noncombat_queue, "Unimpressed with Pressure"))
  {
    dg_adventure($location[oil peak]);
  }

  return true;
}

void main()
{
  L09_SQ_oilpeak();
}
