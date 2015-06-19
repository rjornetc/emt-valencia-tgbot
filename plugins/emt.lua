do

usage_en = "Use \"help search\" to get information about who to search the "..
    "stops along a street\n"..
    "Use \"help timetable\" to get information about who to get the "..
    "timetable of a stop\n"..
    "Castellano: ayuda\n"..
    "Valencià: ajuda"

usage_es = "Usa \"ayuda buscar\" para obtener información sobre cómo buscar "..
    "las paradas de una calle\n"..
    "Usa \"ayuda horario\" para obtener información sobre cómo obtener el "..
    "horario de una parada\n"..
    "English: help\n"..
    "Valencià: ajuda"

usage_ca = "Usa \"ajuda cercar\" per obtenir informació sobre com buscar" ..
    "les parades d'un carrer\n" ..
    "Usa \"ajuda horari\" per obtenir informació sobre com obtenir el" ..
    "horari d'una parada\n"..
    "English: help\n"..
    "Castellano: ayuda"

usage_suggest_en = "Search the stops along a street\n" ..
    "━━━━━━━━━━━━━━━━━━\n" ..
    "To suggest stops for a particular street must enter the name (full or "..
    "partial) of the street.\n\n" ..

    "For example\n" ..
    "──────────────────\n" ..
    "For Tarongers street stops can be entered:\n" ..
    "taron\n" ..
    "tarongers\n" ..
    "...\n" ..
    "╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴\n" ..
    "For Blasco Ibañez street stops can be entered:\n" ..
    "blas\n" ..
    "Blasco\n" ..
    "Blasco Ibañez\n" ..
    "..."

usage_stop_en = "Get a stop timetable\n" ..
    "━━━━━━━━━━━━━━━━━━\n\n" ..

    "For the timetable of a stop introduce the number of this stop.\n\n" ..

    "For example\n" ..
    "──────────────────\n" ..
    "For the 1489 stop timetable:\n" ..
    "1489"

usage_suggest_es = "Buscar las paradas de una calle\n"..
    "━━━━━━━━━━━━━━━━━━\n"..
    "Para obtener las paradas sugeridas para una determinada calle ha de "..
    "introducirse el nombre (completo o parcial) de la calle.\n\n"..
    
    "Por ejemplo\n"..
    "──────────────────\n"..
    "Para obtener las paradas de Tarongers puede introducirse:\n"..
    "taron\n"..
    "tarongers\n"..
    "...\n"..
    "╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴\n"..
    "Para obtener las paradas de Blasco Ibañez puede introducirse:\n"..
    "blas\n"..
    "blasco\n"..
    "blasco ibañez\n"..
    "..."
    
usage_stop_es = "Obtener horario de una parada\n"..
    "━━━━━━━━━━━━━━━━━━\n\n"..
    
    "Para obtener el horario de una parada a de introducirse el número de la "..
    "misma.\n\n"..
    
    "Por ejemplo\n"..
    "──────────────────\n"..
    "Para obtener el horario de la parada 1489:\n"..
    "1489"

usage_suggest_ca = "Cercar les parades d'un carrer\n"..
    "━━━━━━━━━━━━━━━━━━\n\n"..
    "Per obtenir les parades suggerides per un determinat carrer cal "..
    "introduir-se el nom (complet o parcial) del carrer.\n\n"..
    
    "Per exemple\n"..
    "──────────────────\n"..
    "Per obtenir les parades de Tarongers pot introduir-se:\n"..
    "taron\n"..
    "tarongers\n"..
    "...\n"..
    "╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴╴\n"..
    "Per obtenir les parades de Blasco Ibañez pot introduir-se:\n"..
    "blas\n"..
    "blasco\n"..
    "blasco ibañez\n"..
    "..."

usage_stop_ca = "Obtenir horari d'una parada\n"..
    "━━━━━━━━━━━━━━━━━━\n\n"..

    "Per obtenir l'horari d'una parada a d'introduir-se el número de la"..
    "mateixa.\n\n"..

    "Per exemple\n"..
    "──────────────────\n"..
    "Per obtenir l'horari de la parada 1489:\n" ..
    "1489"

local function run(msg, matches)
    local input = matches[1]:lower()
    local command = input:match("^(.-)%s")
    if      input == "help" then
        return usage_en
    elseif  input == "help search" then
        return usage_suggest_en
    elseif  input == "help timetable" then
        return usage_stop_en
    elseif  input == "ayuda" then
        return usage_es
    elseif  input == "ayuda buscar" then
        return usage_suggest_es
    elseif  input == "ayuda horario" then
        return usage_stop_es
    elseif  input == "ajuda" then
        return usage_ca
    elseif  input == "ajuda cercar" then
        return usage_en
    elseif  input == "ajuda horari" then
        return usage_en
    else
        return emt(msg, input)
--     else
--         return command .. " is not a valid command, try with \"emt\"\n"..
--                command .. " no es un comando válido, prueba con \"emt\"\n"..
--                command .. " no és una ordre vàlida, prova amb \"emt\"\n"
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
