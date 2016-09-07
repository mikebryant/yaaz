import "util/base/print.ash";
import "util/base/inventory.ash";
import "util/base/effects.ash";
import "util/base/familiars.ash";
import "util/iotm/terminal.ash";
import "util/iotm/bookshelf.ash";

void do_maximize(string target, string outfit, item it);
void maximize(string target, string outfit, item it, familiar fam);
void maximize(string target, item it);
void maximize(string target, string outfit, familiar fam);
void maximize(string target, string outfit);
void maximize(string target);
void maximize();
void max_effects(string target);

void do_maximize(string target, string outfit, item it)
{
  string max = target;
  if (outfit != "")
  {
    if (max != "")
    {
      max = max + ", ";
    }
    max = max + "outfit " + outfit;
  }

  if (it != $item[none])
  {
    if (max != "")
    {
      max = max + ", ";
    }
    max = max + "+equip " + it;
  }

  maximize(max, false);
}

string default_maximize_string()
{
  string def = "mainstat, 0.4 hp  +effective, mp regen";
  if (my_buffedstat($stat[muscle]) > my_buffedstat($stat[moxie]))
  {
    def += ", +shield";
  }
  return def;
}

void maximize(string target, string outfit, item it, familiar fam)
{
  string[int] split_map;
  split_map = split_string(target, ", ");

  if (fam != $familiar[none])
    choose_familiar(fam);
  else
    choose_familiar(split_map[0]);

  if (target == 'rollover')
    target = 'adv, pvp fights';

  if (target == 'noncombat')
    target = '-combat';

  if (target == '')
    target = default_maximize_string();

  do_maximize(target, outfit, it);

  foreach t in split_map
  {
    max_effects(split_map[t]);
  }
}

void maximize(string target, item it)
{
  maximize(target, "", it, $familiar[none]);
}

void maximize(string target, string outfit, familiar fam)
{
  maximize(target, outfit, $item[none], fam);
}

void maximize(string target, familiar fam)
{
  maximize(target, "", fam);
}

void maximize(string target, string outfit)
{
  maximize(target, outfit, $familiar[none]);
}

void maximize(string target)
{
  maximize(target, "");
}

void maximize()
{
  maximize("");
}

void max_effects(string target)
{
  switch(target)
  {
    case "meat":
      effect_maintain($effect[polka of plenty]);
      terminal_enhance($effect[meat.enh]);
      if (!have_colored_tongue())
        effect_maintain($effect[red tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[black tongue]);
      break;
    case "items":
      effect_maintain($effect[eye of the seal]);
      effect_maintain($effect[ermine eyes]);
      effect_maintain($effect[Fat Leon's Phat Loot Lyric]);
      effect_maintain($effect[ocelot eyes]);
      effect_maintain($effect[peeled eyeballs]);
      effect_maintain($effect[singer's faithful ocelot]);
      effect_maintain($effect[withered heart]);
      terminal_enhance($effect[items.enh]);
      if (!have_colored_tongue())
        effect_maintain($effect[blue tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[black tongue]);
      break;
    case "init":
      effect_maintain($effect[all fired up]);
      effect_maintain($effect[adorable lookout]);
      effect_maintain($effect[Hiding in Plain Sight]);
      effect_maintain($effect[lustful heart]);
      effect_maintain($effect[Sepia Tan]);
      effect_maintain($effect[Song of Slowness]);
      effect_maintain($effect[Springy Fusilli]);
      effect_maintain($effect[Ticking Clock]);
      effect_maintain($effect[Walberg\'s Dim Bulb]);
      effect_maintain($effect[sugar rush]);
      terminal_enhance($effect[init.enh]);
      break;
    case "-combat":
    case "noncombat":
      effect_maintain($effect[Fresh Scent]);
      effect_maintain($effect[Smooth Movements]);
      effect_maintain($effect[The Sonata of Sneakiness]);
      uneffect($effect[Carlweather's Cantata of Confrontation]);
      break;
    case "combat":
      effect_maintain($effect[musk of the moose]);
      effect_maintain($effect[Carlweather's Cantata of Confrontation]);
      effect_maintain($effect[hippy stench]);
      uneffect($effect[The Sonata of Sneakiness]);
      break;
    case "ml":
      effect_maintain($effect[Drescher's Annoying Noise]);
      effect_maintain($effect[pride of the puffin]);
      effect_maintain($effect[tortious]);
      effect_maintain($effect[eau d'enmity]);
      effect_maintain($effect[high colognic]);
      change_mcd(10);
      break;
    case "familiar weight":
      // consider this, but it's also -10% all stats...
      // effect_maintain($effect[heavy petting]);
      effect_maintain($effect[empathy]);
      effect_maintain($effect[heart of green]);
      if (!have_colored_tongue())
        effect_maintain($effect[green tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[black tongue]);

    case "all res base":
      effect_maintain($effect[elemental saucesphere]);
      effect_maintain($effect[astral shell]);
      effect_maintain($effect[scarysauce]);
      effect_maintain($effect[oiled-up]);
      effect_maintain($effect[well-oiled]);
      effect_maintain($effect[spiro gyro]);
      effect_maintain($effect[red door syndrome]);
      if (my_familiar() == $familiar[exotic parrot])
      {
        max_effects("familiar weight");
      }
      break;
    case "all res":
      max_effects("cold res");
      max_effects("spooky res");
      break;
    case "cold res":
      max_effects("all res base");
      effect_maintain($effect[insulated trousers]);
      break;
    case "spooky res":
      max_effects("all res base");
      effect_maintain($effect[spookypants]);
      break;
    default:
      if (!have_colored_tongue())
        effect_maintain($effect[orange tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[purple tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[green tongue]);
      break;
  }

}
