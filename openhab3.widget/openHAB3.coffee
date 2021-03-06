################################################# openHAB 3 Widget for Übersicht #################################################################

# This widget allows you to have an overview of your openHAB 3 items on your desktop
#
#Options:
# 1) Connection to your openHAB3 installation
#   1. add your openHAB 3 ip here:
#      local access: ip adress + port (e.g. 192.0.0.1:8080)
#      remote access: domain (optional: + port) (e.g. mydomain.com) 
openHAB3_IP = ""
#   2. is https enabled? yes -> https, no -> http 
http_s = "http"              # defaut: http
#   3. optional: if authentication is enabled, add an api token here:
#   Help: https://www.openhab.org/docs/configuration/apitokens.html
api_token=""

# 2) add your items here:
items = [
  name: "NAME"
  type: "TYPE"
]

# Syntax:
#items = [                        //important!                       
#     name: "roomname"            //all items are assigned to this room up to the next room. Every room is displayed in one column
#     type: "Room"
#,                                //important!                                    
#     name: "itemname"
#     type: "type of the item"
#,                                //important! 
#     name: "itemname"            
#     type: "type of the item"
#,                                //important! 
#  ...
#]                                //important!

# Available types and additional configurations: 
#   - Switch        //icon adapts to state
#   - Contact       //icon adapts to state
#   - Light         //type in openHAB 2: Switch, icon adapts to state
#   - Led-Stripe    //type in openHAB 2: Switch, icon adapts to state
#   - Dimmer        //number of decimal places:
dimmer_decimalplaces = 0          # defaut: 0
#   - Rollershutter
#   - Color         //icon adapts to state
#   - DateTime
#   - Location
#   - Number        //number of decimal places:
number_decimalplaces = 1          # defaut: 1
#   - Player
#   - String
#   - Temperature
#   - Humidity
#   - Heating       //type in openHAB 2: Switch, icon adapts to state

# Appearance
#   Number of columns:
columns = 1                       # defaut: 1
#   Width of a column (px):
width_of_column = 300             # defaut: 300px
#   Icons (yes: true, no: false)
icons = true                      # defaut: true
#   Icontype (openhab: true, custom: false)
oh_icons = true
#   Position and deeper options can be found at the beginning of the style-block

command: "curl -sS -f -u '#{api_token}:' --header 'Content-Type: text/plain' --header 'Accept: application/json' '#{http_s}://#{openHAB3_IP}/rest/items'"

# 3) add the prefered refresh frequency in ms here (10000ms = 10s):
refreshFrequency: 1800000          # defaut: 3 minutes

style: """
  // 4) Position:
  left: 0px; 
  top: 0px;

  .openHAB3{
    // 5) Temperature unit
    --unit_temperature: '°C'  //'°C' for Celsius, '°F' for Fahrenheit
    
    //Appearance
    --main-text-family: 'HelveticaNeue-Light', 'Helvetica Neue Light', 'Helvetica Neue', Helvetica, 'Open Sans', sans-serif;    //text family
    --main-text-color: white;           //text color
    --main-text-size: 16px;             //text size
    --main-backgound-color: none;       //background color
    --main-icon-color: #aaaaaa;         //icon color
    --main-border-color: grey;          //border color
    --main-border-thick: none;          //border thickness. No border: none
    --main-border-radius: 0px;          //border radius
    
    color: var(--main-text-color);
    font-family: var(--main-text-family);
    font-size: var(--main-text-size);
    border: var(--main-border-thick) solid var(--main-border-color);
    border-radius: var(--main-border-radius);
    padding: 7px;
    background-color: var(--main-backgound-color);
    margin: 5px;
    #oh3-column{
      float: left;
    }
    .oh3-row{
      height: 20px;
      padding: 2px;
      
      margin-top: 2px;
      #icon{
        width: 20px;
        float: left;
      }
      #icon svg g, #icon svg{
        fill: var(--main-icon-color); //Iconcolor
      }
      #name{
        width: calc(75% - 10px);
        float: left;
        padding-left: 10px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
      #state, #Temperature, #Humidity{
        float: left;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        padding-left: 4px;
      }
      #Temperature span:after{
        content: var(--unit_temperature);
      }
      #Humidity span:after{
        content: "%";
      }
      
    }
    #room {
      text-align: center;
      font-size: calc(var(--main-text-size) + 2px)  
    }
  }
"""


render: (output) -> """<div class="openHAB3"></div>"""

afterRender: (dom) ->
  console.log("afterRender")
  $('.openHAB3').css('width', width_of_column * columns)
  column_nr = 1
  while columns >= column_nr
    $('.openHAB3').append('<div class="oh3-column-' + column_nr + '" id="oh3-column"></div>')
    $('.oh3-column-' + column_nr).css('width', width_of_column)
    column_nr = column_nr + 1
  column_nr = 0

  for key, value of items
    if value.type == "Room"
      if columns > column_nr
        column_nr = column_nr + 1
      $('.oh3-column-' + column_nr).append('<div class="oh3-row" id="room">' + value.name + '</div>')
    else
      state_type = ""
      if value.type == "Temperature" or value.type == "Humidity"
        state_type = value.type
      else
        state_type = "state"
      if icons == false
        $('.oh3-column-' + column_nr).append('<div class="oh3-row""><div class="' + value.name + '-name" id="name"></div><div class="' + value.name + '-state" id="' + state_type + '"></div></div>')
        $('.oh3-row #name').css('width', "70%")
        $('.oh3-row #name').css('padding-left', "0px")
        $('.oh3-row #state').css('width', "calc(25% - 4px)")
      else
        $('.oh3-column-' + column_nr).append('<div class="oh3-row"><div class="' + value.name + '-icon" id="icon"></div><div class="' + value.name + '-name" id="name" ></div><div class="' + value.name + '-state" id="' + state_type + '" ></div></div>')
        $('.oh3-row #name').css('width', "calc(70% - 20px)")
        $('.oh3-row #state').css('width', "calc(25% - 24px)")
      $('.oh3-row').css('width', '100%') #"calc(100% / " + columns + " - (4px * " + columns + "))")

update: (output, dom) ->
  data = JSON.parse(output)
  console.log("update")
  for data_key, data_value of data
    for items_key, items_value of items
      if data_value.name == items_value.name
        $(dom).find('.' + data_value.name + '-name').text(data_value.label)

        switch items_value.type
          when 'Switch'
            if data_value.state is 'ON'
              if oh_icons == true
                $(dom).find('.' + data_value.name + '-icon').html('<img src="https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/switch-on.svg" width="20" height="20" >')
              else
                $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.41666)"><path   d="M24 14c-5.52 0-10 4.48-10 10s4.48 10 10 10 10-4.48 10-10 -4.48-10-10-10Zm0-10C12.95 4 4 12.95 4 24c0 11.05 8.95 20 20 20s20-8.95 20-20 -8.95-20-20-20Zm0 36c-8.84 0-16-7.16-16-16s7.16-16 16-16 16 7.16 16 16 -7.16 16-16 16Z"/><path fill="none" d="M0 0h48v48H0Z"/></g></svg>')
            else
              if oh_icons == true
                $(dom).find('.' + data_value.name + '-icon').html('<img src="https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/switch-off.svg" width="20" height="20" >')
              else
                $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.83333)"><path   d="M12 2C6.48 2 2 6.48 2 12c0 5.52 4.48 10 10 10s10-4.48 10-10 -4.48-10-10-10Zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8 -3.58 8-8 8Z" /><path fill="none" d="M0 0h24v24H0Z"/></g></svg>')
            $(dom).find('.' + data_value.name + '-state').text(data_value.state)
          when 'Contact'
            if data_value.state is 'ON'
              if oh_icons == true
                $(dom).find('.' + data_value.name + '-icon').html('<img src="https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/contact-open.svg" width="20" height="20" >')
              else
                $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.41666)"><path   d="M24 14c-5.52 0-10 4.48-10 10s4.48 10 10 10 10-4.48 10-10 -4.48-10-10-10Zm0-10C12.95 4 4 12.95 4 24c0 11.05 8.95 20 20 20s20-8.95 20-20 -8.95-20-20-20Zm0 36c-8.84 0-16-7.16-16-16s7.16-16 16-16 16 7.16 16 16 -7.16 16-16 16Z"/><path fill="none" d="M0 0h48v48H0Z"/></g></svg>')
            else
              if oh_icons == true
                $(dom).find('.' + data_value.name + '-icon').html('<img src="https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/contact-closed.svg" width="20" height="20" >')
              else
                $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.83333)"><path   d="M12 2C6.48 2 2 6.48 2 12c0 5.52 4.48 10 10 10s10-4.48 10-10 -4.48-10-10-10Zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8 -3.58 8-8 8Z" /><path fill="none" d="M0 0h24v24H0Z"/></g></svg>')
            $(dom).find('.' + data_value.name + '-state').text(data_value.state)
          when 'Light'
            console.log("test #{oh_icons}")
            if data_value.state is 'ON'
              if oh_icons == true
                  $(dom).find('.' + data_value.name + '-icon').html('<img src="https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/light-on.svg" width="20" height="20" >')
              else
                  $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="-3.55469 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.03906)"><g><path   d="M274.89 46.86V14.99c0-8.29-6.72-15-15-15H82.79c-8.29 0-15 6.71-15 15v31.86Z"/><path d="M67.79 76.86h207.09v40.86H67.78Z"/><path d="M143.82 253.58l19.59-12.2c2.42-1.51 5.17-2.27 7.92-2.27s5.5.75 7.92 2.26l19.59 12.19 -9.02-105.85h-37Z"/><path d="M219.95 147.73l11.34 133.12c.48 5.65-2.28 11.1-7.12 14.06 -2.41 1.47-5.13 2.21-7.84 2.21 -2.75 0-5.5-.76-7.93-2.27l-37.09-23.08 -37.08 23.07c-4.83 3-10.92 3.01-15.76.05 -4.84-2.97-7.6-8.41-7.12-14.07l11.34-133.125H67.31c-2.61 42.51-16.93 84.43-41.84 122.04C8.86 294.8.03 323.8-.06 353.6c-.26 86.1 72.8 157.13 162.85 158.32 .79 0 1.58.01 2.38.01 45.12 0 87.18-17.02 118.63-48.06 29.99-29.61 46.51-68.61 46.51-109.84 0-27.32-8.64-53.56-21.46-77.86 -21.59-40.93-34.05-128.53-34.05-128.53Z"/></g></g></svg>')
            else
              if oh_icons == true
                $(dom).find('.' + data_value.name + '-icon').html('<img src="https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/light-off.svg" width="20" height="20" >')
              else
                $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="-3.55469 0 20 20" xmlns="http://www.w3.org/2000/svg"><path   d="M308.94 276.25c-22.28-37.49-34.05-101.18-34.05-144.27v-117c0-8.29-6.72-15-15-15H82.79c-8.29 0-15 6.71-15 15v118.64c0 47.3-14.62 94.375-42.28 136.13C8.9 294.82.07 323.82-.02 353.62c-.26 86.1 72.8 157.13 162.85 158.32 .79 0 1.58.01 2.38.01 45.12 0 87.18-17.02 118.63-48.06 29.99-29.61 46.51-68.61 46.51-109.84 0-27.32-7.42-54.24-21.46-77.86Zm-110.08-22.68l-19.59-12.2c-2.43-1.51-5.18-2.27-7.93-2.27s-5.5.75-7.93 2.26l-19.59 12.19 9.01-105.85h36.99ZM97.79 117.72V88.85h147.09v28.86Zm0-87.74h147.09v28.86H97.78ZM262.8 442.56c-26.26 25.91-61.59 39.91-99.56 39.39 -73.69-.98-133.47-58.51-133.26-128.25 .07-23.93 7.17-47.24 20.53-67.41 28.18-42.56 44.26-90.21 46.88-138.61h25.32L111.36 280.8c-.49 5.65 2.27 11.1 7.11 14.06 4.83 2.96 10.94 2.94 15.75-.06l37.08-23.08 37.07 23.07c2.42 1.51 5.17 2.26 7.92 2.26 2.71 0 5.42-.74 7.83-2.21 4.84-2.97 7.59-8.42 7.11-14.07L219.88 147.64h24.94s6.63 91.59 38.25 143.84c11.43 18.89 17.24 40.6 17.24 62.53 0 33.13-13.35 64.55-37.59 88.47Z" transform="scale(.03906)"/></svg>')
            $(dom).find('.' + data_value.name + '-state').text(data_value.state)
          when 'Led-Stripe'
            if oh_icons == true
              if data_value.state is 'ON'
                $(dom).find('.' + data_value.name + '-icon').html('<img src="https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/light-on.svg" width="20" height="20" >')
              else
                $(dom).find('.' + data_value.name + '-icon').html('<img src="https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/light-off.svg" width="20" height="20" >')
            else
              $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.3125)"><g><path   d="M16 18l-.01-.001c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4l-.01 0c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M16 26l-.01-.001c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path    d="M16 42h-.01c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path    d="M16 50h-.01c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M16 58h-.01c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M16 34h-.01c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M12 62h8 -.01c.55 0 1-.45 1-1V12h6v41l-.01-.01c0 .26.1.51.29.7l8 8 -.01-.01c.18.18.44.29.7.29h8l0-.001c.26-.01.51-.11.7-.3l8-8 -.01 0c.18-.19.29-.45.29-.71v-50 0c0-.56-.45-1-1-1h-8 -.01c-.56 0-1 .44-1 1 0 0 0 0 0 0v49h-6v-49 0c0-.56-.45-1-1-1h-16l0-.001c-.27 0-.52.1-.71.29l-8 8 0-.01c-.19.18-.3.44-.3.7v50l0 0c0 .55.44.99 1 .99Zm33-13V4h6v48.586l-6 6Zm-8 5h6v6h-6Zm-8-5V4h6v54.586l-6-6ZM21 4h6v6h-6Zm-8 51V11.41l6-6V60h-6Z"/><path   d="M48 52h-.01c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M48 44h-.01c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M48 28l-.01-.001c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M48 20l-.01-.001c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path d="M48 12l-.01-.001c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4l-.01 0c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M48 36h-.01c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M32 52h-.01c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M32 44h-.01c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M32 28l-.01-.001c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M32 20l-.01-.001c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M32 12l-.01-.001c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4l-.01 0c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path   d="M32 36h-.01c1.65 0 3-1.35 3-3 0-1.66-1.35-3-3-3 -1.66-.01-3 1.34-3 3l0 0c0 1.65 1.34 2.99 3 2.99Zm0-4h-.01c.55-.01 1 .44 1 .99s-.45 1-1 1c-.56 0-1-.45-1.01-1l0 0c-.01-.56.44-1.01.99-1.01Z"/><path    d="M23 6h2v2h-2Z"/><path   d="M39 56h2v2h-2Z"/><path d="M4 31h5v2H4Z"/><path d="M6 25h2v5H6Z" transform="rotate(-53.1301 7 27.5)"/><path   d="M4.5 35.5h5v2h-5Z" transform="rotate(-36.8699 7.005 36.51)"/><path   d="M55 31h5v2h-5Z"/><path    d="M54.5 26.5h5v2h-5Z" transform="matrix(.8-.6.6.8-5.098 39.712)"/><path   d="M56 34h2v5h-2Z" transform="rotate(-53.1301 57 36.5)"/></g></g></svg>')
            $(dom).find('.' + data_value.name + '-state').text(data_value.state)
          when 'Dimmer'
            number = parseFloat(data_value.state)
            number_icon = Math.round(number / 10) * 10
            $(dom).find('.' + data_value.name + '-state').html(number.toFixed(dimmer_decimalplaces) + '%')
            if oh_icons == true
              $(dom).find('.' + data_value.name + '-icon').html("<img src='https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/slider-#{number_icon}.svg' width='20' height='20' >")
            else
              $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M271 183.51V257c0 8.28-6.72 15-15 15 -8.28 0-15-6.72-15-15v-73.49c-34.19 6.96-60 37.27-60 73.49 0 41.35 33.65 75 75 75s75-33.65 75-75c0-36.22-25.81-66.53-60-73.49Zm0 0V257c0 8.28-6.72 15-15 15 -8.28 0-15-6.72-15-15v-73.49c-34.19 6.96-60 37.27-60 73.49 0 41.35 33.65 75 75 75s75-33.65 75-75c0-36.22-25.81-66.53-60-73.49Zm0 0V257c0 8.28-6.72 15-15 15 -8.28 0-15-6.72-15-15v-73.49c-34.19 6.96-60 37.27-60 73.49 0 41.35 33.65 75 75 75s75-33.65 75-75c0-36.22-25.81-66.53-60-73.49Zm0 0V257c0 8.28-6.72 15-15 15 -8.28 0-15-6.72-15-15v-73.49c-34.19 6.96-60 37.27-60 73.49 0 41.35 33.65 75 75 75s75-33.65 75-75c0-36.22-25.81-66.53-60-73.49ZM436 0H76C51.19 0 31 20.19 31 45v422c0 24.81 20.19 45 45 45h360c24.81 0 45-20.19 45-45V45c0-24.81-20.19-45-45-45ZM106 60c8.28 0 15 6.72 15 15 0 8.28-6.72 15-15 15 -8.28 0-15-6.72-15-15 0-8.28 6.72-15 15-15Zm0 392c-8.28 0-15-6.72-15-15 0-8.28 6.72-15 15-15 8.28 0 15 6.72 15 15 0 8.28-6.72 15-15 15Zm150-90c-57.9 0-105-47.1-105-105s47.1-105 105-105 105 47.1 105 105 -47.1 105-105 105Zm123.73-50.98c21.97-50.53 10.61-110.6-28.27-149.48 -52.64-52.64-138.28-52.64-190.92 0 -38.88 38.88-50.24 98.95-28.27 149.48 3.31 7.59-.17 16.43-7.77 19.73 -7.59 3.31-16.43-.17-19.74-7.77 -26.604-61.166-14.16-133.95 34.57-182.65 64.33-64.34 169.01-64.34 233.34 0 48.738 48.71 61.16 121.49 34.57 182.65 -3.33 7.62-12.19 11.06-19.74 7.77 -7.6-3.3-11.08-12.14-7.77-19.73ZM406 452c-8.28 0-15-6.72-15-15 0-8.28 6.72-15 15-15 8.28 0 15 6.72 15 15 0 8.28-6.72 15-15 15Zm0-362c-8.28 0-15-6.72-15-15 0-8.28 6.72-15 15-15 8.28 0 15 6.72 15 15 0 8.28-6.72 15-15 15Zm-135 93.51V257c0 8.28-6.72 15-15 15 -8.28 0-15-6.72-15-15v-73.49c-34.19 6.96-60 37.27-60 73.49 0 41.35 33.65 75 75 75s75-33.65 75-75c0-36.22-25.81-66.53-60-73.49Zm0 0V257c0 8.28-6.72 15-15 15 -8.28 0-15-6.72-15-15v-73.49c-34.19 6.96-60 37.27-60 73.49 0 41.35 33.65 75 75 75s75-33.65 75-75c0-36.22-25.81-66.53-60-73.49Zm0 0V257c0 8.28-6.72 15-15 15 -8.28 0-15-6.72-15-15v-73.49c-34.19 6.96-60 37.27-60 73.49 0 41.35 33.65 75 75 75s75-33.65 75-75c0-36.22-25.81-66.53-60-73.49Z" transform="scale(.03906)"/></svg>')
          when 'Rollershutter'
            number_icon = Math.round(data_value.state / 10) * 10
            $(dom).find('.' + data_value.name + '-state').text(data_value.state + '%')
            if oh_icons == true
              $(dom).find('.' + data_value.name + '-icon').html("<img src='https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/rollershutter-#{number_icon}.svg' width='20' height='20' >")
            else
              $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.03906)"><g><path   d="M465.247 0H46.75c-7.44 0-13.48 6.047-13.48 13.48v333.96c0 4.02 3.26 7.28 7.28 7.28 4.02 0 7.28-3.27 7.28-7.29V14.55h416.3v48.9c0 4.02 3.26 7.28 7.28 7.28 4.02 0 7.28-3.27 7.28-7.29v-50c0-7.44-6.05-13.48-13.48-13.48Z"/><path   d="M495.222 459.59h-16.5V98.48c0-4.03-3.27-7.29-7.29-7.29 -4.03 0-7.29 3.26-7.29 7.28v361.108h-17.39v-187.78 -46.52 -46.52 -46.52 -46.52 -40.79c0-7.18-5.84-13.011-13.02-13.011h-33.94 -.01 -26.75H78.21c-7.18 0-13.02 5.837-13.02 13.011V85.71v46.51 46.51 46.51 46.51V459.53H47.8v-77.3c0-4.03-3.27-7.29-7.29-7.29 -4.03 0-7.29 3.26-7.29 7.28v77.298h-16.5c-7.116 0-12.904 5.78-12.904 12.9v26.59c0 7.11 5.788 12.9 12.904 12.9h478.444c7.11 0 12.9-5.79 12.9-12.91v-26.6c-.001-7.12-5.79-12.91-12.91-12.91Zm-88.12-413.07h25.08v31.94h-25.09V46.51Zm0 46.51h25.08v31.94h-25.09V93.02Zm0 46.51h25.08v31.94h-25.09v-31.95Zm0 46.51h25.08v31.94h-25.09v-31.95Zm-.01 46.51h0 25.08v31.94h-15.07 -10.03v-31.95Zm-26.75 39.22v-46.52 -46.52 -46.52V85.7 46.47h12.17V85.7v46.51 46.51 46.51 46.51 69.3c0 2.55-2.08 4.62-4.63 4.62h-2.92c-2.56 0-4.63-2.08-4.63-4.63v-69.31Zm4.62 88.5h2.91c10.58 0 19.2-8.62 19.2-19.21v-62.02h2.73v161.8h-135.87V279.04h91.81v62.02c0 10.58 8.61 19.2 19.2 19.2ZM79.78 46.48h285.973v31.94H79.77V46.47Zm0 46.51h285.97v31.94H79.77V92.98Zm0 46.51h285.97v31.94H79.77v-31.95Zm0 46.51h285.97v31.94H79.77V186Zm0 46.51h285.97v31.94h-99.101 -21.37H94.838h-15.07v-31.95ZM238 279.03v161.8H102.13V279.02H238Zm-158.219 0h7.77v162.88c0 7.44 6.05 13.49 13.497 13.49h138.02c7.44 0 13.49-6.06 13.49-13.5V279.01h6.79v162.88c0 7.44 6.05 13.49 13.49 13.49h138.02c7.44 0 13.49-6.06 13.49-13.5v-162.89h7.77v180.49H79.73v-180.5Zm413.74 218.32v0H18.41v-23.26h22.11 31.96 366.95 31.96 22.11v23.25Z"/></g></g></svg>')
          when 'Color'
            if oh_icons == true
              $(dom).find('.' + data_value.name + '-icon').html("<img src='https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/colorlight.svg' width='20' height='20' >")
            else
              $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.83333)"><path   d="M12 3c-4.97 0-9 4.03-9 9s4.03 9 9 9c.83 0 1.5-.67 1.5-1.5 0-.39-.15-.74-.39-1.01 -.23-.26-.38-.61-.38-.99 0-.83.67-1.5 1.5-1.5H16c2.76 0 5-2.24 5-5 0-4.42-4.03-8-9-8Zm-5.5 9c-.83 0-1.5-.67-1.5-1.5C5 9.67 5.67 9 6.5 9c.83 0 1.5.67 1.5 1.5s-.67 1.5-1.5 1.5Zm3-4C8.67 8 8 7.33 8 6.5 8 5.67 8.67 5 9.5 5c.83 0 1.5.67 1.5 1.5s-.67 1.5-1.5 1.5Zm5 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5 -.67 1.5-1.5 1.5Zm3 4c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5 -.67 1.5-1.5 1.5Z"/><path fill="none" d="M0 0h24v24H0Z"/></g></svg>')
              res = data_value.state.split(",");
              h = parseInt(res[0]) / 360
              s = parseInt(res[1]) / 360
              v = parseInt(res[2]) / 360
              i = Math.floor(h * 6);
              f = h * 6 - i;
              p = v * (1 - s);
              q = v * (1 - f * s);
              t = v * (1 - (1 - f) * s);
              switch (i % 6)
                when 0
                  r = v
                  g = t
                  b = p
                when 1
                  r = q
                  g = v
                  b = p
                when 2
                  r = p
                  g = v
                  b = t
                when 3
                  r = p
                  g = q
                  b = v
                when 4
                  r = t
                  g = p
                  b = v
                when 5
                  r = v
                  g = p
                  b = q
              rgb = "rgb(" + Math.round(r * 255) + ", " + Math.round(g * 255) + ", " + Math.round(b * 255)
              $(dom).find('.' + data_value.name + '-state').text(h)
              $(dom).find('.' + data_value.name + '-state').css('width', '20px')
              $(dom).find('.' + data_value.name + '-state').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.41666)"><path  id="svg" d="M24 14c-5.52 0-10 4.48-10 10s4.48 10 10 10 10-4.48 10-10 -4.48-10-10-10Zm0-10C12.95 4 4 12.95 4 24c0 11.05 8.95 20 20 20s20-8.95 20-20 -8.95-20-20-20Zm0 36c-8.84 0-16-7.16-16-16s7.16-16 16-16 16 7.16 16 16 -7.16 16-16 16Z"/><path fill="none" d="M0 0h48v48H0Z"/></g></svg>')
              $(dom).find('.' + data_value.name + '-state #svg').css('fill', rgb)
              $(dom).find('.' + data_value.name + '-state #svg').css('stroke', rgb)
          when 'DateTime'
            if oh_icons == true
              $(dom).find('.' + data_value.name + '-icon').html("<img src='https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/time.svg' width='20' height='20' >")
            else
              $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.41666)"><path   d="M18 22h-4v4h4v-4Zm8 0h-4v4h4v-4Zm8 0h-4v4h4v-4Zm4-14h-2V4h-4v4H16V4h-4v4h-2c-2.22 0-3.98 1.8-3.98 4L6 40c0 2.2 1.78 4 4 4h28c2.2 0 4-1.8 4-4V12c0-2.2-1.8-4-4-4Zm0 32H10V18h28v22Z"/><path fill="none" d="M0 0h48v48H0Z"/></g></svg>')
            $(dom).find('.' + data_value.name + '-state').text(data_value.state)
          when 'Location'
            if oh_icons == true
              $(dom).find('.' + data_value.name + '-icon').html("<img src='https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/zoom.svg' width='20' height='20' >")
            else
              $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.83333)"><path fill="none" d="M0 0h24v24H0Z"/><path   d="M12 8c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4 -1.79-4-4-4Zm8.94 3c-.46-4.17-3.77-7.48-7.94-7.94V1h-2v2.06C6.83 3.52 3.52 6.83 3.06 11H1v2h2.06c.46 4.17 3.77 7.48 7.94 7.94V23h2v-2.06c4.17-.46 7.48-3.77 7.94-7.94H23v-2h-2.06ZM12 19c-3.87 0-7-3.13-7-7s3.13-7 7-7 7 3.13 7 7 -3.13 7-7 7Z"/></g></svg>')
            $(dom).find('.' + data_value.name + '-state').text(data_value.state)
          when 'Number'
            if oh_icons == true
              $(dom).find('.' + data_value.name + '-icon').html("<img src='https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/text.svg' width='20' height='20' >")
            else
              $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.83333)"><path   d="M5 17v2h14v-2H5Zm4.5-4.2h5l.9 2.2h2.1L12.75 4h-1.5L6.5 15h2.1l.9-2.2ZM12 5.98L13.87 11h-3.74L12 5.98Z"/><path fill="none" d="M0 0h24v24H0Z"/></g></svg>')
            number = parseFloat(data_value.state)
            $(dom).find('.' + data_value.name + '-state').html('<span>' + number.toFixed(number_decimalplaces) + '</span>')
          when 'Player'
            if oh_icons == true
              $(dom).find('.' + data_value.name + '-icon').html("<img src='https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/player.svg' width='20' height='20' >")
            else
              $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.41666)"><path fill="none" d="M0 0h48v48H0Z"/><path   d="M20 33l12-9 -12-9v18Zm4-29C12.95 4 4 12.95 4 24c0 11.05 8.95 20 20 20s20-8.95 20-20 -8.95-20-20-20Zm0 36c-8.82 0-16-7.18-16-16s7.18-16 16-16 16 7.18 16 16 -7.18 16-16 16Z"/></g></svg>')
            $(dom).find('.' + data_value.name + '-state').text(data_value.state)
          when 'String'
            if oh_icons == true
              $(dom).find('.' + data_value.name + '-icon').html("<img src='https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/text.svg' width='20' height='20' >")
            else
              $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.83333)"><path   d="M5 17v2h14v-2H5Zm4.5-4.2h5l.9 2.2h2.1L12.75 4h-1.5L6.5 15h2.1l.9-2.2ZM12 5.98L13.87 11h-3.74L12 5.98Z"/><path fill="none" d="M0 0h24v24H0Z"/></g></svg>')
            $(dom).find('.' + data_value.name + '-state').html('<span>' + data_value.state + '</span>')
          when 'Temperature'
            if oh_icons == true
              $(dom).find('.' + data_value.name + '-icon').html("<img src='https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/temperature.svg' width='20' height='20' >")
            else
              $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.11102)"><path d="M116.7 104.542V26.631C116.7 11.946 104.75 0 90.06 0 75.37 0 63.42 11.946 63.42 26.63v77.91c-10.02 8.04-15.88 20.13-15.88 33.09 0 23.44 19.07 42.51 42.51 42.51 23.44 0 42.51-19.08 42.51-42.52 0-12.96-5.87-25.05-15.88-33.1Zm-26.64 60.6c-15.17 0-27.52-12.35-27.52-27.52 0-9.29 4.66-17.89 12.48-23.01 2.11-1.39 3.39-3.75 3.39-6.28V26.6c0-6.413 5.21-11.631 11.63-11.631 6.41 0 11.637 5.218 11.637 11.631v81.722c0 2.52 1.27 4.88 3.39 6.27 7.82 5.12 12.49 13.72 12.49 23 0 15.17-12.35 27.51-27.52 27.51Z"/></g></svg>')
            $(dom).find('.' + data_value.name + '-state').html('<span>' + data_value.state + '</span>')
          when 'Humidity'
            if oh_icons == true
              number_icon = Math.round(data_value.state / 10) * 10
              $(dom).find('.' + data_value.name + '-icon').html("<img src='https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/humidity-#{number_icon}.svg' width='20' height='20' >")
            else
              $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.03906)"><g><path d="M344.86 112.832c-26.18-33.408-53.25-67.91-75.072-104.96 -2.88-4.87-8.13-7.88-13.8-7.88s-10.92 3.008-13.76 7.872c-21.83 37.024-48.9 71.55-75.072 104.928 -53.06 67.64-103.168 131.55-103.168 207.2 0 105.88 86.112 192 192 192 105.88 0 192-86.12 192-192 0-75.62-50.08-139.52-103.14-207.168ZM255.99 480c-88.23 0-160-71.78-160-160 0-64.608 46.78-124.256 96.35-187.46 21.63-27.59 43.84-55.91 63.64-86.24 19.8 30.336 42.01 58.688 63.64 86.27 49.56 63.16 96.35 122.84 96.35 187.42 0 88.22-71.78 160-160 160Z"/><path d="M208 192c-26.464 0-48 21.536-48 48s21.536 48 48 48 48-21.536 48-48 -21.536-48-48-48Zm0 64c-8.84 0-16-7.17-16-16 0-8.84 7.16-16 16-16 8.83 0 16 7.16 16 16 0 8.83-7.17 16-16 16Z"/><path d="M304 352c-26.464 0-48 21.536-48 48s21.536 48 48 48 48-21.536 48-48 -21.536-48-48-48Zm0 64c-8.8 0-16-7.2-16-16s7.2-16 16-16 16 7.2 16 16 -7.2 16-16 16Z"/><path d="M347.29 228.7c-6.24-6.24-16.39-6.24-22.63 0l-160 160c-6.24 6.24-6.24 16.38 0 22.62 3.13 3.1 7.23 4.67 11.32 4.67s8.19-1.57 11.29-4.68l160-160c6.24-6.24 6.24-16.39-.001-22.63Z"/></g></g></svg>')
            $(dom).find('.' + data_value.name + '-state').html('<span>' + data_value.state + '</span>')
          when 'Heating'
            if data_value.state is 'ON'
              if oh_icons == true
                $(dom).find('.' + data_value.name + '-icon').html("<img src='https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/heating-on.svg' width='20' height='20' >")
              else
                $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.03906)"><path d="M503.467 460.8h-8.54V384c0-4.72-3.83-8.54-8.54-8.54H418.12V136.52h42.66c4.71 0 8.53-3.82 8.53-8.54v-6.97c9.91 3.53 17.06 12.91 17.06 24.03 0 4.71 3.82 8.53 8.53 8.53 4.71 0 8.53-3.82 8.53-8.54 0-14.01-6.88-26.351-17.34-34.14 10.45-7.79 17.33-20.13 17.33-34.14 0-4.72-3.83-8.54-8.54-8.54 -4.71 0-8.54 3.81-8.54 8.53 0 11.11-7.16 20.497-17.07 24.03V93.8c0-4.72-3.83-8.54-8.54-8.54h-42.67V25.51c0-14.11-11.48-25.592-25.6-25.592h-17.08c-14.12 0-25.6 11.486-25.6 25.591V85.25h-17.07V25.51c0-14.11-11.48-25.592-25.6-25.592h-17.08c-14.12 0-25.6 11.486-25.6 25.591V85.25h-17.07V25.51c0-14.11-11.48-25.592-25.6-25.592h-17.08c-14.12 0-25.6 11.486-25.6 25.591V85.25h-17.07V25.51C162 11.4 150.53-.08 136.41-.08h-17.08c-14.12 0-25.6 11.486-25.6 25.591V85.25H59.59V68.18c0-4.72-3.83-8.54-8.54-8.54H8.38c-4.71-.01-8.54 3.81-8.54 8.53v85.33c0 4.71 3.823 8.53 8.533 8.53H51.04c4.71 0 8.53-3.82 8.53-8.54v-17.07H93.7v238.93H25.43c-4.71 0-8.54 3.81-8.54 8.53v76.8H8.35c-4.71 0-8.533 3.81-8.533 8.53v34.13c0 4.72 3.823 8.53 8.533 8.53H76.62c4.71 0 8.53-3.82 8.53-8.54v-34.14c0-4.72-3.83-8.54-8.54-8.54h-8.54v-34.14h25.6v59.74c0 14.1 11.48 25.59 25.6 25.59h17.07c14.11 0 25.59-11.49 25.59-25.6v-59.75h17.06v59.74c0 14.1 11.48 25.59 25.6 25.59h17.07c14.11 0 25.59-11.49 25.59-25.6v-59.75h17.06v59.74c0 14.1 11.48 25.59 25.6 25.59h17.07c14.11 0 25.59-11.49 25.59-25.6v-59.75h17.06v59.74c0 14.1 11.48 25.59 25.6 25.59h17.07c14.11 0 25.59-11.49 25.59-25.6v-59.75h25.6v34.13h-8.54c-4.71 0-8.54 3.81-8.54 8.53v34.13c0 4.71 3.82 8.53 8.53 8.53h68.267c4.71 0 8.53-3.82 8.53-8.54v-34.14c0-4.72-3.83-8.54-8.54-8.54Zm-85.334-358.4h34.13v17.06h-34.14v-17.07ZM93.863 409.6h-34.14c-4.71 0-8.54 3.81-8.54 8.53v42.66H34.116V392.52h59.73v17.06Zm-.001-290.14H59.72v-17.07h34.13v17.06Zm85.33 290.13h-17.07v-17.07h17.06v17.06Zm0-34.14h-17.07V136.51h17.06V375.45Zm0-256h-17.07v-17.07h17.06v17.06Zm85.33 290.13h-17.07v-17.07h17.06v17.06Zm0-34.14h-17.07V136.5h17.06V375.44Zm0-256h-17.07v-17.07h17.06v17.06Zm85.33 290.13h-17.07V392.5h17.06v17.06Zm0-34.14h-17.07V136.49h17.06V375.43Zm0-256h-17.07v-17.07h17.06v17.06Zm128 341.33h-17.07v-42.67c0-4.72-3.83-8.54-8.54-8.54h-34.14v-17.07h59.73v68.267Z"/></g></svg>')
            else
              if oh_icons == true
                $(dom).find('.' + data_value.name + '-icon').html("<img src='https://raw.githubusercontent.com/eclipse-archived/smarthome/master/extensions/ui/iconset/org.eclipse.smarthome.ui.iconset.classic/icons/heating-off.svg' width='20' height='20' >")
              else
                $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g transform="scale(.03906)"><g><path d="M136.542 0h-17.08c-14.12 0-25.6 11.486-25.6 25.591v460.817c0 14.1 11.48 25.59 25.6 25.59h17.07c14.11 0 25.59-11.49 25.59-25.6V25.58c0-14.11-11.48-25.6-25.6-25.6Zm8.52 486.409c0 4.7-3.83 8.52-8.53 8.52h-17.08c-4.71 0-8.54-3.83-8.54-8.53V25.58c0-4.71 3.83-8.53 8.53-8.53h17.07c4.7 0 8.52 3.82 8.52 8.52v460.818Z"/><path d="M221.875 0h-17.08c-14.12 0-25.6 11.486-25.6 25.591v460.817c0 14.1 11.48 25.59 25.6 25.59h17.07c14.11 0 25.59-11.49 25.59-25.6V25.58c0-14.11-11.48-25.6-25.6-25.6Zm8.52 486.409c0 4.7-3.83 8.52-8.53 8.52h-17.08c-4.71 0-8.54-3.83-8.54-8.53V25.58c0-4.71 3.83-8.53 8.53-8.53h17.07c4.7 0 8.52 3.82 8.52 8.52v460.818Z"/><path d="M307.209 0h-17.08c-14.12 0-25.6 11.486-25.6 25.591v460.817c0 14.1 11.48 25.59 25.6 25.59h17.07c14.11 0 25.59-11.49 25.59-25.6V25.58c0-14.11-11.48-25.6-25.6-25.6Zm8.52 486.409c0 4.7-3.83 8.52-8.53 8.52h-17.08c-4.71 0-8.54-3.83-8.54-8.53V25.58c0-4.71 3.83-8.53 8.53-8.53h17.07c4.7 0 8.52 3.82 8.52 8.52v460.818Z"/><path d="M392.54 0h-17.08c-14.12 0-25.6 11.486-25.6 25.591v460.817c0 14.1 11.48 25.59 25.6 25.59h17.07c14.11 0 25.59-11.49 25.59-25.6V25.58c-.001-14.11-11.48-25.6-25.6-25.6Zm8.52 486.409c0 4.7-3.83 8.52-8.53 8.52h-17.08c-4.71 0-8.54-3.83-8.54-8.53V25.58c0-4.71 3.83-8.53 8.53-8.53h17.07c4.7 0 8.52 3.82 8.52 8.52v460.818Z"/><path d="M187.73 375.467h-34.14c-4.71 0-8.54 3.81-8.54 8.53v34.13c0 4.71 3.82 8.53 8.53 8.53h34.13c4.71 0 8.53-3.82 8.53-8.54v-34.14c0-4.72-3.83-8.54-8.54-8.54Zm-8.54 34.13h-17.07v-17.07h17.06v17.06Z"/><path d="M273.067 375.467h-34.14c-4.71 0-8.54 3.81-8.54 8.53v34.13c0 4.71 3.82 8.53 8.53 8.53h34.13c4.71 0 8.53-3.82 8.53-8.54v-34.14c0-4.72-3.83-8.54-8.54-8.54Zm-8.54 34.13h-17.07v-17.07h17.06v17.06Z"/><path d="M358.4 375.467h-34.14c-4.71 0-8.54 3.81-8.54 8.53v34.13c0 4.71 3.82 8.53 8.53 8.53h34.13c4.71 0 8.53-3.82 8.53-8.54v-34.14c-.001-4.72-3.83-8.54-8.54-8.54Zm-8.54 34.13h-17.07v-17.07h17.06v17.06Z"/><path d="M460.8 85.333h-51.2c-4.71 0-8.54 3.81-8.54 8.53v34.134c0 4.71 3.82 8.53 8.53 8.53h51.2c4.71 0 8.53-3.82 8.53-8.54v-34.14c-.001-4.72-3.83-8.54-8.54-8.54Zm-8.54 34.13h-34.14v-17.07h34.13v17.06Z"/><path d="M187.73 85.333h-34.14c-4.71 0-8.54 3.81-8.54 8.53v34.134c0 4.71 3.82 8.53 8.53 8.53h34.13c4.71 0 8.53-3.82 8.53-8.54v-34.14c0-4.72-3.83-8.54-8.54-8.54Zm-8.54 34.13h-17.07v-17.07h17.06v17.06Z"/><path d="M273.067 85.333h-34.14c-4.71 0-8.54 3.81-8.54 8.53v34.134c0 4.71 3.82 8.53 8.53 8.53h34.13c4.71 0 8.53-3.82 8.53-8.54v-34.14c0-4.72-3.83-8.54-8.54-8.54Zm-8.54 34.13h-17.07v-17.07h17.06v17.06Z"/><path d="M358.4 85.333h-34.14c-4.71 0-8.54 3.81-8.54 8.53v34.134c0 4.71 3.82 8.53 8.53 8.53h34.13c4.71 0 8.53-3.82 8.53-8.54v-34.14c-.001-4.72-3.83-8.54-8.54-8.54Zm-8.54 34.13h-17.07v-17.07h17.06v17.06Z"/><path d="M102.4 85.333H51.2c-4.71 0-8.54 3.81-8.54 8.53v34.134c0 4.71 3.82 8.53 8.53 8.53h51.2c4.71 0 8.53-3.82 8.53-8.54v-34.14c0-4.72-3.83-8.54-8.54-8.54Zm-8.54 34.13H59.72v-17.07h34.13v17.06Z"/><path d="M51.2 59.73H8.53c-4.71 0-8.54 3.81-8.54 8.53v85.33c0 4.71 3.823 8.53 8.533 8.53H51.19c4.71 0 8.53-3.82 8.53-8.54V68.24c0-4.72-3.83-8.54-8.54-8.54Zm-8.54 85.334h-25.6v-68.27h25.6v68.26Z"/><path d="M460.8 102.4c-4.71 0-8.54 3.81-8.54 8.53 0 4.71 3.82 8.53 8.53 8.53 14.11 0 25.6 11.48 25.6 25.6 0 4.71 3.82 8.53 8.53 8.53 4.71 0 8.53-3.82 8.53-8.54 0-23.53-19.14-42.666-42.67-42.666Z"/><path d="M494.93 68.26c-4.71 0-8.54 3.81-8.54 8.53 0 14.11-11.49 25.6-25.6 25.6 -4.71 0-8.54 3.81-8.54 8.53 0 4.71 3.82 8.53 8.53 8.53 23.52 0 42.66-19.14 42.66-42.667 0-4.72-3.83-8.54-8.54-8.54Z"/><path d="M486.4 375.467h-76.8c-4.71 0-8.54 3.81-8.54 8.53v34.13c0 4.71 3.82 8.53 8.53 8.53h34.13v42.66c0 4.71 3.82 8.53 8.53 8.53h34.13c4.71 0 8.53-3.82 8.53-8.54v-85.34c-.001-4.72-3.83-8.54-8.54-8.54Zm-8.54 85.33h-17.07v-42.67c0-4.72-3.83-8.54-8.54-8.54h-34.14v-17.07h59.73v68.267Z"/><path d="M102.4 375.467H25.6c-4.71 0-8.54 3.81-8.54 8.53v85.33c0 4.71 3.82 8.53 8.53 8.53H59.72c4.71 0 8.53-3.82 8.53-8.54v-42.67h34.134c4.71 0 8.53-3.82 8.53-8.54v-34.14c0-4.72-3.83-8.54-8.54-8.54Zm-8.54 34.13H59.72c-4.71 0-8.54 3.81-8.54 8.53v42.66H34.11V392.52h59.73v17.06Z"/><path d="M76.8 460.8H8.53c-4.71 0-8.54 3.81-8.54 8.53v34.13c0 4.72 3.823 8.53 8.533 8.53H76.79c4.71 0 8.53-3.82 8.53-8.54v-34.14c0-4.72-3.83-8.54-8.54-8.54Zm-8.54 34.13h-51.2v-17.07h51.2v17.06Z"/><path d="M503.467 460.8H435.2c-4.71 0-8.54 3.81-8.54 8.53v34.13c0 4.71 3.82 8.53 8.53 8.53h68.267c4.71 0 8.53-3.82 8.53-8.54v-34.14c0-4.72-3.83-8.54-8.54-8.54Zm-8.54 34.13h-51.2v-17.07h51.2v17.06Z"/></g></g></svg>')
            $(dom).find('.' + data_value.name + '-state').text(data_value.state)
          else
            $(dom).find('.' + data_value.name + '-icon').html('<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"></svg>')
            $(dom).find('.' + data_value.name + '-state').text(data_value.state)