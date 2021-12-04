# OpenHAB3 Widget for Übersicht
This is a small widget for [Übersicht](http://tracesof.net/uebersicht/) where you can have an overview of your openHAB 3 items on your desktop.

## Preparation
- Complete an [openHAB 3](https://www.openhab.org/) installation
- Download and install [Übersicht](http://tracesof.net/uebersicht/)

## Installation
- Copy `openHAB3.widget` to your widgets folder
- Follow the steps in `openHAB3.coffee`

## Advanced

### Refresh Frequency
By default, the widget will update the states every 3 minutes. To adjust this, change the value of `refreshFrequency` in `openHAB3.coffee` (in milliseconds).

### Item selection
Add all items that should be displayed in the `items` array in `openHAB3.coffee`.
Every item needs 2 values: 
- **name**: the item name in openHAB3
- **type**: one of the supported types. I added some types for a better user experience.  
Special type Room: All followed items till the next room are assigned to this room and will be displayed in one column (more information in the section Columns)  

**Supported item types**: 
  - Switch
  - Contact
  - Light (openHAB3 type: Switch) 
  - Led-Strip (openHAB3 type: Switch)
  - Dimmer
  - Rollershutter
  - Color
  - DateTime
  - Location
  - Player
  - String
  - Number (openHAB3 type: String)
  - Temperature (openHAB3 type: String)
  - Humidity (openHAB3 type: String)
  - Heating (openHAB3 type: Switch)

### Options for some Item types
- Dimmer: the number of decimal places can be defined by changing the value of `dimmer_decimalplaces` in `openHAB3.coffee`
- Number: the number of decimal places can be defined by changing the value of `number_decimalplaces` in `openHAB3.coffee`
- Temperature: the unit can be defined by changing the value of `--unit_temperature` that can be found in the `style block` in `openHAB3.coffee`

### Appearance

#### Columns
The number of columns can be defined by changing the value of `columns` in `openHAB3.coffee`. A column will only contain one room apart from the last column which contains the rest ot the rooms.
The width of each column can be defined by changing the value of `width_of_column` in `openHAB3.coffee`.

#### Icons
At the beginning of every column which contains an item, a icon can be displayed that shows the type. Some types support an icon that adapts to the state of the item (e.g. Switch). Icons are enabled from the start, but can be disabled by changing the value of `icons` to false in `openHAB3.coffee`.  
There are 2 icon types available. Both change dynamic to the item state:
- openhab: uses the classic openhab iconset.
- custom: uses a custom icon set.

#### Position
The position of the widget can be set in the `style block` in `openHAB3.coffee`. 

#### Advanced Appearance
Several options like the text, background or icon color (if custom icons are used) as well as a border can be set in the `style block` in `openHAB3.coffee` by changing the css variables. A description can be found next to the variables.

## Credits
This is not an official openHAB3 widget.  
Please use the issue templates in this repository for bugs. The main openHAB project is not responsible for any malfunction that is caused by the use of the widget!
