do

usage_en = "EMT\n"..
            "⠀emt - Valence EMT\n"..
            "⠀⠀⠀public transport\n"..
            "⠀⠀⠀information\n\n"..
                
            "SYNOPSIS\n"..
            "⠀emt [stop] STOP-NUMBER\n"..
            "⠀emt [suggest] STRING\n"..
            "⠀emt help\n\n"..
                
            "DESCRIPTION\n"..            --| 
            "⠀stop STOP-NUMBER\n"..
            "⠀⠀display stop timetable\n\n"..
                
            "⠀suggest STRING\n"..
            "⠀⠀suggest and show stops\n"..
            "⠀⠀that match the STRING\n\n"..
                
            "⠀help\n"..
            "⠀⠀display this help\n\n"..
                
            "⠀no options\n"..
            "⠀⠀suggest and display\n"..
            "⠀⠀stops that matches\n"..
            "⠀⠀the STRING, if there\n"..
            "⠀⠀is a single stop that\n"..
            "⠀⠀matches, display its\n"..
            "⠀⠀timetable, if don't\n"..
            "⠀⠀list them all"

usage_es = "EMT\n"..
            "⠀emt - Información del\n"..
            "⠀⠀⠀transporte público\n"..
            "⠀⠀⠀EMT Valencia\n\n"..
                
            "SYNOPSIS\n"..
            "⠀emt [parada] NÚMERO\n"..
            "⠀emt [sugerir] TEXTO\n"..
            "⠀emt ayuda\n\n"..
                
            "DESCRIPTION\n"..            --| 
            "⠀parada NÚMERO\n"..
            "⠀⠀muestra el horario de\n"..
            "⠀⠀la parada\n\n"..
                
            "⠀sugerir TEXTO\n"..
            "⠀⠀busca y muesta las\n"..
            "⠀⠀paradas que coinciden\n"..
            "⠀⠀con el TEXTO\n\n"..
                
            "⠀ayuda\n"..
            "⠀⠀muestra esta ayuda\n\n"..
                
            "⠀sin opciones\n"..
            "⠀⠀busca y muestra las\n"..
            "⠀⠀paradas que coinciden\n"..
            "⠀⠀con el TEXTO\n"..
            "⠀⠀introducido, si\n"..
            "⠀⠀encuentra una única\n"..
            "⠀⠀parada, muestra su\n"..
            "⠀⠀horario, si no, las\n"..
            "⠀⠀lista todas"

usage_ca = "EMT\n"..
            "⠀emt - Informació del\n"..
            "⠀⠀⠀transport públic\n"..
            "⠀⠀⠀EMT València\n\n"..
                
            "SYNOPSIS\n"..
            "⠀emt [parada] NOMBRE\n"..
            "⠀emt [suggerir] TEXT\n"..
            "⠀emt ajuda\n\n"..
                
            "DESCRIPTION\n"..            --| 
            "⠀parada NOMBRE\n"..
            "⠀⠀mostra l'horari de la\n"..
            "⠀⠀parada\n\n"..
                
            "⠀suggerir TEXT\n"..
            "⠀⠀cerca y mostra les\n"..
            "⠀⠀parades que coincideixen\n"..
            "⠀⠀amb el TEXT\n\n"..
                
            "⠀ajuda\n"..
            "⠀⠀mostra aquesta ajuda\n\n"..
                
            "⠀sense opcions\n"..
            "⠀⠀busca i mostra les\n"..
            "⠀⠀parades que\n"..
            "⠀⠀coincideixen amb el\n"..
            "⠀⠀TEXT introduït, si\n"..
            "⠀⠀troba una única\n"..
            "⠀⠀parada, mostra el seu\n"..
            "⠀⠀horari, si no, les\n"..
            "⠀⠀llista totes"


local function run(msg, matches)
    local input = matches[1]:lower()
    local command = input:match("^(%w*)")
    if command == "emt" then
        return emt(msg, input:match("^emt%s*(.*)%s*$"))
    else
        return command .. " is not a valid command, try with \"emt\"\n"..
               command .. " no es un comando válido, prueba con \"emt\"\n"..
               command .. " no és una ordre vàlida, prova amb \"emt\"\n"
    end
end
        
function emt(msg, input)
    print(input)
    local receiver = get_receiver(msg)
    if input == "" then
        return "Use \"emt help\" to get the bot usage\n"..
               "Utiliza \"emt ayuda\" para obtener el uso del bot\n"..
               "Utilitza \"emt ajuda\" per obtindre l'ús del bot"
    elseif input:match("^help") ~= nil then
        return usage_en
    elseif input:match("^ayuda") ~= nil then
        return usage_es
    elseif input:match("^ajuda") ~= nil then
        return usage_ca
    --for stop number
    elseif input:match("^%d+$") ~= nil or
           input:match("^stop%s+%d+$") ~= nil or 
           input:match("^parada%s+%d+$") ~= nil or
           input:match("^parada%s+%d+$") ~= nil then
        return get_stop_timetable_from_number(input:match("(%d+)$"))
    elseif input:match("^suggest%s+") ~= nil or 
           input:match("^sugerir%s+") ~= nil or
           input:match("^suggerir%s+") ~= nil then
        return suggestions_to_string(get_suggestions(input:match("^%w+%s+(.*)")),input:match("^%w+%s+(.*)"))
    else
        return suggestions_to_string(get_suggestions(input),input)
    end
--   else
--     return general(matches[1])
--   end
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
        return "Error: "..number.." stop does not exist"
    end
    
end

    
function general(input)  
    if tonumber(input) ~= nil then
        return get_stop_timetable_from_number(input)
    else
        local suggestions = get_suggestions(input)
        local len = 0
  
        for i, stop in ipairs(suggestions) do
            len=i
        end
  
        if len == 1 then
            return get_stop_times(suggestions[1], '', 0, 'Anonimo', 'en')
        else
            return suggestions_to_string(suggestions, input)
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


function get_suggestions(input)
  local out = {}
    
  local url = 'https://www.emtvalencia.es/ciudadano/modules/mod_tiempo/sugiere_parada.php?'
  local data = "parada=".. (URL.escape(input) or "")

  local res, code = https.request(url..data)
  
  for stop in res:gmatch("(%d+.-)<") do
      table.insert(out, stop)
  end
  
  return out
end

return {
  description = "",
  usage = usage,
  patterns = {"(.*)"},
  run = run
}

end
