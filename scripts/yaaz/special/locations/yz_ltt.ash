import "util/base/yz_print.ash";
import "util/base/yz_inventory.ash";

void ltt()
{
  if (get_property("telegraphOfficeAvailable") != "true")
    return;

  if (!have($item[your cowboy boots]))
  {
    log("Getting " + wrap($item[your cowboy boots]) + ".");
    visit_url("place.php?whichplace=town_right&action=townright_ltt");
  }
}

void main()
{
  ltt();
}
