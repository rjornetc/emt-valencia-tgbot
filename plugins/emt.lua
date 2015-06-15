do

-- py = require 'python'
-- 
-- sum_from_python = py.import "get_stop_times".get_stop_times

help = "NAME\n"..
       "⠀emt - Valence EMT\n"..
       "⠀⠀⠀public transport\n"..
       "⠀⠀⠀information\n"..
           
       "SYNOPSIS\n"..
       "⠀/emt [-t STOP-NUMBER] [-v]\n"..
       "⠀/emt [-s] STRING [-v]\n"..
       "⠀/emt -h\n\n"..
           
       "DESCRIPTION\n"..            --| 
       "⠀-t=STOP-NUMBER\n"..
       "⠀⠀display stop timetable\n\n"..
           
       "⠀-s=STRING\n"..
       "⠀⠀search and show stops\n"..
       "⠀⠀that match the STRING\n\n"..
          
       "⠀-h\n"..
       "⠀⠀display this help\n\n"..
           
       "⠀no options\n"..
       "⠀⠀search and display\n"..
       "⠀⠀stops that matches\n"..
       "⠀⠀the STRING, if there\n"..
       "⠀⠀is a single stop that\n"..
       "⠀⠀matches, display its\n"..
       "⠀⠀timetable"

-- verbose = false
       
-- loglevelstrings = {"[CRITICAL]",
--                    "[ERROR]",
--                    "[WARNING]",
--                    "[INFO]",
--                    "[DEBUG]",
--                    "[DEBUG - WAITING]"}
-- loglevelemoji = {"✋",
--                  "❌",
--                  "⚠️",
--                  "ℹ️",
--                  "🐜",
--                  "⌛️"}
       
bus_lines = {{{'la Malva-rosa', 361},
              {'la Malva-rosa', 1006},
              {'la Malva-rosa', 349},
              {'la Malva-rosa', 350},
              {'la Malva-rosa', 351},
              {'la Malva-rosa', 352},
              {'la Malva-rosa', 2032},
              {'la Malva-rosa', 773},
              {'la Malva-rosa', 1260}}} -- General Palanca - Porta de la Mar (jardí)}

local function run(msg, matches)
  local receiver = get_receiver(msg)
  local cmd = matches[1].."-"
--   if cmd:match("%-test") ~= nil then
--     reply(msg, "0")
--     sleep(1)
--         reply(msg, "1")
-- --     send_msg(get_receiver(msg), "1", cb_function, cb_extra)
-- --     send_msg(get_receiver(msg), "1", ok_cb, false)
-- --     reply(msg, "1")
--     sleep(1)
--     co = coroutine.create(function ()
--             send_msg(get_receiver(msg), "2", cb_function, cb_extra)
--             send_msg(get_receiver(msg), "2", ok_cb, false)
--             reply(msg, "2")
--          end)
--     coroutine.resume (co)
--     sleep(1)
--     reply(msg, "3")
--     sleep(1)
--     return "4"
--   end
  if cmd:match("%-%a*v") ~= nil then
    verbose = true
  end
  if cmd:match("%-%a*h") ~= nil then
    return help
  elseif cmd:match("%-%a*t[% =](.*)%-") ~= nil then
    return get_stop_timetable_from_number(cmd:match("%-%a*t[% =](.*)%-"))
  elseif cmd:match("%-%a*s[% =](.*)%-") ~= nil then
    return suggestions_to_string(
                get_suggestions(
                    cmd:match("%-%a*s[% =](.*)%-")
                ),
                cmd:match("%-%a*s[% =](.*)%-")
    )
--   elseif cmd:match("%-.+") ~= nil then
--     return "Invalid argument: "..cmd:match("%-(.*)")
  else
    return general(matches[1])
  end
end

function trace()
    
end

function reply(msg, text)
    send_large_msg(get_receiver(msg), text)
end
    
function get_stop_timetable_from_number(number)
    if tonumber(number) == nil then
        return "Error: \""..number.."\" is not a number"
    else
        local suggestions = get_suggestions(number)
        for i, suggestion in ipairs(suggestions) do
            if suggestion:find("^"..number.."% (.*)$") ~= nil then
            return get_stop_times(suggestion, '', 0, 'Anonimo', 'en')
            end
        end
        return "Error: "..number.." stop does not exist :/"
    end
    
end

    
function general(cmd)
  
  
  if tonumber(cmd) ~= nil then
    return get_stop_timetable_from_number(cmd)
  else
    local suggestions = get_suggestions(cmd)
  
    local len = 0
  
    for i, stop in ipairs(suggestions) do
      len=i
    end
  
  
    if len == 1 then
      return get_stop_times(suggestions[1], '', 0, 'Anonimo', 'en')
    else
      return suggestions_to_string(suggestions, cmd)
    end
    
    
  end
end


function suggestions_to_string(suggestions, string)
  
    local len = 0
  
    for i, stop in ipairs(suggestions) do
      len=i
    end
  
    local out = "Suggested stops for "..string.."\n──────────────────\n"
  
    if len == 0 then
      out = out.."No stop matches"
    else
      for i, suggestion in ipairs(suggestions) do
        out = out..correct_valencian_string(suggestion).."\n"
      end
    end
    
    return out
    
end

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end


function correct_valencian_string(string)
    return string:gsub("l.l", "l·l") 
end

-- function get_stop_times(station, line='', adapted=0, user='Anonimo', lang='en')
function get_stop_times(station, line, adapted, user, lang)
    
    local handle = io.popen("python3 ./plugins/get_stop_times.py \""..station.."\"")
    local result = handle:read("*a")
    handle:close()
    
    
    local handle = io.popen("python3 ./plugins/get_stop_times.py \""..
                            station .. "," .. line .. "," .. adapted .."\"")
    local accesible = handle:read("*a")
    handle:close()
    
    local accsesible_busses = {}
    
    for stop_line, stop in accesible:gmatch("title=\"(.-)\" width=\"25px\" height=\"25px\"></span><span class=\"llegadaHome\">&nbsp;&nbsp;(.-)<") do
        print(stop_line..stop)
        table.insert(accsesible_busses, (stop_line..stop))
    end
    
    local out = station .. "\n──────────────────\n"
    
    print(result)
    print(accesible)
    
    for stop_line, stop in result:gmatch("title=\"(.-)\" width=\"25px\" height=\"25px\"></span><span class=\"llegadaHome\">&nbsp;&nbsp;(.-)<") do
        print(stop_line..stop)
        local emoji = ''
        
        if stop:find("^(.*)DIVERTED LINE$") ~= nil then
            emoji = "🔀"
        elseif stop:find("^(.*)Next$") ~= nil then
            emoji = "⚠️"
        elseif stop:match("% (%d+)% min%.") ~= nil then
            minutes = tonumber(stop:match("(%d+)% min%."))
            if minutes <= 5 then
                emoji = "🔴"
            elseif minutes <= 20 then
                emoji = "🔵"
            else
                emoji = "⚫️"
            end
        elseif stop:match("% (%d+):(%d+)") ~= nil then

        hour = tonumber(stop:match("(%d+):"))%12
        minute = math.floor(tonumber((stop:match(":(%d+)"))+15)/30)
        
        print(hour, minute)
        
        if hour == 11 and minute == 2 or hour == 0 and minute == 0 then
          emoji = "🕛"
        elseif hour == 0 and minute == 1 then
          emoji = "🕧"
        elseif hour == 0 and minute == 2 or hour == 1 and minute == 0 then
          emoji = "🕐"
        elseif hour == 1 and minute == 1 then
          emoji = "🕜"
        elseif hour == 1 and minute == 2 or hour == 2 and minute == 0 then
          emoji = "🕑"
        elseif hour == 2 and minute == 1 then
          emoji = "🕝"
        elseif hour == 2 and minute == 2 or hour == 3 and minute == 0 then
          emoji = "🕒"
        elseif hour == 3 and minute == 1 then
          emoji = "🕞"
        elseif hour == 3 and minute == 2 or hour == 4 and minute == 0 then
          emoji = "🕓"
        elseif hour == 4 and minute == 1 then
          emoji = "🕟"
        elseif hour == 4 and minute == 2 or hour == 5 and minute == 0 then
          emoji = "🕔"
        elseif hour == 5 and minute == 1 then
          emoji = "🕠"
        elseif hour == 5 and minute == 2 or hour == 6 and minute == 0 then
          emoji = "🕕"
        elseif hour == 6 and minute == 1 then
          emoji = "🕡"
        elseif hour == 6 and minute == 2 or hour == 7 and minute == 0 then
          emoji = "🕖"
        elseif hour == 7 and minute == 1 then
          emoji = "🕢"
        elseif hour == 7 and minute == 2 or hour == 8 and minute == 0 then
          emoji = "🕗"
        elseif hour == 8 and minute == 1 then
          emoji = "🕣"
        elseif hour == 8 and minute == 2 or hour == 9 and minute == 0 then
          emoji = "🕘"
        elseif hour == 9 and minute == 1 then
          emoji = "🕤"
        elseif hour == 9 and minute == 2 or hour == 10 and minute == 0 then
          emoji = "🕙"
        elseif hour == 10 and minute == 1 then
          emoji = "🕥"
        elseif hour == 10 and minute == 2 or hour == 11 and minute == 0 then
          emoji = "🕚"
        elseif hour == 11 and minute == 1 then
          emoji = "🕦"
        end
      end
      
      local accesible = ""
      
      for i,accesible_bus in ipairs(accsesible_busses) do
          if stop_line..stop == accesible_bus then
              accesible = "♿"
          end
      end
      
      out = out  .. emoji .. " " .. accesible .. " " .. stop_line .. " "  .. correct_valencian_string(stop) .. "\n"
    end
    
    
    
    if out == station .. "\n──────────────────\n" then
        out = out..
              "Sorry, no buses expected\n"..
              "for the moment."
    end
    return out
end


function get_suggestions(cmd)
  local out = {}
    
  local url = 'https://www.emtvalencia.es/ciudadano/modules/mod_tiempo/sugiere_parada.php?'
  local data = "parada=".. (URL.escape(cmd) or "")

  local res, code = https.request(url..data)
  
  for stop in res:gmatch("(%d+.-)<") do
      table.insert(out, stop)
--     out = out .. stop .. "\n"
  end
  
  return out
end

return {
  description = "ASDF",
  usage = "!asdf: Send asdf",
  patterns = {"^/emt (.*)$"},
  run = run
}

end